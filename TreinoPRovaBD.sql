CREATE DATABASE ex9
GO
USE ex9
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marília Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matemática da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciências da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Física I',26,68.00,4,104),
(10005,'Geometria Analítica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Física III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')

-- Exercicio 01

Select Distinct es.nome, es.valor, ed.nome, au.nome
From estoque es, editora ed, autor au
Where es.codEditora = ed.codigo
	and es.codAutor = au.codigo

-- Exercicio 02

Select es.nome, SUM(co.qtdComprada) as QuantidadeComprada, co.qtdComprada * es.valor as TotalDaCompra
From estoque es, compra co
Where co.codigo = 15051
Group By es.nome

-- Exercicio 03 

/* Select es.nome, ed.site
					case when Len(editora.site) > 10 then
						Left(ed.site, 3)
					end as SiteEditora 
						
From estoque es, editora ed
Where ed.nome = 'Makron books' */

-- Exercicio 04

Select es.nome, au.biografia, au.nome, au.codigo
From estoque es, autor au
Where au.codigo = 104

-- Exercicio 05

Select co.codigo, co.qtdComprada, es.nome
From compra co, estoque es
Where es.nome = 'Sistemas Operacionais Modernos'

-- Exercicio 06

/* Select es.nome, es.codigo
From compra co, estoque es
Where es.codigo */

-- Exericio 07

Select es.nome, es.codigo
From estoque es, compra co
where Not Exists (
	Select 1
	From compra co
	Where co.codEstoque = es.codigo
)

-- Exercicio 08 
/*
Select 
	case Len(ed.site) > 10 then
			Substring(ed.site, 4, Len(ed.site) - 3)
	else 
			ed.site
	end as SiteEditora, ed.nome					
From editora ed
Where Not Exists (
	Select 1
	From estoque es
	Where es.codEditora = ed.codigo
)
*/
-- Exercicio 09

/* Select au.nome, 
		case au.biografia LIKE '$Doutorado' then
			'Ph. D. ' + SUBSTRING(au.biografia, 9, LEN(au.biografia) - 9)
		end as Biografia
From autor au */


-- Exercicio 10

/* Select au.nome, es.valor
From autor au, estoque es
Group By es.valor
Order By es.valor DES */


-- Exercicio 11 

Select co.codigo, SUM(co.valor) as SomaDosValores
From compra co
Group by co.codigo
Order By co.codigo ASC

-- Exercicio 12

Select AVG(es.valor) as MediaDosValores
From estoque es, editora ed
Group By es.valor
Order By MediaDosValores

-- Exercicio 13 

Select es.nome,
		es.quantidade, 
		Case 
			When es.quantidade < 5 then 'Produto em Ponto de Pedido'
			When es.quantidade BETWEEN 5 and 10 then 'Produto Acabando'
			When es.quantidade > 10 then 'Estoque Suficiente'
		End as Status
From estoque es, editora ed
Order By es.quantidade ASC

-- Exercicio 14

Select es.codigo, es.nome, au.nome, ed.nome + ' ' + ed.site
From estoque es, autor au, editora ed
Where ed.site IS NOT NULL

-- Exercicio 15
/*
Select
From compra co, */

-- Exercicio 16

Select co.codigo, SUM(co.valor) as SomaDosValores
From compra co
Group By co.codigo
Having SUM(co.valor) > 200