# Desafio de Database: Views, Permissões e Triggers

Este repositório contém a resolução da segunda parte do desafio de banco de dados, focado em segurança (Views e Users) e automação (Triggers).

## Parte 1: Personalizando Acessos com Views
Utilizando o schema do banco de dados `company`, foram criadas Views para facilitar relatórios gerenciais e definidos níveis de acesso.

### Views Criadas:
1. **`vw_funcionarios_por_departamento_local`**: Contagem de colaboradores agrupados por dpto e local.
2. **`vw_lista_dept_gerentes`**: Relatório simples de quem gerencia qual departamento.
3. **`vw_projetos_maior_num_empregados`**: Ranking de projetos por tamanho da equipe.
4. **`vw_projeto_dept_gerente`**: Visão completa unindo Projeto -> Dpto -> Gerente.
5. **`vw_empregados_com_dependentes_e_status`**: Identifica se funcionários com dependentes também possuem cargos de gerência.

### Permissões de Usuários:
* **Gerente (`gerente_user`):** Tem acesso às views que mostram dados sensíveis de departamentos e gerência.
* **Empregado (`employee_user`):** Acesso restrito apenas a estatísticas de projetos e status de dependentes, sem visibilidade da estrutura gerencial completa.

---

## Parte 2: Triggers para E-commerce
Foi simulado um cenário de e-commerce para implementar gatilhos de segurança e auditoria.

### Triggers Implementadas:

#### 1. Remoção (`BEFORE DELETE`)
* **Cenário:** Um usuário decide excluir sua conta.
* **Ação:** Antes da exclusão física do registro na tabela `customers`, uma trigger copia os dados para uma tabela de backup `customers_history`. Isso garante a retenção de dados para fins legais ou de auditoria.

#### 2. Atualização (`BEFORE UPDATE`)
* **Cenário:** Atualização de salário de colaboradores.
* **Ação:** Antes de modificar o salário na tabela `employees_ecommerce`, a trigger salva o valor antigo e o novo valor na tabela `salary_history`. Isso permite rastrear a evolução salarial e auditar mudanças.
