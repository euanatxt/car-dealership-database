-- ==========================================================
-- PROJETO BANCO DE DADOS - CONCESSIONÁRIA DE VEÍCULOS
-- ==========================================================
-- Banco: MySQL
-- Descrição: Estrutura do banco + consultas e operações DML
-- ==========================================================

CREATE DATABASE IF NOT EXISTS carros;
USE carros;

-- ==========================================================
-- 1. CRIAÇÃO DAS TABELAS
-- ==========================================================

CREATE TABLE marcas (
    id INT NOT NULL AUTO_INCREMENT,
    nome_marca VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE inventario (
    id INT NOT NULL AUTO_INCREMENT,
    modelo VARCHAR(255) NOT NULL,
    transmissao VARCHAR(255) NOT NULL,
    motor VARCHAR(255) NOT NULL,
    combustivel VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    ano_fabricacao YEAR NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Disponivel',
    marcas_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (marcas_id) REFERENCES marcas(id)
);

CREATE TABLE clientes (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    sobrenome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    numero VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE pagamentos (
    id INT NOT NULL AUTO_INCREMENT,
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Aprovado',
    clientes_id INT NOT NULL,
    inventario_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (clientes_id) REFERENCES clientes(id),
    FOREIGN KEY (inventario_id) REFERENCES inventario(id)
);

CREATE TABLE notas_fiscais (
    id INT NOT NULL AUTO_INCREMENT,
    numero_nf VARCHAR(50) NOT NULL,
    serie VARCHAR(10) NOT NULL,
    data_emissao DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    impostos DECIMAL(10,2) NOT NULL,
    clientes_id INT NOT NULL,
    inventario_id INT NOT NULL,
    pagamentos_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (clientes_id) REFERENCES clientes(id),
    FOREIGN KEY (inventario_id) REFERENCES inventario(id),
    FOREIGN KEY (pagamentos_id) REFERENCES pagamentos(id)
);

CREATE TABLE vendedores (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    comissao_percentual DECIMAL(4,2),
    PRIMARY KEY (id)
);

CREATE TABLE manutencoes (
    id INT NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    custo DECIMAL(10,2) NOT NULL,
    data_servico DATE NOT NULL,
    inventario_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (inventario_id) REFERENCES inventario(id)
);

-- ==========================================================
-- 2. CONSULTAS E OPERAÇÕES DML
-- ==========================================================

-- 1. Faturamento total e quantidade de vendas por marca
-- Objetivo: identificar quais marcas possuem maior receita.

SELECT
    m.nome_marca AS marca,
    COUNT(p.id) AS total_vendas,
    SUM(p.valor) AS receita_total
FROM pagamentos p
JOIN inventario i ON p.inventario_id = i.id
JOIN marcas m ON i.marcas_id = m.id
WHERE p.status = 'Aprovado'
GROUP BY m.nome_marca
ORDER BY receita_total DESC;


-- 2. Clientes que possuem pagamentos acima de R$ 100.000,00
-- Objetivo: listar clientes e veículos associados a pagamentos
-- de alto valor.

SELECT
    CONCAT(c.nome, ' ', c.sobrenome) AS cliente,
    i.modelo AS veiculo_comprado,
    p.valor AS valor_pago,
    p.forma_pagamento
FROM clientes c
JOIN pagamentos p ON c.id = p.clientes_id
JOIN inventario i ON p.inventario_id = i.id
WHERE p.valor >= 100000.00
  AND p.status = 'Aprovado'
ORDER BY p.valor DESC;


-- 3. Atualização de preços em lote
-- Cenário: aplicar desconto de 5% em carros fabricados
-- até 2020 que ainda estão disponíveis.

UPDATE inventario
SET preco = preco * 0.95
WHERE ano_fabricacao <= 2020
  AND status = 'Disponivel';


-- 4. Limpeza de pagamentos cancelados
-- Cenário: remover registros de pagamentos cancelados.
-- A coluna status foi adicionada à tabela pagamentos
-- para permitir essa operação.

DELETE FROM pagamentos
WHERE status = 'Cancelado';


-- ==========================================================
-- FIM DO PROJETO
-- ==========================================================
