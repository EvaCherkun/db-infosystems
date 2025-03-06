-- lab3.sql
-- Лабораторна робота №3: Складні SQL-запити до БД медичної лабораторії

-- 1. Вибір усіх аналізів дорожче 500 грн
SELECT * FROM Analysis WHERE price > 500;

-- 2. Кількість тестів, які зробили пацієнти
SELECT COUNT(*) AS total_tests FROM LabOrder;

-- 3. Середня ціна аналізів
SELECT AVG(price) AS average_price FROM Analysis;

-- 4. Мінімальна та максимальна ціна аналізів
SELECT MIN(price) AS min_price, MAX(price) AS max_price FROM Analysis;

-- 5. Лікарі, які направляли пацієнтів (уникальні значення)
SELECT DISTINCT doctor_id FROM LabOrder;

-- 6. Всі аналізи та їх замовлення (INNER JOIN)
SELECT LabOrder.id, Patient.name, Analysis.name, Analysis.price 
FROM LabOrder
INNER JOIN Patient ON LabOrder.patient_id = Patient.id
INNER JOIN Analysis ON LabOrder.analysis_id = Analysis.id;

-- 7. Всі замовлення, включаючи ті, що не мають результату (LEFT JOIN)
SELECT LabOrder.id, Patient.name, Result.result_text
FROM LabOrder
LEFT JOIN Result ON LabOrder.id = Result.order_id
LEFT JOIN Patient ON LabOrder.patient_id = Patient.id;

-- 8. Всі результати, включаючи ті, що ще не мають аналізів (RIGHT JOIN)
SELECT LabOrder.id, Analysis.name, Result.result_text
FROM LabOrder
RIGHT JOIN Result ON LabOrder.id = Result.order_id
RIGHT JOIN Analysis ON LabOrder.analysis_id = Analysis.id;

-- 9. Всі можливі комбінації пацієнтів та аналізів (CROSS JOIN)
SELECT Patient.name, Analysis.name
FROM Patient
CROSS JOIN Analysis;

-- 10. Кількість тестів, виконаних кожним лікарем (GROUP BY + HAVING)
SELECT doctor_id, COUNT(*) AS total_tests
FROM LabOrder
GROUP BY doctor_id
HAVING COUNT(*) > 5;

-- 11. Пацієнти, які зробили більше одного тесту (SELF JOIN)
SELECT p1.id, p1.name
FROM Patient p1
JOIN LabOrder l1 ON p1.id = l1.patient_id
JOIN LabOrder l2 ON p1.id = l2.patient_id AND l1.id <> l2.id;

-- 12. Підзапит: Пацієнти, які здавали найдорожчий аналіз
SELECT name FROM Patient 
WHERE id IN (
    SELECT patient_id FROM LabOrder 
    WHERE analysis_id = (SELECT id FROM Analysis ORDER BY price DESC LIMIT 1)
);

-- 13. Всі пацієнти, які не здавали аналізи (NOT EXISTS)
SELECT * FROM Patient p 
WHERE NOT EXISTS (
    SELECT 1 FROM LabOrder l WHERE l.patient_id = p.id
);

-- 14. Операції над множинами: Пацієнти, які здавали аналізи, і лікарі, які робили направлення
SELECT name FROM Patient
UNION
SELECT name FROM Doctor;

-- 15. Операції над множинами: Пацієнти, які здавали аналізи, але не отримали результати
SELECT name FROM Patient
EXCEPT
SELECT name FROM Patient p
JOIN LabOrder l ON p.id = l.patient_id
JOIN Result r ON l.id = r.order_id;

-- 16. Операції над множинами: Пацієнти, які здавали аналізи у різних лікарів
SELECT patient_id FROM LabOrder GROUP BY patient_id HAVING COUNT(DISTINCT doctor_id) > 1;

-- 17. CTE: Кількість тестів, зроблених кожним лікарем
WITH test_counts AS (
    SELECT doctor_id, COUNT(*) AS total_tests FROM LabOrder GROUP BY doctor_id
)
SELECT * FROM test_counts WHERE total_tests > 5;

-- 18. Віконна функція: Накопичувальна сума вартості аналізів за датою
SELECT id, price, SUM(price) OVER (ORDER BY id) AS running_total
FROM Analysis;

-- 19. Віконна функція: Позиція аналізу за ціною (ранжування)
SELECT id, name, price, RANK() OVER (ORDER BY price DESC) AS rank
FROM Analysis;

-- 20. Віконна функція: Середня ціна аналізу по категоріях
SELECT id, name, price, AVG(price) OVER () AS avg_price
FROM Analysis;

-- 21. Визначити кількість пацієнтів, які отримали результати онлайн
SELECT COUNT(*) AS online_results 
FROM Result 
WHERE received_online = TRUE;

-- 22. Визначити середню точність результатів аналізів
SELECT AVG(accuracy_percentage) AS avg_accuracy FROM Result;

-- 23. Вивести всі аналізи, які дорожчі за середню ціну
SELECT * FROM Analysis 
WHERE price > (SELECT AVG(price) FROM Analysis);

