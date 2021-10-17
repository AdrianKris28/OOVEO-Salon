USE OOVEO_Salon


--1.	Display TreatmentId, and TreatmentName for every treatment which id is ‘TM001’ or ‘TM002’.

SELECT MsTreatment.TreatmentId, MsTreatment.TreatmentName
FROM MsTreatment
WHERE MsTreatment.TreatmentId IN('TM001','TM002')


--2.	Display TreatmentName, and Price for every treatment which type  is not ‘Hair Treatment’ and ‘Message / Spa’.

SELECT MsTreatment.TreatmentName, MsTreatment.Price
FROM MsTreatment
WHERE MsTreatment.TreatmentTypeId IN(
SELECT MsTreatmentType.TreatmentTypeId
FROM MsTreatmentType
WHERE MsTreatmentType.TreatmentTypeName NOT IN('Hair Treatment', 'Message / Spa'))

--3.	Display CustomerName, CustomerPhone, and CustomerAddress for every customer whose name is more than 8 charactes and did transaction on Friday.

SELECT MsCustomer.CustomerName, MsCustomer.CustomerPhone, MsCustomer.CustomerAddress
FROM MsCustomer
WHERE LEN(MsCustomer.CustomerName) > 8 AND MsCustomer.CustomerId IN(
SELECT HeaderSalonServices.CustomerId
FROM HeaderSalonServices
WHERE DATENAME(WEEKDAY,HeaderSalonServices.TransactionDate) = 'Friday')

--4.	Display TreatmentTypeName, TreatmentName, and Price for every treatment that taken by customer whose name contains ‘Putra’ and happened on day 22th.

SELECT MsTreatmentType.TreatmentTypeName, MsTreatment.TreatmentName, MsTreatment.Price
FROM MsTreatmentType
JOIN MsTreatment
ON MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId
JOIN DetailSalonServices
ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
JOIN HeaderSalonServices
ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
JOIN MsCustomer
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE DATEPART(DAY,HeaderSalonServices.TransactionDate) = 22
AND MsCustomer.CustomerName LIKE '%putra%'

--5.	Display StaffName, CustomerName, and TransactionDate (obtained from TransactionDate in ‘Mon dd,yyyy’ format) for every treatment which the last character of treatmentid is an even number.

SELECT DISTINCT MsStaff.StaffName, MsCustomer.CustomerName, CONVERT(VARCHAR, TransactionDate, 107)
FROM MsStaff
JOIN HeaderSalonServices
ON HeaderSalonServices.StaffId = MsStaff.StaffId
JOIN MsCustomer
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
JOIN DetailSalonServices
ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
JOIN MsTreatment
ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
WHERE EXISTS(SELECT  MsTreatment.TreatmentId FROM MsTreatment
			WHERE RIGHT(TreatmentId, 1) % 2 = 0) AND RIGHT(MsTreatment.TreatmentId, 1) % 2 != 1


--6.	Display CustomerName, CustomerPhone, and CustomerAddress for every customer that was served by staff whose  name’s length is an odd number.

SELECT MsCustomer.CustomerName, MsCustomer.CustomerPhone, MsCustomer.CustomerAddress
FROM MsCustomer
JOIN HeaderSalonServices
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
JOIN MsStaff
ON MsStaff.StaffId = HeaderSalonServices.StaffId
WHERE EXISTS(SELECT * FROM MsStaff WHERE LEN(MsStaff.StaffName) % 2 = 1)
AND LEN(StaffName) % 2 != 0

--7.	Display ID (obtained form last 3 characters of StaffID), and  Name (obtained by taking character after the first space until character before second space in StaffName) for every staff whose name contains at least 3 words and  hasn’t served male customer .

SELECT DISTINCT RIGHT(MsStaff.StaffId, 3) AS ID, SUBSTRING(MsStaff.StaffName, CHARINDEX(' ', StaffName + ' ')+1, CHARINDEX(' ', MsStaff.StaffName+' ')+1) AS 'Name'
FROM MsStaff
JOIN HeaderSalonServices
ON HeaderSalonServices.StaffId = MsStaff.StaffId
WHERE MsStaff.StaffName LIKE('% % %')
AND
EXISTS(SELECT HeaderSalonServices.CustomerId
FROM HeaderSalonServices 
WHERE HeaderSalonServices.CustomerId IN(
SELECT MsCustomer.CustomerId
FROM MsCustomer
WHERE MsCustomer.CustomerGender NOT LIKE 'Male' AND MsCustomer.CustomerGender LIKE 'Female'))

--8.	Display TreatmentTypeName, TreatmentName, and Price for every treatment which price is higher than average of all treatment’s price.

SELECT MsTreatmentType.TreatmentTypeName, MsTreatment.TreatmentName, MsTreatment.Price
FROM MsTreatmentType, MsTreatment, (SELECT AVG(Price) AS 'x' FROM MsTreatment) AS Alias
WHERE MsTreatment.Price > Alias.x AND MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId

--CONCAT
--9.	Display StaffName, StaffPosition, and StaffSalary for every staff with highest salary or lowest salary.

SELECT MsStaff.StaffName, MsStaff.StaffPosition, MsStaff.StaffSalary
FROM MsStaff, (SELECT MAX(StaffSalary) AS 'max' FROM MsStaff) AS maksimal, (SELECT MIN(StaffSalary) AS 'min' FROM MsStaff) AS minimal
WHERE MsStaff.StaffSalary = maksimal.max
OR
MsStaff.StaffSalary = minimal.min

--10.

SELECT *
FROM
(SELECT MsCustomer.CustomerName, MsCustomer.CustomerPhone, MsCustomer.CustomerAddress, MAX(totalTreatment.x) AS 'Count Treatment'
FROM MsCustomer, HeaderSalonServices, DetailSalonServices, (SELECT HeaderSalonServices.TransactionId, COUNT(DetailSalonServices.TreatmentId) AS 'x'
															FROM HeaderSalonServices, DetailSalonServices
															WHERE HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
															GROUP BY HeaderSalonServices.TransactionId) AS totalTreatment
WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId AND HeaderSalonServices.TransactionId = totalTreatment.TransactionId
GROUP BY MsCustomer.CustomerName, MsCustomer.CustomerPhone, MsCustomer.CustomerAddress) AS test
WHERE test.[Count Treatment] IN(
SELECT MAX(totalTreatment.x) AS maksimal
FROM (SELECT HeaderSalonServices.TransactionId, COUNT(DetailSalonServices.TreatmentId) AS 'x'
															FROM HeaderSalonServices, DetailSalonServices
															WHERE HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
															GROUP BY HeaderSalonServices.TransactionId) AS totalTreatment)




