WITH tb_life_cycle_atual AS (

    SELECT  
            IdCliente,
            QtdeFrequencia,
            DescLifeCycle AS  DescLifeCycleAtual

    FROM life_cycle

    WHERE DtRef = date('2026-09-01', '-1 day')
),

tb_life_cycleD28 AS (

    SELECT  
            IdCliente,
            DescLifeCycle AS  DescLifeCycleD28

    FROM life_cycle

    WHERE DtRef = date('2026-09-01', '-29 day')

),

tb_share_life_cycle AS (

    SELECT  IdCliente,

            1. * sum(CASE WHEN DescLifeCycle = '01-CURIOSO' THEN 1 ELSE 0 END) / COUNT(*) AS pctCURIOSO,
            1. * sum(CASE WHEN DescLifeCycle = '02-FIEL' THEN 1 ELSE 0 END) / COUNT(*) AS pctFIEL,
            1. * sum(CASE WHEN DescLifeCycle = '02-REBORN' THEN 1 ELSE 0 END) / COUNT(*) AS pctREBORN,
            1. * sum(CASE WHEN DescLifeCycle = '02-RECONQUISTADO' THEN 1 ELSE 0 END) / COUNT(*) AS pctRECONQUISTADO,
            1. * sum(CASE WHEN DescLifeCycle = '03-TURISTA' THEN 1 ELSE 0 END) / COUNT(*) AS pctTURISTA,
            1. * sum(CASE WHEN DescLifeCycle = '04-DESENCANTADO' THEN 1 ELSE 0 END) / COUNT(*) AS pctDESENCANTADO,
            1. * sum(CASE WHEN DescLifeCycle = '05-ZUMBI' THEN 1 ELSE 0 END) / COUNT(*) AS pctZUMBI

    FROM life_cycle

    WHERE DtRef < '2026-09-01'

    GROUP BY IdCliente

),

tb_avg_ciclo AS (

    SELECT  DescLifeCycleAtual,
            avg(QtdeFrequencia) AS avgFreqGrupo

    FROM tb_life_cycle_atual

    GROUP BY DescLifeCycleAtual

),

tb_join AS (

    SELECT  t1.*,
            t2.DescLifeCycleD28,
            t3.pctCURIOSO,
            t3.pctFIEL,
            t3.pctREBORN,
            t3.pctRECONQUISTADO,
            t3.pctTURISTA,
            t3.pctDESENCANTADO,
            t3.pctZUMBI,
            1. * t1.QtdeFrequencia / t4.avgFreqgrupo AS ratioFreqGrupo

    FROM tb_life_cycle_atual AS t1

    LEFT JOIN tb_life_cycleD28 AS t2
    ON t1.IdCliente = t2.IdCliente

    LEFT JOIN tb_share_life_cycle AS t3
    ON t1.IdCliente = t3.IdCliente

    LEFT JOIN tb_avg_ciclo AS t4
    ON t1.DescLifeCycleAtual = t4.DescLifeCycleAtual

)

SELECT  date('2026-09-01', '-1 day') AS DtRef,
        *

FROM tb_join








