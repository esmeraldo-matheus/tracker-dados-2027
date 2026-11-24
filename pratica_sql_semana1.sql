-- ============================================================================
-- PRÁTICA SQL — SEMANA 1 A 3 (Modelagem Relacional + Engenharia Analítica)
-- Base fictícia de Service Desk / Suporte de TI
-- Compatível com SQLite (DBeaver / sqlite3) e DuckDB ("One-Button Run")
-- Referências do caderno Data Science: Thomas Nield, Alan Beaulieu, Paulo Cayres
-- ============================================================================

-- 0. Limpeza em ordem reversa de dependência (reprodutibilidade 1-clique)
DROP VIEW IF EXISTS vw_resumo_sla_setor;
DROP TABLE IF EXISTS chamados_ti;
DROP TABLE IF EXISTS tecnicos;
DROP TABLE IF EXISTS setores;

-- 1. Tabelas dimensão normalizadas (integridade via PK e CHECK)
CREATE TABLE setores (
    nome_setor TEXT PRIMARY KEY,
    sla_meta_min INTEGER NOT NULL CHECK (sla_meta_min > 0),
    bloco TEXT NOT NULL
);

CREATE TABLE tecnicos (
    nome_tecnico TEXT PRIMARY KEY,
    especialidade TEXT NOT NULL
);

INSERT INTO setores (nome_setor, sla_meta_min, bloco) VALUES
('Educacao',      60,  'Operacional'),
('Saude',         45,  'Critico'),
('Administracao', 90,  'Corporativo'),
('Fazenda',       60,  'Corporativo'),
('Obras',         120, 'Externo');

INSERT INTO tecnicos (nome_tecnico, especialidade) VALUES
('Matheus', 'Redes e Infraestrutura'),
('Lucas',   'Suporte N1/N2'),
('Carla',   'Sistemas e Acessos');

-- 2. Tabela fato com Chaves Estrangeiras (FK) e validação de domínio (CHECK)
CREATE TABLE chamados_ti (
    id INTEGER PRIMARY KEY,
    data_abertura TEXT NOT NULL,
    setor TEXT NOT NULL,
    categoria TEXT NOT NULL,
    prioridade TEXT NOT NULL CHECK (prioridade IN ('Baixa', 'Media', 'Alta')),
    status TEXT NOT NULL CHECK (status IN ('Aberto', 'Em Andamento', 'Fechado')),
    tecnico TEXT NOT NULL,
    tempo_resolucao_min INTEGER CHECK (tempo_resolucao_min IS NULL OR tempo_resolucao_min >= 0),
    satisfacao INTEGER CHECK (satisfacao IS NULL OR (satisfacao BETWEEN 1 AND 5)),
    FOREIGN KEY (setor) REFERENCES setores(nome_setor),
    FOREIGN KEY (tecnico) REFERENCES tecnicos(nome_tecnico)
);

-- Índice composto em colunas frequentes de filtro (evita varredura completa / table scan)
CREATE INDEX idx_chamados_status_prioridade ON chamados_ti(status, prioridade);

-- 3. Carga de 15 registros realistas
INSERT INTO chamados_ti (id, data_abertura, setor, categoria, prioridade, status, tecnico, tempo_resolucao_min, satisfacao) VALUES
(1,  '2026-11-02', 'Educacao',      'Rede',             'Alta',  'Fechado',      'Matheus', 45,   5),
(2,  '2026-11-02', 'Saude',         'Active Directory', 'Media', 'Fechado',      'Matheus', 15,   5),
(3,  '2026-11-03', 'Administracao', 'Impressora',       'Baixa', 'Fechado',      'Lucas',   60,   4),
(4,  '2026-11-03', 'Educacao',      'Hardware',         'Alta',  'Fechado',      'Matheus', 120,  4),
(5,  '2026-11-04', 'Fazenda',       'Software',         'Media', 'Fechado',      'Carla',   35,   5),
(6,  '2026-11-04', 'Saude',         'Rede',             'Alta',  'Fechado',      'Matheus', 90,   3),
(7,  '2026-11-05', 'Educacao',      'Active Directory', 'Baixa', 'Fechado',      'Lucas',   10,   5),
(8,  '2026-11-06', 'Obras',         'Impressora',       'Baixa', 'Aberto',       'Carla',   NULL, NULL),
(9,  '2026-11-06', 'Saude',         'Hardware',         'Alta',  'Fechado',      'Matheus', 150,  4),
(10, '2026-11-09', 'Administracao', 'Software',         'Media', 'Fechado',      'Lucas',   40,   4),
(11, '2026-11-10', 'Educacao',      'Rede',             'Alta',  'Em Andamento', 'Matheus', NULL, NULL),
(12, '2026-11-11', 'Fazenda',       'Active Directory', 'Media', 'Fechado',      'Carla',   20,   5),
(13, '2026-11-12', 'Saude',         'Software',         'Baixa', 'Fechado',      'Matheus', 25,   5),
(14, '2026-11-13', 'Educacao',      'Impressora',       'Media', 'Fechado',      'Lucas',   55,   3),
(15, '2026-11-16', 'Administracao', 'Rede',             'Alta',  'Fechado',      'Matheus', 75,   5);

