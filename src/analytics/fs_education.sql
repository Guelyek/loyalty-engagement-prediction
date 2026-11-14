WITH tb_usuario_cursos AS (
        
        SELECT  idUsuario,
                descSlugCurso,
                COUNT(descSlugCursoEpisodio) AS qtdeEps

        FROM cursos_episodios_completos

        WHERE DtCriacao < '2026-11-01'

        GROUP BY idUsuario, descSlugCurso

),

tb_qt_episodios_curso AS (

    SELECT  descSlugCurso,
            count(descSlugCurso) AS qtEpisodiosCurso

    FROM cursos_episodios

    GROUP BY descSlugCurso

),

tb_pct_curso AS (

    SELECT  t1.idUsuario,
            t1.descSlugCurso,
            1. * t1.qtdeEps / t2.qtEpisodiosCurso AS pctCursoCompleto

    FROM tb_usuario_cursos AS t1

    LEFT JOIN tb_qt_episodios_curso AS t2
    ON t1.descSlugCurso = t2.descSlugCurso

),

tb_pct_cursos_pivot AS (

    SELECT  idUsuario,

            SUM(CASE WHEN pctCursoCompleto = 1 THEN 1 ELSE 0 END) AS qtCursosCompletos,
            SUM(CASE WHEN pctCursoCompleto < 1 AND pctCursoCompleto > 0 THEN 1 ELSE 0 END) AS qtCursosIncompletos,

            SUM(CASE WHEN descSlugCurso = "carreira" THEN pctCursoCompleto ELSE 0 END) AS carreira,
            SUM(CASE WHEN descSlugCurso = "coleta-dados-2024" THEN pctCursoCompleto ELSE 0 END) AS coleta_dados_2024,
            SUM(CASE WHEN descSlugCurso = "data-platform-2025" THEN pctCursoCompleto ELSE 0 END) AS data_platform_2025,
            SUM(CASE WHEN descSlugCurso = "ds-databricks-2024" THEN pctCursoCompleto ELSE 0 END) AS ds_databricks_2024,
            SUM(CASE WHEN descSlugCurso = "ds-pontos-2024" THEN pctCursoCompleto ELSE 0 END) AS ds_pontos_2024,
            SUM(CASE WHEN descSlugCurso = "estatistica-2024" THEN pctCursoCompleto ELSE 0 END) AS estatistica_2024,
            SUM(CASE WHEN descSlugCurso = "estatistica-2025" THEN pctCursoCompleto ELSE 0 END) AS estatistica_2025,
            SUM(CASE WHEN descSlugCurso = "f1-lake" THEN pctCursoCompleto ELSE 0 END) AS f1_lake,
            SUM(CASE WHEN descSlugCurso = "github-2024" THEN pctCursoCompleto ELSE 0 END) AS github_2024,
            SUM(CASE WHEN descSlugCurso = "github-2025" THEN pctCursoCompleto ELSE 0 END) AS github_2025,
            SUM(CASE WHEN descSlugCurso = "go-2026" THEN pctCursoCompleto ELSE 0 END) AS go_2026,
            SUM(CASE WHEN descSlugCurso = "ia-canal-2025" THEN pctCursoCompleto ELSE 0 END) AS ia_canal_2025,
            SUM(CASE WHEN descSlugCurso = "lago-mago-2024" THEN pctCursoCompleto ELSE 0 END) AS lago_mago_2024,
            SUM(CASE WHEN descSlugCurso = "loyalty-predict-2025" THEN pctCursoCompleto ELSE 0 END) AS loyalty_predict_2025,
            SUM(CASE WHEN descSlugCurso = "machine-learning-2025" THEN pctCursoCompleto ELSE 0 END) AS machine_learning_2025,
            SUM(CASE WHEN descSlugCurso = "matchmaking-trampar-de-casa-2024" THEN pctCursoCompleto ELSE 0 END) AS matchmaking_trampar_de_casa_2024,
            SUM(CASE WHEN descSlugCurso = "meu-agente" THEN pctCursoCompleto ELSE 0 END) AS meu_agente,
            SUM(CASE WHEN descSlugCurso = "ml-2024" THEN pctCursoCompleto ELSE 0 END) AS ml_2024,
            SUM(CASE WHEN descSlugCurso = "mlflow-2025" THEN pctCursoCompleto ELSE 0 END) AS mlflow_2025,
            SUM(CASE WHEN descSlugCurso = "nekt-2025" THEN pctCursoCompleto ELSE 0 END) AS nekt_2025,
            SUM(CASE WHEN descSlugCurso = "pandas-2024" THEN pctCursoCompleto ELSE 0 END) AS pandas_2024,
            SUM(CASE WHEN descSlugCurso = "pandas-2025" THEN pctCursoCompleto ELSE 0 END) AS pandas_2025,
            SUM(CASE WHEN descSlugCurso = "plataforma-ml-2026" THEN pctCursoCompleto ELSE 0 END) AS plataforma_ml_2026,
            SUM(CASE WHEN descSlugCurso = "python-2024" THEN pctCursoCompleto ELSE 0 END) AS python_2024,
            SUM(CASE WHEN descSlugCurso = "python-2025" THEN pctCursoCompleto ELSE 0 END) AS python_2025,
            SUM(CASE WHEN descSlugCurso = "ragia" THEN pctCursoCompleto ELSE 0 END) AS ragia,
            SUM(CASE WHEN descSlugCurso = "speed-f1" THEN pctCursoCompleto ELSE 0 END) AS speed_f1,
            SUM(CASE WHEN descSlugCurso = "sql-2020" THEN pctCursoCompleto ELSE 0 END) AS sql_2020,
            SUM(CASE WHEN descSlugCurso = "sql-2025" THEN pctCursoCompleto ELSE 0 END) AS sql_2025,
            SUM(CASE WHEN descSlugCurso = "streamlit-2025" THEN pctCursoCompleto ELSE 0 END) AS streamlit_2025,
            SUM(CASE WHEN descSlugCurso = "trampar-lakehouse-2024" THEN pctCursoCompleto ELSE 0 END) AS trampar_lakehouse_2024,
            SUM(CASE WHEN descSlugCurso = "tse-analytics-2024" THEN pctCursoCompleto ELSE 0 END) AS tse_analytics_2024

    FROM tb_pct_curso

    GROUP BY idUsuario

),

    tb_ultimas_ativacoes AS (

    SELECT  idUsuario,
            substr(dtCriacao, 1, 10) AS dtAtividade

    FROM cursos_episodios_completos

    WHERE dtCriacao < '2026-11-01'

    UNION ALL

    SELECT  idUsuario,
            substr(dtRecompensa, 1, 10) AS dtAtividade

    FROM recompensas_usuarios

    WHERE dtRecompensa < '2026-11-01'

    UNION ALL

    SELECT  idUsuario,
            substr(dtCriacao, 1, 10) AS dtAtividade

    FROM habilidades_usuarios

    WHERE dtCriacao < '2026-11-01'

),

tb_ultima_ativacao AS (

SELECT  idUsuario,
        MAX(dtAtividade) AS UltimaAtivacao

FROM tb_ultimas_ativacoes

GROUP BY idUsuario

),

tb_join AS (

    SELECT  
            t3.idTMWCliente AS IdCliente,
            t1.*,
            t2.UltimaAtivacao

    FROM tb_pct_cursos_pivot AS t1

    LEFT JOIN tb_ultima_ativacao AS t2
    ON t1.idUsuario = t2.idUsuario

    INNER JOIN usuarios_tmw AS t3
    ON t1.idUsuario = t3.idUsuario

)

SELECT  date('2026-11-01', '-1 day') AS DtRef,
        *

FROM tb_join






    













