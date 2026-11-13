-- Dia de referência: 2025-10-01

    WITH tb_transacao AS (

    SELECT  *,
            substr(dtCriacao, 0, 11) AS dtDia

    FROM transacoes

    WHERE dtCriacao <  '2025-10-01'

),

tb_agg_transacao AS (

    SELECT  IdCliente,
            count(DISTINCT dtDia) AS QtAtivacaoVida,
            count(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-7 day') THEN dtDia END) AS QtAtivacaoD7,
            count(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-14 day') THEN dtDia END) AS QtAtivacaoD14,
            count(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-28 day') THEN dtDia END) AS QtAtivacaoD28,
            count(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-56 day') THEN dtDia END) AS QtAtivacaoD56,

            count(DISTINCT IdTransacao) AS QtTransacaoVida,
            count(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-7 day') THEN IdTransacao END) AS QtTransacaoD7,
            count(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-14 day') THEN IdTransacao END) AS QtTransacaoD14,
            count(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-28 day') THEN IdTransacao END) AS QtTransacaoD28,
            count(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-56 day') THEN IdTransacao END) AS QtTransacaoD56,

            sum(QtdePontos) AS SaldoVida,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-7 day') THEN QtdePontos ELSE 0 END) AS SaldoVidaD7,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-14 day') THEN QtdePontos ELSE 0 END) AS SaldoVidaD14,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-28 day') THEN QtdePontos ELSE 0 END) AS SaldoVidaD28,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-56 day') THEN QtdePontos ELSE 0 END) AS SaldoVidaD56,

            sum(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPosVida,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-7 day') AND QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPosVidaD7,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-14 day') AND QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPosVidaD14,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-28 day') AND QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPosVidaD28,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-56 day') AND QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPosVidaD56,

            sum(CASE WHEN QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS QtdePontosNegVida,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-7 day') AND QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS QtdePontosNegVidaD7,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-14 day') AND QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS QtdePontosNegVidaD14,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-28 day') AND QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS QtdePontosNegVidaD28,
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-56 day') AND QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS QtdePontosNegVidaD56


    FROM tb_transacao

    GROUP BY IdCliente
),

tb_agg_calc AS (

    SELECT  *,
            COALESCE(1. * QtTransacaoD7 / QtAtivacaoD7, 0) AS avgTransacaoDiaD7,
            COALESCE(1. * QtTransacaoD14 / QtAtivacaoD14, 0) AS avgTransacaoDiaD14,
            COALESCE(1. * QtTransacaoD28 / QtAtivacaoD28, 0) AS avgTransacaoDiaD28,
            COALESCE(1. * QtTransacaoD56 / QtAtivacaoD56, 0) AS avgTransacaoDiaD56,
            COALESCE(1. * QtAtivacaoD28 / 28, 0) AS pctAtivacaoMAU

    FROM tb_agg_transacao

),

tb_horas_dia AS (

    SELECT  IdCliente,
            dtDia,
            julianday(min(DtCriacao)) AS dtEntradaLive,
            julianday(max(DtCriacao)) AS dtSaidaLive,
            24 * (julianday(max(DtCriacao)) - julianday(min(DtCriacao))) AS qtHorasAssistidas

    FROM tb_transacao

    GROUP BY IdCliente, dtDia

),

tb_hora_cliente AS (

    SELECT  IdCliente,
            sum(qtHorasAssistidas) AS qtdeHorasVida,
            sum(CASE WHEN dtDIA >= date('2025-10-01', '-7 day') THEN qtHorasAssistidas ELSE 0 END) AS qtdeHorasD7,
            sum(CASE WHEN dtDIA >= date('2025-10-01', '-14 day') THEN qtHorasAssistidas ELSE 0 END) AS qtdeHorasD14,
            sum(CASE WHEN dtDIA >= date('2025-10-01', '-28 day') THEN qtHorasAssistidas ELSE 0 END) AS qtdeHorasD28,
            sum(CASE WHEN dtDIA >= date('2025-10-01', '-56 day') THEN qtHorasAssistidas ELSE 0 END) AS qtdeHorasD56

    FROM tb_horas_dia

    GROUP BY IdCliente

),

tb_lag_dia AS (

    SELECT  IdCliente,
            dtDia,
            LAG(dtDia) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS lagDia

    from tb_horas_dia

),

tb_intervalo_dias AS (

    SELECT  IdCliente,
            avg(julianday(dtDia) - julianday(lagDia)) AS avgIntervaloDiasVida,
            avg(CASE WHEN dtDia >= date('2025-10-01', '-28 day') THEN julianday(dtDia) - julianday(lagDia) END) AS avgIntervaloDiasD28

    FROm tb_lag_dia
    GROUP BY IdCliente

)

SELECT  t1.*,
        t2.qtdeHorasVida,
        t2.qtdeHorasD7,
        t2.qtdeHorasD14,
        t2.qtdeHorasD28,
        t2.qtdeHorasD56,
        t3.avgIntervaloDiasVida,
        t3.avgIntervaloDiasD28

FROM tb_agg_calc AS t1

LEFT JOIN tb_hora_cliente as t2
On t1.IdCliente = t2.IdCliente

LEFT JOIN tb_intervalo_dias AS t3
ON t1.IdCliente = t3.IdCliente


