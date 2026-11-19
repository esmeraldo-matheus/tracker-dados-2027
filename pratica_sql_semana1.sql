-- ============================================================================
-- PRÁTICA SQL — SEMANA 1 (Nível 0 -> Básico)
-- Base fictícia inspirada em Service Desk / Suporte de TI Municipal
-- Compatível com SQLite (DBeaver / sqlite3) e DuckDB
-- ============================================================================

-- Remove a tabela caso você queira rodar o script do zero novamente
DROP TABLE IF EXISTS chamados_ti;

-- 1. Criação da tabela de chamados
CREATE TABLE chamados_ti (
    id INTEGER PRIMARY KEY,
    data_abertura TEXT NOT NULL,
    setor TEXT NOT NULL,
    categoria TEXT NOT NULL,
    prioridade TEXT NOT NULL,
    status TEXT NOT NULL,
    tecnico TEXT NOT NULL,
    tempo_resolucao_min INTEGER,
    satisfacao INTEGER
);

-- 2. Inserção de 15 chamados realistas
INSERT INTO chamados_ti (id, data_abertura, setor, categoria, prioridade, status, tecnico, tempo_resolucao_min, satisfacao) VALUES
(1,  '2026-11-02', 'Educacao',      'Rede',             'Alta',  'Fechado',    'Matheus', 45,   5),
(2,  '2026-11-02', 'Saude',         'Active Directory', 'Media', 'Fechado',    'Matheus', 15,   5),
(3,  '2026-11-03', 'Administracao', 'Impressora',       'Baixa', 'Fechado',    'Lucas',   60,   4),
(4,  '2026-11-03', 'Educacao',      'Hardware',         'Alta',  'Fechado',    'Matheus', 120,  4),
(5,  '2026-11-04', 'Fazenda',       'Software',         'Media', 'Fechado',    'Carla',   35,   5),
(6,  '2026-11-04', 'Saude',         'Rede',             'Alta',  'Fechado',    'Matheus', 90,   3),
(7,  '2026-11-05', 'Educacao',      'Active Directory', 'Baixa', 'Fechado',    'Lucas',   10,   5),
(8,  '2026-11-06', 'Obras',         'Impressora',       'Baixa', 'Aberto',     'Carla',   NULL, NULL),
(9,  '2026-11-06', 'Saude',         'Hardware',         'Alta',  'Fechado',    'Matheus', 150,  4),
(10, '2026-11-09', 'Administracao', 'Software',         'Media', 'Fechado',    'Lucas',   40,   4),
(11, '2026-11-10', 'Educacao',      'Rede',             'Alta',  'Em Andamento','Matheus', NULL, NULL),
(12, '2026-11-11', 'Fazenda',       'Active Directory', 'Media', 'Fechado',    'Carla',   20,   5),
(13, '2026-11-12', 'Saude',         'Software',         'Baixa', 'Fechado',    'Matheus', 25,   5),
(14, '2026-11-13', 'Educacao',      'Impressora',       'Media', 'Fechado',    'Lucas',   55,   3),
(15, '2026-11-16', 'Administracao', 'Rede',             'Alta',  'Fechado',    'Matheus', 75,   5);

-- ============================================================================
-- DESAFIOS DA SEMANA 1
-- Dica: selecione apenas a query que você escrever e execute (Ctrl+Enter no DBeaver).
-- ============================================================================

-- DESAFIO 1 (Dia 2): Liste todas as colunas e linhas da tabela chamados_ti.
-- Dica: SELECT * FROM ...


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
-- QUERY DE VERIFICAÇÃO (para confirmar que a carga inicial funcionou)
-- ============================================================================
SELECT COUNT(*) AS total_registros_carregados FROM chamados_ti;