-- 24. Визначити, які тести найчастіше замовляють (TOP 3)
SELECT analysis_id, COUNT(*) AS total_orders
FROM LabOrder
GROUP BY analysis_id
ORDER BY total_orders DESC
LIMIT 3;

-- 25. Вивести кількість пацієнтів, які здавали більше одного тесту
SELECT COUNT(*) AS patients_with_multiple_tests
FROM (SELECT patient_id FROM LabOrder GROUP BY patient_id HAVING COUNT(*) > 1) AS subquery;

-- 26. Визначити лікарів, які направили на тести більше 10 пацієнтів
SELECT doctor_id, COUNT(*) AS total_referrals
FROM LabOrder
GROUP BY doctor_id
HAVING COUNT(*) > 10;

-- 27. Визначити, скільки тестів зроблено за останній місяць
SELECT COUNT(*) AS tests_last_month
FROM LabOrder
WHERE order_date >= NOW() - INTERVAL '1 month';

-- 28. Знайти пацієнтів, які не здавали аналізи у певний період
SELECT * FROM Patient 
WHERE id NOT IN (
    SELECT DISTINCT patient_id FROM LabOrder 
    WHERE order_date BETWEEN '2024-01-01' AND '2024-02-01'
);

-- 29. Підрахувати кількість тестів для кожного статусу (групування)
SELECT status, COUNT(*) AS status_count
FROM LabOrder
GROUP BY status;

-- 30. Вивести пацієнтів, які мають незавершені тести
SELECT DISTINCT Patient.id, Patient.name 
FROM Patient
JOIN LabOrder ON Patient.id = LabOrder.patient_id
WHERE LabOrder.status = 'В процесі';

-- 31. Порахувати кількість тестів, які мають статус "потрібен повторний тест"
SELECT COUNT(*) AS retest_count
FROM LabOrder
WHERE status = 'Потрібен повторний тест';

-- 32. Вивести пацієнтів разом із кількістю тестів, які вони зробили (включити тих, хто ще не робив)
SELECT Patient.id, Patient.name, COUNT(LabOrder.id) AS total_tests
FROM Patient
LEFT JOIN LabOrder ON Patient.id = LabOrder.patient_id
GROUP BY Patient.id, Patient.name;

-- 33. Вивести топ-5 лікарів за кількістю направлень
SELECT Doctor.id, Doctor.name, COUNT(LabOrder.id) AS total_referrals
FROM Doctor
JOIN LabOrder ON Doctor.id = LabOrder.doctor_id
GROUP BY Doctor.id, Doctor.name
ORDER BY total_referrals DESC
LIMIT 5;

-- 34. Підрахувати, скільки пацієнтів отримали результати в електронному вигляді за певний період
SELECT COUNT(DISTINCT LabOrder.patient_id) AS online_patients
FROM LabOrder
JOIN Result ON LabOrder.id = Result.order_id
WHERE Result.received_online = TRUE
AND Result.result_date BETWEEN '2024-01-01' AND '2024-02-01';

-- 35. Використання віконної функції: ранжування пацієнтів за кількістю тестів
SELECT patient_id, COUNT(*) AS total_tests,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM LabOrder
GROUP BY patient_id;

-- 36. Визначити кількість тестів, виконаних для кожного місяця в поточному році
SELECT DATE_TRUNC('month', order_date) AS month, COUNT(*) AS total_tests
FROM LabOrder
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY month
ORDER BY month;

-- 37. Використання CTE: пацієнти, у яких середня вартість аналізів перевищує 500 грн
WITH PatientAvgPrice AS (
    SELECT patient_id, AVG(price) AS avg_price
    FROM LabOrder
    JOIN Analysis ON LabOrder.analysis_id = Analysis.id
    GROUP BY patient_id
)
SELECT Patient.name, PatientAvgPrice.avg_price
FROM Patient
JOIN PatientAvgPrice ON Patient.id = PatientAvgPrice.patient_id
WHERE avg_price > 500;

-- 38. Визначити пацієнтів, які зробили більше тестів, ніж середня кількість
SELECT patient_id, COUNT(*) AS total_tests
FROM LabOrder
GROUP BY patient_id
HAVING COUNT(*) > (SELECT AVG(test_count) FROM (SELECT COUNT(*) AS test_count FROM LabOrder GROUP BY patient_id) AS subquery);

-- 39. Знайти пацієнтів, які зробили найдорожчі тести
SELECT DISTINCT Patient.name, Analysis.name, Analysis.price
FROM Patient
JOIN LabOrder ON Patient.id = LabOrder.patient_id
JOIN Analysis ON LabOrder.analysis_id = Analysis.id
WHERE Analysis.price = (SELECT MAX(price) FROM Analysis);

-- 40. Об'єднати лікарів і пацієнтів в один список осіб (оператор UNION)
SELECT id, name, 'doctor' AS role FROM Doctor
UNION
SELECT id, name, 'patient' AS role FROM Patient;
