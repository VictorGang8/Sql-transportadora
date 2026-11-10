-- Banco da transportadora
CREATE DATABASE transportadora_left;
USE transportadora_left;
 
-- Motoristas (cnh = categoria da habilitação)
CREATE TABLE motorista (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(60) NOT NULL,
  cnh VARCHAR(2) NOT NULL,
  cidade_base VARCHAR(40) NOT NULL
);
 
-- Entregas: motorista_id aponta para motorista(id)
CREATE TABLE entrega (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(10) NOT NULL UNIQUE,
  destino VARCHAR(40) NOT NULL,
  peso_kg DECIMAL(7,2) NOT NULL,
  status VARCHAR(15) NOT NULL,
  motorista_id INT NOT NULL,
  FOREIGN KEY (motorista_id) REFERENCES motorista(id)
);
 
INSERT INTO motorista (nome, cnh, cidade_base) VALUES
  ('Roberto Nunes', 'C', 'Campinas'),
  ('Luana Ferraz', 'E', 'São Paulo'),
  ('André Batista', 'D', 'Sorocaba'),
  ('Sérgio Mota', 'C', 'São Paulo'),
  ('Kátia Ramos', 'E', 'Campinas');
 
INSERT INTO entrega (codigo, destino, peso_kg, status, motorista_id) VALUES
  ('ENT-001', 'Santos', 1200.00, 'Entregue', 2),
  ('ENT-002', 'Jundiaí', 350.50, 'Entregue', 1),
  ('ENT-003', 'Ribeirão Preto', 8000.00, 'Em rota', 2),
  ('ENT-004', 'Piracicaba', 420.00, 'Entregue', 1),
  ('ENT-005', 'Bauru', 2500.00, 'Em rota', 3),
  ('ENT-006', 'Santos', 980.00, 'Pendente', 2),
  ('ENT-007', 'Sorocaba', 150.00, 'Entregue', 3),
  ('ENT-008', 'Campinas', 600.00, 'Pendente', 1);
  
  -- Motoristas e suas entregas (incluindo quem não tem nenhuma) 
  SELECT 
    m.id AS motorista_id,
    m.nome,
    m.cnh,
    e.codigo AS codigo_entrega,
    e.destino,
    e.status
FROM motorista m
LEFT JOIN entrega e ON m.id = e.motorista_id;

-- Mesma consulta com INNER JOIN
SELECT 
    m.id AS motorista_id,
    m.nome,
    m.cnh,
    e.codigo AS codigo_entrega,
    e.destino,
    e.status
FROM motorista m
INNER JOIN entrega e ON m.id = e.motorista_id;

-- Motoristas que não têm nenhuma entrega
SELECT 
    m.id,
    m.nome,
    m.cnh,
    m.cidade_base
FROM motorista m
LEFT JOIN entrega e ON m.id = e.motorista_id
WHERE e.id IS NULL;

-- Quantidade de entregas por motorista (incluindo quem tem zero)
SELECT 
    m.id,
    m.nome,
    COUNT(e.id) AS total_entregas
FROM motorista m
LEFT JOIN entrega e ON m.id = e.motorista_id
GROUP BY m.id, m.nome;

-- Motoristas com CNH Categoria 'E' e suas entregas
SELECT 
    m.id AS motorista_id,
    m.nome,
    m.cnh,
    e.codigo AS codigo_entrega,
    e.destino,
    e.status
FROM motorista m
LEFT JOIN entrega e ON m.id = e.motorista_id
WHERE m.cnh = 'E';

-- Exercício 1: Carga total por cidade base
-- Usamos COALESCE(SUM(e.peso_kg), 0) para que, 
-- se a soma for nula (como no caso de cidades que possuem apenas motoristas sem entregas), o resultado exiba 0 em vez de NULL
SELECT 
    m.cidade_base,
    COALESCE(SUM(e.peso_kg), 0) AS total_peso_kg
FROM motorista m
LEFT JOIN entrega e ON m.id = e.motorista_id
GROUP BY m.cidade_base;

-- Exercício 2: Filtrando agregações com HAVING
-- O filtro WHERE atua antes de agrupar as linhas. Quando precisamos filtrar um valor agrupado/calculado (como COUNT, SUM, AVG), 
-- a regra de filtro deve ir obrigatoriamente dentro da cláusula HAVING.
SELECT 
    m.nome,
    COUNT(e.id) AS quantidade_entregas
FROM motorista m
INNER JOIN entrega e ON m.id = e.motorista_id
GROUP BY m.id, m.nome
HAVING COUNT(e.id) > 2;

-- Exercício 3: Entregas pendentes por motorista
-- Ponto-chave: Usar a expressão COUNT(CASE WHEN ... THEN 1 END) permite filtrar 
-- apenas as entregas desejadas mantendo todos os motoristas no LEFT JOIN. Se colocássemos WHERE e.status = 'Pendente', os motoristas com 0 pendências seriam eliminados do resultado.
SELECT 
    m.nome,
    COUNT(CASE WHEN e.status = 'Pendente' THEN 1 END) AS entregas_pendentes
FROM motorista m
LEFT JOIN entrega e ON m.id = e.motorista_id
GROUP BY m.id, m.nome;

-- Exercício 4: Maior entrega de cada motorista
-- Ponto-chave: Usamos INNER JOIN para considerar apenas quem possui entregas e ORDER BY ... DESC para ordenar o resultado do maior peso para o menor
SELECT 
    m.nome,
    MAX(e.peso_kg) AS maior_peso_kg
FROM motorista m
INNER JOIN entrega e ON m.id = e.motorista_id
GROUP BY m.id, m.nome
ORDER BY maior_peso_kg DESC;

-- Exercício 5: Filtro no ON vs WHERE com LEFT JOIN
-- Diferença Crucial (ON vs WHERE):
-- Colocar e.destino = 'Santos' na cláusula ON filtra as entregas antes de fazer a junção. Como é um LEFT JOIN, todos os motoristas continuam aparecendo.
-- Se a condição estivesse no WHERE (WHERE e.destino = 'Santos'), o filtro rodaria depois da junção, descartando todas as linhas com NULL e transformando na prática o LEFT JOIN em um INNER JOIN.
SELECT 
    m.nome,
    e.codigo AS codigo_entrega,
    e.destino,
    e.peso_kg
FROM motorista m
LEFT JOIN entrega e ON m.id = e.motorista_id 
                   AND e.destino = 'Santos';


