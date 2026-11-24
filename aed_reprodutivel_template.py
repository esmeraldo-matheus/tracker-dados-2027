"""Template reprodutivel de AED ("One-Button Run") e modulo introdutorio de Bioinformatica.

Baseado nas boas praticas do caderno Data Science (PEP 8, modularidade DRY,
execucao de ponta a ponta sem intervencao manual, estatistica robusta e
storytelling explanatorio).
"""

from __future__ import annotations

import sqlite3
import statistics
from pathlib import Path
from typing import Any


SQL_SCRIPT_PADRAO = Path(__file__).with_name("pratica_sql_semana1.sql")


def carregar_dados_service_desk(caminho_sql: Path) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Carrega o schema SQL em memoria e retorna chamados fechados e resumo de SLA."""
    if not caminho_sql.exists():
        raise FileNotFoundError(f"Arquivo SQL nao encontrado: {caminho_sql}")

    sql_bruto = caminho_sql.read_text(encoding="utf-8")
    conn = sqlite3.connect(":memory:")
    conn.row_factory = sqlite3.Row
    try:
        conn.executescript(sql_bruto)
        chamados = conn.execute(
            """
            SELECT c.id, c.setor, c.categoria, c.prioridade, c.tecnico,
                   c.tempo_resolucao_min, s.sla_meta_min
            FROM chamados_ti c
            INNER JOIN setores s ON s.nome_setor = c.setor
            WHERE c.status = 'Fechado' AND c.tempo_resolucao_min IS NOT NULL
            ORDER BY c.tempo_resolucao_min ASC
            """
        ).fetchall()
        resumo_setor = conn.execute(
            "SELECT * FROM vw_resumo_sla_setor ORDER BY fora_do_sla DESC, tempo_medio_min DESC"
        ).fetchall()
        return [dict(row) for row in chamados], [dict(row) for row in resumo_setor]
    finally:
        conn.close()


def calcular_estatisticas_robustas(valores: list[float]) -> dict[str, Any]:
    """Calcula medidas de posicao, variabilidade (IQR) e outliers (Bruce & Bruce)."""
    if len(valores) < 4:
        raise ValueError("Sao necessarios pelo menos 4 valores para calcular quartis e IQR.")

    ordenados = sorted(valores)
    q1, mediana, q3 = statistics.quantiles(ordenados, n=4, method="inclusive")
    iqr = q3 - q1
    limite_superior = q3 + 1.5 * iqr
    limite_inferior = max(0.0, q1 - 1.5 * iqr)
    outliers = [v for v in ordenados if v > limite_superior or v < limite_inferior]

    return {
        "n": len(ordenados),
        "media": round(statistics.mean(ordenados), 1),
        "mediana": round(mediana, 1),
        "desvio_padrao": round(statistics.stdev(ordenados), 1),
        "q1": round(q1, 1),
        "q3": round(q3, 1),
        "iqr": round(iqr, 1),
        "limite_superior": round(limite_superior, 1),
        "outliers": outliers,
    }


def imprimir_relatorio_aed(chamados: list[dict[str, Any]], resumo_setor: list[dict[str, Any]]) -> None:
    """Imprime sintese explanatoria orientada a decisao (Cole Knaflic)."""
    tempos = [float(item["tempo_resolucao_min"]) for item in chamados]
    stats = calcular_estatisticas_robustas(tempos)

    print("=== 1. AED ROBUSTA — TEMPO DE RESOLUCAO (CHAMADOS FECHADOS) ===")
    print(f"Amostra analisada (n): {stats['n']} chamados")
    print(f"Media: {stats['media']} min | Mediana: {stats['mediana']} min | Desvio-padrao: {stats['desvio_padrao']} min")
    print(f"Q1: {stats['q1']} min | Q3: {stats['q3']} min | IQR: {stats['iqr']} min")
    print(f"Limite superior Tukey (Q3 + 1.5*IQR): {stats['limite_superior']} min")
    print(f"Outliers detectados: {stats['outliers'] if stats['outliers'] else 'Nenhum'}")

    print("\n=== 2. INSIGHT EXPLANATORIO DE SLA POR SETOR ===")
    for row in resumo_setor:
        alerta = " [ATENCAO: ESTOURO]" if (row["fora_do_sla"] or 0) > 0 else ""
        print(
            f"- {row['setor']} ({row['bloco']}): media {row['tempo_medio_min']} min "
            f"(meta {row['sla_meta_min']} min) | fora do SLA: {row['fora_do_sla']}{alerta}"
        )


def analisar_sequencia_dna(sequencia: str) -> dict[str, Any]:
    """Valida sequencia de DNA, calcula conteudo GC (%) e transcreve para RNA."""
    seq = sequencia.strip().upper()
    bases_validas = {"A", "T", "C", "G"}
    if not seq or any(base not in bases_validas for base in seq):
        raise ValueError("Sequencia invalida: informe apenas bases A, T, C e G.")

    contagem = {base: seq.count(base) for base in ("A", "T", "C", "G")}
    gc_pct = round(((contagem["G"] + contagem["C"]) / len(seq)) * 100, 2)
    return {
        "tamanho_pb": len(seq),
        "contagem": contagem,
        "conteudo_gc_pct": gc_pct,
        "rna_transcrito": seq.replace("T", "U"),
    }


def main() -> None:
    """Ponto de entrada linear para execucao completa com um comando."""
    try:
        chamados, resumo_setor = carregar_dados_service_desk(SQL_SCRIPT_PADRAO)
        imprimir_relatorio_aed(chamados, resumo_setor)

        amostra_dna = "ATGGCTAGCGTAACGTAGCTAG"
        bio = analisar_sequencia_dna(amostra_dna)
        print("\n=== 3. BONUS BIOINFORMATICA (FUNDAMENTOS PRE-BIOPYTHON) ===")
        print(f"Sequencia ({bio['tamanho_pb']} pb): {amostra_dna}")
        print(f"Contagem de bases: {bio['contagem']} | Conteudo GC: {bio['conteudo_gc_pct']}%")
        print(f"RNA transcrito: {bio['rna_transcrito']}")
    except (FileNotFoundError, ValueError, sqlite3.Error) as err:
        print(f"Erro controlado na execucao do template: {err}")


if __name__ == "__main__":
    main()
