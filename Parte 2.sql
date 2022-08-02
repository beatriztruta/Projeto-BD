ALTER TABLE NotaFiscal DROP CONSTRAINT NotaFiscalCompra;
DROP TABLE NotaFiscal;
ALTER TABLE OrdemDeCompra DROP CONSTRAINT OrdemDeCompraCliente;
ALTER TABLE OrdemDeCompra DROP CONSTRAINT OrdemDeCompraTransportadora;
DROP TABLE Transportadora;
ALTER TABLE Telefones_Cliente DROP CONSTRAINT Telefones_ClienteCliente;
DROP TABLE Telefones_Cliente;
ALTER TABLE Cliente DROP CONSTRAINT ClienteSupervisiona;
DROP TABLE Cliente;
ALTER TABLE Produto DROP CONSTRAINT ProdutoCategoria;
DROP TABLE Categoria;
ALTER TABLE ProdutosEmCompra DROP CONSTRAINT ProdutosEmCompraCompra;
ALTER TABLE ProdutosEmCompra DROP CONSTRAINT ProdutosEmCompraProduto;
DROP TABLE ProdutosEmCompra;
ALTER TABLE CompraAvaliaProduto DROP CONSTRAINT AvaliaCompra;
ALTER TABLE CompraAvaliaProduto DROP CONSTRAINT AvaliaProduto;
DROP TABLE CompraAvaliaProduto;
ALTER TABLE FornecerProduto DROP CONSTRAINT FornecerProdutoForneceder;
ALTER TABLE FornecerProduto DROP CONSTRAINT FornecerProdutoProduto ;
DROP TABLE FornecerProduto;
DROP TABLE Fornecedor;
DROP TABLE Produto;
DROP TABLE OrdemDeCompra;
DROP SEQUENCE idCliente;
DROP SEQUENCE idOrdemDeCompra;
DROP SEQUENCE idProduto;
DROP SEQUENCE idCategoria;
DROP SEQUENCE idFornecedor;
DROP SEQUENCE idTransportadora;
DROP SEQUENCE idNotaFiscal;


--Criando as sequencias

CREATE SEQUENCE idCliente;

CREATE SEQUENCE idOrdemDeCompra;

CREATE SEQUENCE idProduto;

CREATE SEQUENCE idCategoria;

CREATE SEQUENCE idFornecedor;

CREATE SEQUENCE idTransportadora;

CREATE SEQUENCE idNotaFiscal;

--Criar as novas tabelas
CREATE TABLE Cliente(
    codcli NUMBER NOT NULL,
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    cpf CHAR(14),
    datanascimento DATE,
    sexo VARCHAR(30),
    email VARCHAR(50),
    pontos INTEGER,
    end_CEP CHAR(9),
    end_Cidade VARCHAR(30),
    end_Bairro VARCHAR(30),
    end_Numero NUMBER,
    end_Rua VARCHAR(50),
    codIndicado NUMBER,
    dataIndicado DATE
);
ALTER TABLE Cliente ADD CONSTRAINT ClienteSupervisiona FOREIGN KEY (codIndicado) REFERENCES Cliente(codcli) INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE Telefones_Cliente(
    codcli NUMBER,
    numero VARCHAR(20),
    PRIMARY KEY(codcli,numero)
);
ALTER TABLE Telefones_Cliente ADD CONSTRAINT Telefones_ClienteCliente FOREIGN KEY (codcli) REFERENCES Cliente(codcli) INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE OrdemDeCompra(
    codcompra NUMBER NOT NULL,
    codcli NUMBER,
    codtransportado NUMBER,
    datacompra date,
    status VARCHAR(100),
    desconto NUMBER,
    frete NUMBER,
    end_CEP CHAR(9),
    end_Cidade VARCHAR(30),
    end_Bairro VARCHAR(30),
    end_Numero NUMBER,
    end_Rua VARCHAR(50)
);
ALTER TABLE OrdemDeCompra ADD CONSTRAINT OrdemDeCompraCliente FOREIGN KEY (codcli) REFERENCES Cliente(codcli) INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE Produto(
    codprod NUMBER NOT NULL,
    nome VARCHAR(100),
    precoCompra FLOAT,
    precoVenda FLOAT,
    dataFabricacao DATE,
    dataValidade DATE,
    descricao VARCHAR(500),
    quantidade NUMBER,
    especificacao VARCHAR(300),
    codCategoria NUMBER,
    CONSTRAINT CHK_precos CHECK (precoCompra>=0 AND precoVenda>=0)
);

