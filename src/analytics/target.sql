DROP TABLE IF EXISTS abt_fiel;
CREATE TABLE IF NOT EXISTS abt_fiel AS

WITH tb_target AS (

    SELECT  t1.DtRef,
            t1.IdCliente,
            t1.DescLifeCycle,
            t2.DescLifeCycle AS DescLifeCycleFuturo,
            CASE WHEN t2.DescLifeCycle = '02-FIEL' THEN 1 ELSE 0 END AS flgFiel,
            ROW_NUMBER() OVER (PARTITION BY t1.IdCliente ORDER BY random()) AS RandomCol

    FROM life_cycle AS t1

    LEFT JOIN life_cycle as t2
    ON t1.IdCliente = t2.IdCliente
    AND date(t1.DtRef, '+28 day') = date(t2.DtRef)

    WHERE ((t1.DtRef >= '2024-03-01' AND t1.DtRef <= '2026-08-01')
            OR t1.DtRef = '2026-09-01')
    AND t1.DescLifeCycle <> '05-ZUMBI'

),

tb_cohort AS (

    SELECT  DtRef,
            IdCliente,
            flgFiel

    FROM tb_target

    WHERE RandomCol <= 2

    ORDER BY IdCliente, dtRef

)

SELECT  t1.*,
        t2.idadeDias, 
        t2.QtAtivacaoVida, 
        t2.QtAtivacaoD7, 
        t2.QtAtivacaoD14, 
        t2.QtAtivacaoD28, 
        t2.QtAtivacaoD56, 
        t2.QtTransacaoVida, 
        t2.QtTransacaoD7, 
        t2.QtTransacaoD14, 
        t2.QtTransacaoD28, 
        t2.QtTransacaoD56, 
        t2.SaldoVida, 
        t2.SaldoVidaD7, 
        t2.SaldoVidaD14, 
        t2.SaldoVidaD28, 
        t2.SaldoVidaD56, 
        t2.QtdePontosPosVida, 
        t2.QtdePontosPosVidaD7, 
        t2.QtdePontosPosVidaD14, 
        t2.QtdePontosPosVidaD28, 
        t2.QtdePontosPosVidaD56, 
        t2.QtdePontosNegVida, 
        t2.QtdePontosNegVidaD7, 
        t2.QtdePontosNegVidaD14, 
        t2.QtdePontosNegVidaD28, 
        t2.QtdePontosNegVidaD56, 
        t2.qtdeTransacaoManha, 
        t2.qtdeTransacaoTarde, 
        t2.qtdeTransacaoNoite, 
        t2.pctdeTransacaoManha, 
        t2.pctdeTransacaoTarde, 
        t2.pctdeTransacaoNoite, 
        t2.avgTransacaoDiaD7, 
        t2.avgTransacaoDiaD14, 
        t2.avgTransacaoDiaD28, 
        t2.avgTransacaoDiaD56, 
        t2.pctAtivacaoMAU, 
        t2.qtdeHorasVida, 
        t2.qtdeHorasD7, 
        t2.qtdeHorasD14, 
        t2.qtdeHorasD28, 
        t2.qtdeHorasD56, 
        t2.avgIntervaloDiasVida, 
        t2.avgIntervaloDiasD28, 
        t2.qtAdaga, 
        t2.qtArmadura, 
        t2.qtBotas, 
        t2.qtCajado, 
        t2.qtChapeu, 
        t2.qtChat, 
        t2.qtChurn_model, 
        t2.qtEspada, 
        t2.qtFiel, 
        t2.qtLovers, 
        t2.qtPonei, 
        t2.qtPresent, 
        t2.qtRpg, 
        t2.qtStreamelements,
        t3.QtdeFrequencia, 
        t3.DescLifeCycleAtual, 
        t3.DescLifeCycleD28, 
        t3.pctCURIOSO, 
        t3.pctFIEL, 
        t3.pctREBORN, 
        t3.pctRECONQUISTADO, 
        t3.pctTURISTA, 
        t3.pctDESENCANTADO, 
        t3.pctZUMBI, 
        t3.ratioFreqGrupo,
        t4.qtCursosCompletos, 
        t4.qtCursosIncompletos, 
        t4.carreira, 
        t4.coleta_dados_2024, 
        t4.data_platform_2025, 
        t4.ds_databricks_2024, 
        t4.ds_pontos_2024, 
        t4.estatistica_2024, 
        t4.estatistica_2025, 
        t4.f1_lake, 
        t4.github_2024, 
        t4.github_2025, 
        t4.go_2026, 
        t4.ia_canal_2025, 
        t4.lago_mago_2024, 
        t4.loyalty_predict_2025, 
        t4.machine_learning_2025, 
        t4.matchmaking_trampar_de_casa_2024, 
        t4.meu_agente, 
        t4.ml_2024, 
        t4.mlflow_2025, 
        t4.nekt_2025, 
        t4.pandas_2024, 
        t4.pandas_2025, 
        t4.plataforma_ml_2026, 
        t4.python_2024, 
        t4.python_2025, 
        t4.ragia, 
        t4.speed_f1, 
        t4.sql_2020, 
        t4.sql_2025, 
        t4.streamlit_2025, 
        t4.trampar_lakehouse_2024, 
        t4.tse_analytics_2024, 
        t4.UltimaAtivacao

FROM tb_cohort AS t1

LEFT JOIN fs_transacional AS t2
ON t1.IdCliente = t2.IdCliente
AND t1.DtRef = t2.dtRef


LEFT JOIN fs_life_cycle AS t3
ON t1.IdCliente = t3.IdCliente
AND t1.DtRef = t3.DtRef

LEFT JOIN fs_education AS t4
ON t1.IdCliente = t4.IdCliente
AND t1.DtRef = t4.DtRef
;