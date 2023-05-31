-- Apagando banco de dados caso exista

DROP DATABASE IF EXISTS uvv;


-- Apagando o esquema lojas caso exista

DROP SCHEMA IF EXISTS lojas;


-- Apagando usuário caso exista
DROP ROLE IF EXISTS daniele;
DROP USER IF EXISTS daniele;



-- Criando usuário e uma senha para ele

CREATE USER daniele WITH 
CREATEDB
LOGIN PASSWORD 'computacao@raiz';


-- Criando banco de dados

CREATE DATABASE uvv
OWNER daniele
TEMPLATE template0
ENCODING 'UTF8'
LC_COLLATE 'pt_BR.UTF-8'
LC_CTYPE 'pt_BR.UTF-8'
ALLOW_CONNECTIONS true;

--Trocando conexão e inserindo a senha;

\c 'dbname=uvv user=daniele password=computacao@raiz';



-- Criando SCHEMA

CREATE SCHEMA lojas AUTHORIZATION daniele;





ALTER USER daniele SET SEARCH_PATH TO lojas, "$user", public;

SET SEARCH_PATH TO lojas, "$user", public;










--Criando as tabelas
CREATE TABLE produtos (
                produto_id       NUMERIC(38)   NOT NULL,
                nome             VARCHAR(255)  NOT NULL,
                preco_unitario   NUMERIC(10,2) NOT NULL,
                detalhes         BYTEA,
                imagem           BYTEA,
                imagem_mime_type VARCHAR(512)  NOT NULL,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);
COMMENT ON TABLE  produtos                  IS 'Dados dos produtos';
COMMENT ON COLUMN produtos.produto_id       IS 'Insira o ID do produto';
COMMENT ON COLUMN produtos.nome             IS 'Insira o nome dos produtos';
COMMENT ON COLUMN produtos.preco_unitario   IS 'Insira o preço da unidade dos produtos';
COMMENT ON COLUMN produtos.detalhes         IS 'Insira detalhes dos produtos';
COMMENT ON COLUMN produtos.imagem           IS 'Insira a imagem dos produtos';
COMMENT ON COLUMN produtos.imagem_mime_type IS 'Insira o MIME type da imagem dos produtos';


CREATE TABLE pedidos (
                pedido_id   NUMERIC(38) NOT NULL,
                data_hora   TIMESTAMP   NOT NULL,
                cliente_id  NUMERIC(38) NOT NULL,
                status      VARCHAR(15) NOT NULL,
                loja_id     NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
);
COMMENT ON TABLE  pedidos            IS 'Dados dos pedidos';
COMMENT ON COLUMN pedidos.pedido_id  IS 'Insira o ID do pedido';
COMMENT ON COLUMN pedidos.data_hora  IS 'Insira a data e a hora em que o pedido foi efetuado';
COMMENT ON COLUMN pedidos.cliente_id IS 'Insira o ID do cliente que efetuou o pedido';
COMMENT ON COLUMN pedidos.status     IS 'Insira o status do pedido';
COMMENT ON COLUMN pedidos.loja_id    IS 'Insira o ID da loja que possui o pedido';


CREATE TABLE pedidos_itens (
                pedido_id       NUMERIC(38)   NOT NULL,
                produto_id      NUMERIC(38)   NOT NULL,
                numero_da_linha NUMERIC(38)   NOT NULL,
                preco_unitario  NUMERIC(10,2) NOT NULL,
                quantidade      NUMERIC(38)   NOT NULL,
                envio_id        NUMERIC(38)   NOT NULL,
                CONSTRAINT pedido_item_id PRIMARY KEY (pedido_id, produto_id)
);
COMMENT ON COLUMN pedidos_itens.pedido_id       IS 'Insira o ID do pedido';
COMMENT ON COLUMN pedidos_itens.produto_id      IS 'Insira o ID do produto';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'Insira o número da linha';
COMMENT ON COLUMN pedidos_itens.preco_unitario  IS 'Insira o preço da unidade de um item de um pedido';
COMMENT ON COLUMN pedidos_itens.quantidade      IS 'Insira a quantidade de itens em um pedido';
COMMENT ON COLUMN pedidos_itens.envio_id        IS 'Insira o ID do envio';