-- 4. View explanatória de SLA por setor (pronta para consumo em BI)
CREATE VIEW vw_resumo_sla_setor AS
SELECT
    s.nome_setor AS setor,
    s.bloco,
    s.sla_meta_min,
    COUNT(c.id) AS total_chamados,
    SUM(CASE WHEN c.status = 'Fechado' THEN 1 ELSE 0 END) AS fechados,
    ROUND(AVG(c.tempo_resolucao_min), 1) AS tempo_medio_min,
    SUM(
        CASE
            WHEN c.status = 'Fechado' AND c.tempo_resolucao_min > s.sla_meta_min THEN 1
            ELSE 0
        END
    ) AS fora_do_sla
FROM setores s
LEFT JOIN chamados_ti c ON c.setor = s.nome_setor
GROUP BY s.nome_setor, s.bloco, s.sla_meta_min;

-- ============================================================================
-- DESAFIOS DA SEMANA 1 (Nível 0 -> Básico)
-- Dica: selecione apenas a query que você escrever e execute (Ctrl+Enter no DBeaver).
-- ============================================================================

-- DESAFIO 1 (Dia 2): Liste todas as colunas e linhas da tabela chamados_ti.
-- Dica: SELECT * FROM chamados_ti;


-- DESAFIO 2 (Dia 2): Liste apenas id, setor, categoria e status de todos os chamados.
-- Dica: substitua o * pelos nomes das colunas separados por vírgula.


-- DESAFIO 3 (Dia 2): Filtre apenas os chamados do setor 'Educacao' com prioridade 'Alta'.
-- Dica: use WHERE setor = '...' AND prioridade = '...'


-- DESAFIO 4 (Dia 4): Liste os chamados fechados ordenados do mais demorado para o mais rápido.
-- Dica: WHERE status = 'Fechado' ORDER BY tempo_resolucao_min DESC


-- DESAFIO 5 (Dia 4): Mostre apenas os chamados que ainda NÃO foram concluídos (tempo_resolucao_min é nulo).
-- Dica: WHERE tempo_resolucao_min IS NULL


-- DESAFIO 6 (Dia 4): Conte quantos chamados cada técnico atendeu.
-- Dica: SELECT tecnico, COUNT(*) AS total_chamados FROM chamados_ti GROUP BY tecnico;


-- DESAFIO 7 (Dia 5): Calcule o tempo médio de resolução (em minutos) por categoria (apenas chamados fechados).
-- Dica: use AVG(tempo_resolucao_min) junto com ROUND(..., 1) e GROUP BY categoria.


-- DESAFIO 8 (Dia 5): Qual setor teve mais chamados abertos até agora? Ordene do maior para o menor.
-- Dica: GROUP BY setor + COUNT(*) + ORDER BY ... DESC.


-- ============================================================================
-- DESAFIOS BÔNUS (Semanas 2–3 · Boas Práticas do Caderno Data Science)
-- ============================================================================

-- DESAFIO 9 (JOIN + Filtro antes da junção):
-- Liste id, categoria, especialidade do técnico e meta de SLA dos chamados 'Fechado' com prioridade 'Alta'.
-- Dica: filtre status/prioridade na tabela chamados_ti (com subquery/CTE) ou no WHERE ao cruzar com setores e tecnicos.


-- DESAFIO 10 (CASE WHEN · Conformidade de SLA):
-- Classifique cada chamado fechado como 'Dentro do SLA' ou 'Estourado' comparando tempo_resolucao_min com setores.sla_meta_min.


-- DESAFIO 11 (CTE · WITH):
-- Crie uma CTE apenas com chamados fechados acima de 60 minutos e conte quantos ocorreram por categoria.


-- DESAFIO 12 (VIEW Explanatória):
-- Consulte vw_resumo_sla_setor ordenando do setor com maior número de estouros (fora_do_sla) para o menor.


-- ============================================================================
-- QUERY DE VERIFICAÇÃO ("One-Button Run")
-- ============================================================================
SELECT COUNT(*) AS total_registros_carregados FROM chamados_ti;
