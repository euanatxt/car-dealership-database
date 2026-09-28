# Banco de Dados - Concessionária de Veículos

Este é o meu primeiro projeto em SQL! Desenvolvi a estrutura de um banco de dados relacional para gerenciar uma concessionária de carros, cobrindo desde a modelagem até a criação de consultas para relatórios.

##  Tecnologias Utilizadas
* **MySQL**
* **MySQL Workbench**

## Estrutura do Banco
O sistema foi modelado para conectar e organizar os seguintes setores da loja:
* **Marcas e Inventário:** Registo das marcas, modelos de carros, preços, ano de fabricação e estado de disponibilidade.
* **Clientes e Vendedores:** Armazenamento dos dados dos compradores e da comissão dos vendedores.
* **Vendas e Pagamentos:** Controlo das formas de pagamento, valores pagos e status da transação.
* **Notas Fiscais e Manutenções:** Registo fiscal das vendas e histórico de manutenção efetuado nos veículos.

##  O que o script faz
O ficheiro `.sql` está dividido em duas partes principais:
1. **Criação das Tabelas (DDL):** Definição das chaves primárias (`PRIMARY KEY`), estrangeiras (`FOREIGN KEY`) e tipos de dados para manter a integridade entre as tabelas.
2. **Consultas e Operações (DML):** 
   * Agrupamento e soma de faturamento total por marca (`JOIN`, `GROUP BY`).
   * Filtro de clientes e carros envolvidos em vendas de alto valor.
   * Atualização de preços de veículos em lote (`UPDATE`).
   * Remoção de registos cancelados para limpeza de histórico (`DELETE`).

##  Como executar
1. Abra o **MySQL Workbench** (ou outro cliente SQL da sua preferência).
2. Abra e execute o ficheiro `projeto-concessionaria.sql`.
3. O banco de dados `carros` será criado automaticamente com toda a estrutura e consultas prontas para teste.