CREATE TABLE ProdutosEmCompra(
    codcompra NUMBER,
    codprod NUMBER,
    quantidade NUMBER,
    valorAtual FLOAT,
    CONSTRAINT CHK_quantidade CHECK (quantidade>0),
    PRIMARY KEY(codcompra,codprod)
);
ALTER TABLE ProdutosEmCompra ADD CONSTRAINT ProdutosEmCompraCompra FOREIGN KEY (codcompra) REFERENCES OrdemDeCompra(codcompra) INITIALLY DEFERRED DEFERRABLE;
ALTER TABLE ProdutosEmCompra ADD CONSTRAINT ProdutosEmCompraProduto FOREIGN KEY (codprod) REFERENCES Produto(codprod) INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE CompraAvaliaProduto(
    codcompra NUMBER,
    codprod NUMBER,
    nota NUMBER,
    descricao VARCHAR(300),
    PRIMARY KEY(codcompra,codprod)
);
ALTER TABLE compraAvaliaProduto ADD CONSTRAINT AvaliaCompra FOREIGN KEY (codcompra) REFERENCES OrdemDeCompra(codcompra) INITIALLY DEFERRED DEFERRABLE;
ALTER TABLE compraAvaliaProduto ADD CONSTRAINT AvaliaProduto FOREIGN KEY (codprod) REFERENCES Produto(codprod) INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE Categoria(
    codcat NUMBER NOT NULL,
    nome VARCHAR(100)
);
ALTER TABLE Produto ADD CONSTRAINT ProdutoCategoria FOREIGN KEY (codCategoria) REFERENCES Categoria(codcat) INITIALLY DEFERRED DEFERRABLE;


CREATE TABLE Fornecedor(
    codfor NUMBER NOT NULL,
    cnpj CHAR(18),
    nome VARCHAR(100),
    homePage VARCHAR(100),
    email VARCHAR(50),
    telefone VARCHAR(15),
    end_CEP CHAR(9),
    end_Cidade VARCHAR(30),
    end_Bairro VARCHAR(30),
    end_Numero NUMBER,
    end_Rua VARCHAR(50)
);

CREATE TABLE FornecerProduto(
    codfor NUMBER,
    codprod NUMBER,
    PRIMARY KEY(codfor,codprod)
);
ALTER TABLE FornecerProduto ADD CONSTRAINT FornecerProdutoForneceder FOREIGN KEY (codfor) REFERENCES Fornecedor(codfor) INITIALLY DEFERRED DEFERRABLE;
ALTER TABLE FornecerProduto ADD CONSTRAINT FornecerProdutoProduto FOREIGN KEY (codprod) REFERENCES Produto(codprod) INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE Transportadora(
    codtran NUMBER NOT NULL,
    nome VARCHAR(100),
    email VARCHAR(50),
    telefone VARCHAR(15),
    siteTran VARCHAR(100),
    end_CEP CHAR(9),
    end_Cidade VARCHAR(30),
    end_Bairro VARCHAR(30),
    end_Numero NUMBER,
    end_Rua VARCHAR(50)
);
ALTER TABLE OrdemDeCompra ADD CONSTRAINT OrdemDeCompraTransportadora FOREIGN KEY (codtransportado) REFERENCES Transportadora(codtran) INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE NotaFiscal(
    codNota NUMBER NOT NULL,
    inscricaoEstadual CHAR(15),
    chaveDeAcesso CHAR(55),
    dataNF DATE,
    numero CHAR(11),
    serie CHAR(3),
    valorTotal FLOAT,
    codcompra NUMBER
);
ALTER TABLE NotaFiscal ADD CONSTRAINT NotaFiscalCompra FOREIGN KEY (codcompra) REFERENCES OrdemDeCompra(codcompra) INITIALLY DEFERRED DEFERRABLE;