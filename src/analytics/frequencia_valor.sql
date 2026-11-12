WITH tb_freq_valor AS (

    SELECT  IdCliente,
            count(DISTINCT substr(DtCriacao, 0, 11)) AS QtdeFrequencia,
            sum(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPos,
            sum(abs(QtdePontos))

    FROM transacoes

    WHERE DtCriacao < '2025-09-01'
    AND DtCriacao >= date('2025-09-01', '-28 days')

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

SELECT *

FROM tb_cluster