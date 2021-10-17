USE OOVEO_Salon;

--1. Display all female staff’s data from MsStaff.
SELECT * FROM MsStaff
WHERE StaffGender = 'Female';

--2.	Display StaffName, and StaffSalary(obtained by adding ‘Rp.’ In front of StaffSalary) for every staff whose name contains ‘m’ character and has salary more than or equal to 10000000.

SELECT MsStaff.StaffName, 'Rp. ' + CAST(StaffSalary AS VARCHAR(1000)) AS StaffSalary
FROM MsStaff
WHERE StaffName LIKE '%m%' AND StaffSalary>='10000000';


--3.	Display TreatmentName, and Price for every treatment which type is 'message / spa' or 'beauty care'.


SELECT MsTreatment.TreatmentName, MsTreatment.Price
FROM MsTreatment
WHERE MsTreatment.TreatmentTypeId IN(
SELECT MsTreatmentType.TreatmentTypeId
FROM MsTreatmentType
WHERE MsTreatmentType.TreatmentTypeName LIKE 'message / spa' OR MsTreatmentType.TreatmentTypeName LIKE 'beauty care'); 

--4.	Display StaffName, StaffPosition, and TransactionDate (obtained from TransactionDate in Mon dd,yyyy format) for every staff who has salary between 7000000 and 10000000.

SELECT * FROM MsStaff

SELECT MsStaff.StaffName, MsStaff.StaffPosition, CONVERT(VARCHAR, TransactionDate, 107) AS TransactionDate
FROM HeaderSalonServices
JOIN MsStaff
ON MsStaff.StaffId = HeaderSalonServices.StaffId
WHERE MsStaff.StaffSalary BETWEEN 7000000 AND 10000000;

--5.	Display Name (obtained by taking the first character of customer’s name until character before space), Gender (obtained from first character of customer’s gender), and PaymentType for every transaction that is paid by ‘Debit’.

SELECT * FROM MsCustomer
SELECT * FROM HeaderSalonServices

SELECT  LEFT(MsCustomer.CustomerName, CHARINDEX(' ', CustomerName)) AS Name, SUBSTRING(MsCustomer.CustomerGender,1,1) AS 'Gender', HeaderSalonServices.PaymentType
FROM MsCustomer
JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE HeaderSalonServices.PaymentType = 'Debit';


--6.	Display Initial (obtained from first character of customer’s name and followed by first character of customer’s last name in uppercase format), and Day (obtained from the day when transaction happened ) for every transaction which the day difference with 24th December 2012 is less than 3 days. 

SELECT * FROM MsCustomer
SELECT UPPER(SUBSTRING(MsCustomer.CustomerName, 1, 1) + SUBSTRING(MsCustomer.CustomerName, CHARINDEX(' ', CustomerName + ' ')+1, 1)) AS Initial, 
		DATENAME (WEEKDAY, HeaderSalonServices.TransactionDate) AS 'Day'
FROM MsCustomer
JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE DATEDIFF(DD, '2012-12-24', HeaderSalonServices.TransactionDate) < 3 AND DATEDIFF(DD, HeaderSalonServices.TransactionDate, '2012-12-24') < 3;


--7.	Display TransactionDate, and CustomerName (obtained by taking the character after space until the last character in CustomerName) for every customer whose name contains space and did the transaction on Saturday. 

SELECT * FROM MsCustomer
SELECT HeaderSalonServices.TransactionDate,RIGHT(MsCustomer.CustomerName, CHARINDEX(' ', REVERSE(' ' + MsCustomer.CustomerName))) AS 'CustomerName'
FROM MsCustomer
JOIN HeaderSalonServices
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE HeaderSalonServices.CustomerId IN(
SELECT MsCustomer.CustomerId
FROM MsCustomer
WHERE MsCustomer.CustomerName LIKE '% %')
AND DATENAME(WEEKDAY, HeaderSalonServices.TransactionDate) = 'Saturday'; 




--8.	Display StaffName, CustomerName, CustomerPhone (obtained from customer’s phone by replacing ‘0’ with ‘+62’), and CustomerAddress for every customer whose name contains vowel character and handled by staff whose name contains at least 3 words. 

SELECT MsStaff.StaffName, MsCustomer.CustomerName, REPLACE(MsCustomer.CustomerPhone, '0', '+62') AS 'CustomerPhone', MsCustomer.CustomerAddress
FROM MsCustomer
JOIN HeaderSalonServices
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
JOIN MsStaff
ON HeaderSalonServices.StaffId = MsStaff.StaffId
WHERE MsCustomer.CustomerName LIKE '%A%' AND MsStaff.StaffName LIKE'% % %' OR 
				CustomerName LIKE '%I%' AND MsStaff.StaffName LIKE'% % %' OR
				CustomerName LIKE '%U%'AND MsStaff.StaffName LIKE'% % %' OR
				CustomerName LIKE '%E%' AND MsStaff.StaffName LIKE'% % %'OR
				CustomerName LIKE '%O%' AND MsStaff.StaffName LIKE'% % %' 

SELECT * FROM MsStaff

--9.	Display StaffName, TreatmentName, and Term of Transaction (obtained from the day  difference between transactionDate  and 24th December 2012) for every treatment which name is more than 20 characters or contains more than one word.


SELECT MsStaff.StaffName,
MsTreatment.TreatmentName,
[Term of Transaction] = DATEDIFF(DD, HeaderSalonServices.TransactionDate ,'2012-12-24') 
FROM MsTreatment
JOIN DetailSalonServices
ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
JOIN HeaderSalonServices
ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
JOIN MsStaff
ON MsStaff.StaffId = HeaderSalonServices.StaffId
WHERE LEN(MsTreatment.TreatmentName) > 20 OR MsTreatment.TreatmentName LIKE '% %'

--10.	Display TransactionDate, CustomerName, TreatmentName, Discount (obtainedby changing Price data type into int and multiply it by 20%), and PaymentType for every transaction which happened on 22th  day.


SELECT HeaderSalonServices.TransactionDate, MsCustomer.CustomerName, MsTreatment.TreatmentName, CAST(MsTreatment.Price AS INT) * 20/100 AS 'Discount', HeaderSalonServices.PaymentType
FROM HeaderSalonServices
JOIN MsCustomer
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
JOIN MsStaff
ON HeaderSalonServices.StaffId = MsStaff.StaffId
JOIN DetailSalonServices
ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
JOIN MsTreatment
ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
WHERE DATEPART(DD, HeaderSalonServices.TransactionDate) = 22


