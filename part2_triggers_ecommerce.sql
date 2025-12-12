-- Criando um banco separado para organizar
CREATE DATABASE IF NOT EXISTS ecommerce_cenario;
USE ecommerce_cenario;

-- =================================================================
-- 1. ESTRUTURA PARA O CENÁRIO (Tabelas)
-- =================================================================

-- Tabela de Clientes
CREATE TABLE IF NOT EXISTS customers (
    id_customer INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Tabela de Histórico (Para onde vão os dados deletados)
CREATE TABLE IF NOT EXISTS customers_history (
    id_history INT AUTO_INCREMENT PRIMARY KEY,
    id_customer INT,
    name VARCHAR(100),
    email VARCHAR(100),
    deleted_at DATETIME DEFAULT NOW()
);

-- Tabela de Colaboradores (Para atualização de salário)
CREATE TABLE IF NOT EXISTS employees_ecommerce (
    id_emp INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

-- Tabela de Histórico de Salários
CREATE TABLE IF NOT EXISTS salary_history (
    id_history INT AUTO_INCREMENT PRIMARY KEY,
    id_emp INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date DATETIME DEFAULT NOW()
);


-- 2. TRIGGERS 


DELIMITER //

-- TRIGGER 1: BEFORE DELETE (Remoção)

CREATE TRIGGER trg_save_customer_history
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN
    INSERT INTO customers_history (id_customer, name, email)
    VALUES (OLD.id_customer, OLD.name, OLD.email);
END //


-- TRIGGER 2: BEFORE UPDATE (Atualização de Salário)

CREATE TRIGGER trg_log_salary_update
BEFORE UPDATE ON employees_ecommerce
FOR EACH ROW
BEGIN
    -- Verifica se houve alteração no salário para não gravar log à toa
    IF NEW.salary <> OLD.salary THEN
        INSERT INTO salary_history (id_emp, old_salary, new_salary)
        VALUES (OLD.id_emp, OLD.salary, NEW.salary);
    END IF;
END //

DELIMITER ;


-- 3. TESTES DE FUNCIONAMENTO


-- Teste Trigger DELETE
INSERT INTO customers (name, email) VALUES ('João Teste', 'joao@teste.com');
DELETE FROM customers WHERE email = 'joao@teste.com';

-- SELECT * FROM customers_history;

-- Teste Trigger UPDATE
INSERT INTO employees_ecommerce (name, salary) VALUES ('Maria Dev', 5000.00);
UPDATE employees_ecommerce SET salary = 6000.00 WHERE name = 'Maria Dev';

-- SELECT * FROM salary_history;