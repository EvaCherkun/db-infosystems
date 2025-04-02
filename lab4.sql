--  Створення користувацького типу ENUM для статусу замовлення
CREATE TYPE order_status AS ENUM ('pending', 'in_progress', 'completed', 'canceled');

--  Додавання нового стовпця для статусу в таблицю LabOrder
ALTER TABLE LabOrder ADD COLUMN status_new order_status DEFAULT 'pending';

--  Оновлення значень у новому стовпці на основі старого стовпця
-- Перетворюємо старі значення в новий формат ENUM
UPDATE LabOrder
SET status_new = status::order_status
WHERE status IN ('pending', 'in_progress', 'completed', 'canceled');

--  Видалення старого стовпця `status`, щоб уникнути дублювання
ALTER TABLE LabOrder DROP COLUMN status;

-- Перейменування стовпця `status_new` на `status`
ALTER TABLE LabOrder RENAME COLUMN status_new TO status;

-- Створення таблиці для логування змін в таблиці LabOrder
CREATE TABLE order_log (
    log_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    operation CHAR(1), -- Тип операції (I = Insert, U = Update, D = Delete)
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Створення тригерної функції для логування змін в таблиці LabOrder
CREATE OR REPLACE FUNCTION log_order_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO order_log (order_id, operation)
    VALUES (NEW.id, TG_OP);  -- Вставляємо id запису та тип операції (Insert, Update, Delete)
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--  Створення тригера для автоматичного логування змін
CREATE TRIGGER track_order_changes
AFTER INSERT OR UPDATE OR DELETE ON LabOrder
FOR EACH ROW
EXECUTE FUNCTION log_order_changes();

--  Створення функції для обчислення середньої ціни аналізів
CREATE OR REPLACE FUNCTION calculate_average_price() RETURNS NUMERIC AS $$
BEGIN
    RETURN (SELECT AVG(price) FROM Analysis);
END;
$$ LANGUAGE plpgsql;

-- Функція, яка підраховує кількість завершених замовлень за останній місяць.

CREATE OR REPLACE FUNCTION count_completed_orders() RETURNS INT AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM LabOrder WHERE status = 'completed' AND order_date >= NOW() - INTERVAL '1 month');
END;
$$ LANGUAGE plpgsql;


-- Тестовий запит для перевірки роботи функції обчислення середньої ціни
SELECT calculate_average_price();

-- Використання функції для підрахунку завершених замовлень
SELECT count_completed_orders();


-- Створення таблиці для логування змін статусу замовлень
CREATE TABLE LabOrder_Log (
    log_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES LabOrder(id),
    old_status order_status,
    new_status order_status,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Створення функції для логування змін у таблиці LabOrder
CREATE OR REPLACE FUNCTION log_laborder_changes() RETURNS TRIGGER AS $$
BEGIN
    -- Записуємо старий і новий статус в таблицю LabOrder_Log
    INSERT INTO LabOrder_Log (order_id, old_status, new_status)
    VALUES (OLD.id, OLD.status, NEW.status);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Створення тригера для відслідковування змін в таблиці LabOrder
CREATE TRIGGER track_laborder_changes
AFTER UPDATE ON LabOrder
FOR EACH ROW
EXECUTE FUNCTION log_laborder_changes();

-- Оновлення статусу замовлення для тестування тригера
UPDATE LabOrder SET status = 'completed' WHERE id = 1;

-- Перевірка чи було зафіксовано зміну в таблиці LabOrder_Log
SELECT * FROM LabOrder_Log;
