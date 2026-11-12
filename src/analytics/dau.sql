SELECT  date(substr(DtCriacao, 0, 11)) AS DtDAU,
        COUNT(DISTINCT IdCliente) AS DAU

FROM transacoes

GROUP BY DtDAU