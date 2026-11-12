SELECT  DtRef,
        DescLifeCycle,
        cluster,
        count(*) AS QtdeCliente


FROM life_cycle

WHERE DescLifeCycle <> '05-ZUMBI'

GROUP BY DtRef, DescLifeCycle, cluster
ORDER BY DtRef, DescLifeCycle, cluster