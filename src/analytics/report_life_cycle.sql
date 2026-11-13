SELECT  DtRef,
        DescLifeCycle,
        count(*) AS QtdeCliente


FROM life_cycle

WHERE DescLifeCycle <> '05-ZUMBI'
AND DtRef = date('2025-10-01', '-1 day')

GROUP BY DtRef, DescLifeCycle
ORDER BY DtRef, DescLifeCycle