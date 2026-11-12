SELECT  DtRef,
        DescLifeCycle,
        count(*) AS QtdeCliente

FROM life_cycle

WHERE DescLifeCycle <> '05-ZUMBI'

GROUP BY DtRef, DescLifeCycle
ORDER BY DtRef, DescLifeCycle