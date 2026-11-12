-- curioso -> idade < 7
-- fiel -> recência < 7 e recência anterior < 15
-- turista -> 7 <= recência <= 14
-- desencantado -> 14 < recência <= 28
-- zumbi -> recência > 28
-- reconquistado -> recência < 7 e 14 <= recencia anterior <= 28
-- reborn -> recência < 7 e recencia anterior > 28

WITH tb_daily AS (

    SELECT
            DISTINCT
            IdCliente,
            substr(DtCriacao, 0, 11) AS DtTransacao

    FROM transacoes
    WHERE DtTransacao < '{date}'

),

tb_idade AS (

    SELECT  IdCliente,
            cast(max(julianday('{date}') - julianday(DtTransacao)) AS int) AS QtdeDiasPrimeiraTransacao,
            cast(min(julianday('{date}') - julianday(DtTransacao)) AS int) AS QtdeDiasUltimaTransacao

    FROM tb_daily

    GROUP BY IdCliente

),

tb_rn AS (

    SELECT  *,
            row_number() OVER (PARTITION BY IdCliente ORDER BY DtTransacao desc) AS rnDia

    FROM tb_daily

),

tb_penultima_ativacao AS (

    SELECT  *,
            CAST(julianday('{date}') - julianday(DtTransacao) AS int) AS QtdeDiasPenultimaTransacao

    FROM tb_rn

    WHERE rnDia = 2

),

tb_life_cycle AS (

    SELECT  t1.*,
            t2.QtdeDiasPenultimaTransacao,

    CASE
        WHEN QtdeDiasPrimeiraTransacao <= 7 THEN '01-CURIOSO'
        WHEN QtdeDiasUltimaTransacao <= 7 AND QtdeDiasPenultimaTransacao - QtdeDiasUltimaTransacao<= 14 THEN '02-FIEL'
        WHEN QtdeDiasUltimaTransacao BETWEEN 8 AND 14 THEN '03-TURISTA'
        WHEN QtdeDiasUltimaTransacao BETWEEN 15 AND 28 THEN '04-DESENCANTADO'
        WHEN QtdeDiasUltimaTransacao > 28 THEN '05-ZUMBI'
        WHEN QtdeDiasUltimaTransacao <= 7 AND QtdeDiasPenultimaTransacao BETWEEN 15 AND 27 THEN '02-RECONQUISTADO'
        WHEN QtdeDiasUltimaTransacao <= 7 AND QtdeDiasPenultimaTransacao > 27 THEN '02-REBORN'
    END AS DescLifeCycle

    FROM tb_idade AS t1

    LEFT JOIN tb_penultima_ativacao AS t2
    ON t1.IdCliente = t2.IdCliente

),

tb_freq_valor AS (

    SELECT  IdCliente,
            count(DISTINCT substr(DtCriacao, 0, 11)) AS QtdeFrequencia,
            sum(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPos,
            sum(abs(QtdePontos))

    FROM transacoes

    WHERE DtCriacao < '{date}'
    AND DtCriacao >= date('{date}', '-28 days')

    GROUP BY IdCliente

    ORDER BY QtdeFrequencia DESC

),

tb_cluster AS (

    SELECT  *,
            CASE
                WHEN 'QtdeFrequencia' <= 10 AND QtdePontosPos >= 1500 THEN '12-HYPER'
                WHEN 'QtdeFrequencia' > 10 AND QtdePontosPos >= 1500 THEN '22 - EFICIENTE'
                WHEN 'QtdeFrequencia' <= 10 AND QtdePontosPos >= 750 THEN '11-INDECISO'
                WHEN 'QtdeFrequencia' > 10 AND QtdePontosPos >= 750 THEN '21-ESFORÇADO'
                WHEN 'QtdeFrequencia' < 5 THEN '00-LURKER'
                WHEN 'QtdeFrequencia' <= 10 THEN '10-PREGUIÇOSO'
                WHEN 'QtdeFrequencia' > 10 THEN '20-POTENCIAL'
            END AS cluster

    FROM tb_freq_valor

)

SELECT
        date('{date}', '-1 day') AS DtRef,
        t1.*,
        t2.QtdeFrequencia,
        t2.QtdePontosPos,
        t2.cluster

FROM tb_life_cycle AS t1

LEFT JOIN tb_cluster as t2
ON t1.IdCliente = t2.IdCliente




