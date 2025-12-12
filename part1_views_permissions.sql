USE company;


-- 1. CRIANDO AS VIEWS 


-- 1. Número de empregados por departamento e localidade
CREATE OR REPLACE VIEW vw_funcionarios_por_departamento_local AS
SELECT 
    d.Dname AS Departamento,
    l.Dlocation AS Localidade,
    COUNT(e.Ssn) AS Qtd_Funcionarios
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
JOIN employee e ON d.Dnumber = e.Dno
GROUP BY d.Dname, l.Dlocation;

-- 2. Lista de departamentos e seus gerentes
CREATE OR REPLACE VIEW vw_lista_dept_gerentes AS
SELECT 
    d.Dname AS Departamento,
    CONCAT(e.Fname, ' ', e.Lname) AS Nome_Gerente
FROM departament d
JOIN employee e ON d.Mgr_ssn = e.Ssn;

-- 3. Projetos com maior número de empregados (Ordenado DESC)
CREATE OR REPLACE VIEW vw_projetos_maior_num_empregados AS
SELECT 
    p.Pname AS Nome_Projeto,
    COUNT(w.Essn) AS Qtd_Empregados
FROM project p
JOIN works_on w ON p.Pnumber = w.Pno
GROUP BY p.Pname
ORDER BY Qtd_Empregados DESC;

-- 4. Lista de projetos, departamentos e gerentes
CREATE OR REPLACE VIEW vw_projeto_dept_gerente AS
SELECT 
    p.Pname AS Projeto,
    d.Dname AS Departamento,
    CONCAT(e.Fname, ' ', e.Lname) AS Gerente_Responsavel
FROM project p
JOIN departament d ON p.Dnum = d.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn;

-- 5. Quais empregados possuem dependentes e se são gerentes

CREATE OR REPLACE VIEW vw_empregados_com_dependentes_e_status AS
SELECT 
    e.Fname AS Nome,
    dp.Dependent_name AS Dependente,
    CASE 
        WHEN d.Mgr_ssn IS NOT NULL THEN 'Sim'
        ELSE 'Não'
    END AS Eh_Gerente
FROM employee e
JOIN dependent dp ON e.Ssn = dp.Essn
LEFT JOIN departament d ON e.Ssn = d.Mgr_ssn;



-- 2. CRIANDO USUÁRIOS E PERMISSÕES


-- Criando Usuário Gerente (Pode ver tudo das Views criadas)
CREATE USER 'gerente_user'@'localhost' IDENTIFIED BY 'senha_gerente_123';

-- Criando Usuário Empregado (Acesso restrito)
CREATE USER 'employee_user'@'localhost' IDENTIFIED BY 'senha_employee_123';

-- PERMISSÕES DO GERENTE:
-- Acesso total as views de gerenciamento
GRANT SELECT ON company.vw_lista_dept_gerentes TO 'gerente_user'@'localhost';
GRANT SELECT ON company.vw_projeto_dept_gerente TO 'gerente_user'@'localhost';
GRANT SELECT ON company.vw_funcionarios_por_departamento_local TO 'gerente_user'@'localhost';

-- PERMISSÕES DO EMPREGADO:
-- O empregado não deve ver informações de gerência, apenas estatísticas gerais de projetos
-- ou verificar seus dependentes (neste caso, liberamos a view de projetos e dependentes)
GRANT SELECT ON company.vw_projetos_maior_num_empregados TO 'employee_user'@'localhost';
GRANT SELECT ON company.vw_empregados_com_dependentes_e_status TO 'employee_user'@'localhost';

-- Aplicar permissões
FLUSH PRIVILEGES;