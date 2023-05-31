-- Apagando banco de dados caso exista
DROP DATABASE IF EXISTS uvv;

-- Apagando o esquema lojas caso exista
DROP SCHEMA IF EXISTS lojas;

-- Apagando usuario caso exista
DROP USER IF EXISTS daniele;

-- Criando usuario e uma senha para ele
CREATE USER 'daniele' IDENTIFIED BY 'computacao@raiz';
GRANT CREATEDB, LOGIN ON *.* TO 'daniele';

-- Criando banco de dados
CREATE DATABASE uvv;
USE uvv;

-- Criando SCHEMA
CREATE SCHEMA lojas;

-- Ajustando SEARCH PATH
ALTER USER 'daniele' DEFAULT ROLE lojas;

-- Criando as tabelas
CREATE TABLE produtos (
                produto_id       DECIMAL(38)   NOT NULL,
                nome             VARCHAR(255)  NOT NULL,
                preco_unitario   DECIMAL(10,2) NOT NULL,
                detalhes         LONGBLOB,
                imagem           LONGBLOB,
                imagem_mime_type VARCHAR(512)  NOT NULL,
                PRIMARY KEY (produto_id)
);

CREATE TABLE pedidos (
                pedido_id   DECIMAL(38) NOT NULL,
                data_hora   DATETIME    NOT NULL,
                cliente_id  DECIMAL(38) NOT NULL,
                status      VARCHAR(15) NOT NULL,
                loja_id     DECIMAL(38) NOT NULL,
                PRIMARY KEY (pedido_id)
);

CREATE TABLE pedidos_itens (
                pedido_id       DECIMAL(38)   NOT NULL,
                produto_id      DECIMAL(38)   NOT NULL,
                numero_da_linha DECIMAL(38)   NOT NULL,
                preco_unitario  DECIMAL(10,2) NOT NULL,
                quantidade      DECIMAL(38)   NOT NULL,
                envio_id        DECIMAL(38)   NOT NULL,
                PRIMARY KEY (pedido_id, produto_id)
);

CREATE TABLE clientes (
                cliente_id DECIMAL(38)  NOT NULL,
                email      VARCHAR(255) NOT NULL,
                nome       VARCHAR(255) NOT NULL,
                telefone1  VARCHAR(20),
                telefone2  VARCHAR(20),
                telefone3  VARCHAR(20),
                pedido_id  DECIMAL(38)  NOT NULL,
                PRIMARY KEY (cliente_id)
);

CREATE TABLE envios (
                envio_id         DECIMAL(38)  NOT NULL,
                loja_id          DECIMAL(38)  NOT NULL,
                cliente_id       DECIMAL(38)  NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status           VARCHAR(15)  NOT NULL,
                PRIMARY KEY (envio_id)
);

CREATE TABLE lojas (
                loja_id                 DECIMAL(38)  NOT NULL,
                nome                    VARCHAR(255) NOT NULL,
                endereco_web            VARCHAR(100),
                endereco_fisico         VARCHAR(512),
                latitude                DECIMAL,
                longitude               DECIMAL,
                logo                    LONGBLOB,
                logo_mime_type          VARCHAR(512),
                logo_arquivo            VARCHAR(512),
                logo_charset            VARCHAR(512),
                logo_ultima_atualizacao DATE,
                envio_id                DECIMAL(38)  NOT NULL,
                pedido_id               DECIMAL(38)  NOT NULL,
                PRIMARY KEY (loja_id)
);

CREATE TABLE estoques (
                estoque_id          DECIMAL(38) NOT NULL,
                loja_id             DECIMAL(38) NOT NULL,
                produto_id          DECIMAL     NOT NULL,
                quantidade          DECIMAL


-- Adicionando CONSTRAINTS

ALTER TABLE lojas ADD CONSTRAINT enderecos
CHECK ((endereco_web IS NOT NULL AND endereco_fisico IS NULL) OR (endereco_web IS NULL AND endereco_fisico IS NOT NULL));

ALTER TABLE pedidos ADD CONSTRAINT status
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

ALTER TABLE envios ADD CONSTRAINT status_envio
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

ALTER TABLE produtos ADD CONSTRAINT preco_unitario
CHECK (preco_unitario > 0);

ALTER TABLE pedidos_itens ADD CONSTRAINT preco_unitario_item
CHECK (preco_unitario > 0);



ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE clientes ADD CONSTRAINT pedidos_clientes_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_itens_produto_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_itens_pedido_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE lojas ADD CONSTRAINT pedidos_lojas_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE lojas ADD CONSTRAINT envios_lojas_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;