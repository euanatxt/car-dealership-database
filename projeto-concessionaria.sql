-- ==========================================================
-- PROJETO BANCO DE DADOS - CONCESSIONÁRIA DE VEÍCULOS
-- ==========================================================
-- Banco: MySQL
-- Descrição: Estrutura do banco, dados de teste e consultas
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
-- 2. INSERÇÃO DE DADOS DE TESTE 
-- ==========================================================

INSERT INTO marcas (nome_marca) VALUES 
('Toyota'), 
('Honda'), 
('Volkswagen'), 
('BMW');

INSERT INTO inventario (modelo, transmissao, motor, combustivel, preco, ano_fabricacao, status, marcas_id) VALUES 
('Corolla', 'Automatica', '2.0', 'Flex', 120000.00, 2021, 'Vendido', 1),
('Civic', 'Automatica', '1.5 Turbo', 'Gasolina', 110000.00, 2020, 'Vendido', 2),
('Golf', 'Manual', '1.4 TSI', 'Flex', 85000.00, 2019, 'Disponivel', 3),
('320i', 'Automatica', '2.0', 'Gasolina', 210000.00, 2022, 'Vendido', 4);

INSERT INTO clientes (nome, sobrenome, endereco, numero) VALUES 
('Ana', 'Silva', 'Rua das Flores', '123'),
('Carlos', 'Oliveira', 'Av. Central', '456');

INSERT INTO pagamentos (valor, forma_pagamento, status, clientes_id, inventario_id) VALUES 
(120000.00, 'Pix', 'Aprovado', 1, 1),
(110000.00, 'Financiamento', 'Aprovado', 2, 2),
(85000.00, 'Cartao', 'Cancelado', 1, 3);


-- ==========================================================
-- 3. CONSULTAS E OPERAÇÕES
-- ==========================================================

-- 1. Faturamento total e quantidade de vendas por marca
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


-- 2. Clientes com pagamentos acima de R$ 100.000,00
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


-- 3. Aplicar desconto de 5% em carros até 2020 disponíveis
UPDATE inventario
SET preco = preco * 0.95
WHERE ano_fabricacao <= 2020
  AND status = 'Disponivel';


-- 4. Limpeza de pagamentos cancelados
DELETE FROM pagamentos
WHERE status = 'Cancelado';


-- ==========================================================
-- FIM DO PROJETO
-- ==========================================================
