-- Заповнення таблиць тестовими даними
INSERT INTO Patient (name, birth_date, phone, email) VALUES
('Іван Петров', '1985-06-15', '+380971234567', 'ivan.petrov@example.com'),
('Марія Іваненко', '1992-03-22', '+380503456789', 'maria.ivanenko@example.com');

INSERT INTO Doctor (name, specialty, phone, email) VALUES
('Олександр Сидоренко', 'Терапевт', '+380671112233', 'sidorenko@example.com'),
('Галина Ковальчук', 'Кардіолог', '+380931234567', 'kovalchuk@example.com');

INSERT INTO LabTechnician (name, phone, email) VALUES
('Андрій Савченко', '+380501234567', 'savchenko@example.com'),
('Ольга Мельник', '+380631112233', 'melnik@example.com');

INSERT INTO Analysis (name, description, price) VALUES
('Загальний аналіз крові', 'Стандартний аналіз крові', 250.00),
('Біохімічний аналіз крові', 'Аналіз для визначення рівня білків, жирів та цукру в крові', 450.00),
('Аналіз на гормони', 600.00);

INSERT INTO LabOrder (patient_id, analysis_id, lab_technician_id, doctor_id, status) VALUES
(1, 1, 1, 1, 'Completed'),
(2, 2, 2, 2, 'Pending');

INSERT INTO Result (order_id, result_text, accuracy_percentage, received_online) VALUES
(1, 'Нормальні показники', 98.5, TRUE);