CREATE TABLE clientes (
                cliente_id NUMERIC(38)  NOT NULL,
                email      VARCHAR(255) NOT NULL,
                nome       VARCHAR(255) NOT NULL,
                telefone1  VARCHAR(20),
                telefone2  VARCHAR(20),
                telefone3  VARCHAR(20),
                pedido_id  NUMERIC(38)  NOT NULL,
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE  clientes            IS 'Dados dos clientes';
COMMENT ON COLUMN clientes.cliente_id IS 'Insira o ID do cliente';
COMMENT ON COLUMN clientes.email      IS 'Insira o email do cliente';
COMMENT ON COLUMN clientes.nome       IS 'Insira o nome do cliente';
COMMENT ON COLUMN clientes.telefone1  IS 'Insira o telefone 1 do cliente';
COMMENT ON COLUMN clientes.telefone2  IS 'Insira o telefone 2 do cliente';
COMMENT ON COLUMN clientes.telefone3  IS 'Insira o telefone 3 do cliente';
COMMENT ON COLUMN clientes.pedido_id  IS 'Insira o ID do pedido';


CREATE TABLE envios (
                envio_id         NUMERIC(38)  NOT NULL,
                loja_id          NUMERIC(38)  NOT NULL,
                cliente_id       NUMERIC(38)  NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status           VARCHAR(15)  NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);
COMMENT ON TABLE  envios                  IS 'Dados dos envios';
COMMENT ON COLUMN envios.envio_id         IS 'Insira o ID do envio';
COMMENT ON COLUMN envios.loja_id          IS 'Inaira o ID da loja que enviou um pedido';
COMMENT ON COLUMN envios.cliente_id       IS 'insira o ID do cliente';
COMMENT ON COLUMN envios.endereco_entrega IS 'Insira o endereço de entrega';
COMMENT ON COLUMN envios.status           IS 'Insira o status do envio';


CREATE TABLE lojas (
                loja_id                 NUMERIC(38)  NOT NULL,
                nome                    VARCHAR(255) NOT NULL,
                endereco_web            VARCHAR(100),
                endereco_fisico         VARCHAR(512),
                latitude                NUMERIC,
                longitude               NUMERIC,
                logo                    BYTEA,
                logo_mime_type          VARCHAR(512),
                logo_arquivo            VARCHAR(512),
                logo_charset            VARCHAR(512),
                logo_ultima_atualizacao DATE,
                envio_id                NUMERIC(38)  NOT NULL,
                pedido_id               NUMERIC(38)  NOT NULL,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);
COMMENT ON TABLE  lojas                         IS 'Dados das lojas';
COMMENT ON COLUMN lojas.loja_id                 IS 'Insira do ID da loja';
COMMENT ON COLUMN lojas.nome                    IS 'Insira o nome da loja';
COMMENT ON COLUMN lojas.endereco_web            IS 'Insira o endereço web da loja';
COMMENT ON COLUMN lojas.endereco_fisico         IS 'Insira o endereço físico da loja';
COMMENT ON COLUMN lojas.latitude                IS 'Insira a latitude da loja';
COMMENT ON COLUMN lojas.longitude               IS 'Insira a longitude da loja';
COMMENT ON COLUMN lojas.logo                    IS 'Insira a logo da loja';
COMMENT ON COLUMN lojas.logo_mime_type          IS 'Insira o MIME type da logo da loja';
COMMENT ON COLUMN lojas.logo_arquivo            IS 'Insira o arquivo da logo da loja';
COMMENT ON COLUMN lojas.logo_charset            IS 'Insira o charset da logo da loja';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'Insira a ultima atualização da logo da loja';
COMMENT ON COLUMN lojas.envio_id                IS 'Insira o ID do envio';
COMMENT ON COLUMN lojas.pedido_id               IS 'Insira o ID do pedido';


CREATE TABLE estoques (
                estoque_id          NUMERIC(38) NOT NULL,
                loja_id             NUMERIC(38) NOT NULL,
                produto_id          NUMERIC     NOT NULL,
                quantidade          NUMERIC(38) NOT NULL,
                produtos_produto_id NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE  estoques                     IS 'Dados dos estoques';
COMMENT ON COLUMN estoques.estoque_id          IS 'Insira o ID do estoque';
COMMENT ON COLUMN estoques.loja_id             IS 'Insira o ID da loja';
COMMENT ON COLUMN estoques.produto_id          IS 'Insira o ID do produto';
COMMENT ON COLUMN estoques.quantidade          IS 'Insira a quantidade existente do produto no estoque';
COMMENT ON COLUMN estoques.produtos_produto_id IS 'Insira o ID do produto';


--Adicionando CONSTRAINTS
ALTER TABLE lojas
ADD CONSTRAINT enderecos
CHECK ((endereco_web IS NOT NULL AND endereco_fisico IS NULL) OR (endereco_web IS NULL AND endereco_fisico IS NOT NULL));

ALTER TABLE pedidos
ADD CONSTRAINT status
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

ALTER TABLE envios
ADD CONSTRAINT status_envio
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE.'));

ALTER TABLE produtos
ADD CONSTRAINT preco_unitario
CHECK (preco_unitario>0);

ALTER TABLE pedidos_itens
ADD CONSTRAINT preco_unitario
CHECK (preco_unitario>0);



ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produtos_produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE clientes ADD CONSTRAINT pedidos_clientes_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas ADD CONSTRAINT pedidos_lojas_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas ADD CONSTRAINT envios_lojas_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
