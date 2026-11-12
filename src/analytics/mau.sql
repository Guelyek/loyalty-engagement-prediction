
-- A query abaixo informa a quantidade de 
-- usuários ativos por dia

WITH tb_daily AS (

    SELECT  date(substr(DtCriacao, 0, 11)) AS DtDia,
            IdCliente

    FROM transacoes

),

-- A query abaixo seleciona todos os dias que
-- tiveram pelo menos uma transação

tb_distinct_day AS (
    
    SELECT
            DISTINCT DtDia AS DtRef

    FROM tb_daily

)

SELECT  t1.DtReF,
        COUNT(DISTINCT t2.IdCliente) AS MAU,
        COUNT(DISTINCT t2.DtDia) AS QtdeDias

FROM tb_distinct_day AS t1

LEFT JOIN tb_daily as t2
ON t2.DtDia <= t1.DtRef
AND julianday(t1.DtRef) - julianday(t2.DtDia) < 28

GROUP BY t1.DtRef

ORDER BY t1.DtRef ASC




