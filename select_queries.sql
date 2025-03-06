-- SQL-запити для аналізу даних
-- 1. Вибірка всіх даних із певної таблиці
SELECT * FROM Analysis;

-- 2. Вибірка з умовою (WHERE)
SELECT * FROM LabOrder WHERE status = 'Pending';

-- 3. Сортування (ORDER BY)
SELECT * FROM Patient ORDER BY birth_date DESC;

-- 4. Групування (GROUP BY + HAVING)
SELECT doctor_id, COUNT(*) AS referrals FROM LabOrder GROUP BY doctor_id HAVING COUNT(*) > 1;

-- 5. Об'єднання таблиць (JOIN)
SELECT Patient.name, Analysis.name, LabOrder.status FROM LabOrder
JOIN Patient ON LabOrder.patient_id = Patient.id
JOIN Analysis ON LabOrder.analysis_id = Analysis.id;

-- 6. Використання агрегатних функцій (COUNT, AVG, SUM тощо)
-- Унікальні значення в певному стовпці
SELECT DISTINCT specialty FROM Doctor;

-- Максимальні та мінімальні значення певного параметра
SELECT MAX(price) AS max_price, MIN(price) AS min_price FROM Analysis;

-- Середня кількість замовлень на клієнта
SELECT patient_id, COUNT(*) AS order_count FROM LabOrder GROUP BY patient_id;

-- Кількість записів, що відповідають певній умові
SELECT COUNT(*) FROM LabOrder WHERE status = 'Completed';

-- Загальна сума всіх транзакцій
SELECT SUM(price) AS total_revenue FROM LabOrder JOIN Analysis ON LabOrder.analysis_id = Analysis.id;