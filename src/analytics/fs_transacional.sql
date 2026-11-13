-- Dia de referência: 2025-10-01

    WITH tb_transacao AS (

    SELECT  *,
            substr(dtCriacao, 0, 11) AS dtDia,
            cast(substr(DtCriacao, 12, 2) AS int) AS dtHora

    FROM transacoes

    WHERE dtCriacao <  '2025-10-01'

),

tb_agg_transacao AS (

    SELECT  IdCliente,

            max(julianday(date('2025-10-01', '-1 day')) - julianday(DtCriacao)) AS idadeDias,

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
            sum(DISTINCT CASE WHEN dtDia >= date('2025-10-01', '-56 day') AND QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS QtdePontosNegVidaD56,

            count(CASE WHEN dtHora BETWEEN 10 AND 14 THEN IdTransacao END) AS qtdeTransacaoManha,
            count(CASE WHEN dtHora BETWEEN 15 AND 21 THEN IdTransacao END) AS qtdeTransacaoTarde,
            count(CASE WHEN dtHora > 21 OR dtHora < 10 THEN IdTransacao END) AS qtdeTransacaoNoite,

            1. * count(CASE WHEN dtHora BETWEEN 10 AND 14 THEN IdTransacao END) / count(IdTransacao) AS pctdeTransacaoManha,
            1. * count(CASE WHEN dtHora BETWEEN 15 AND 21 THEN IdTransacao END) / count(IdTransacao) AS pctdeTransacaoTarde,
            1. * count(CASE WHEN dtHora > 21 OR dtHora < 10 THEN IdTransacao END) / count(IdTransacao) AS pctdeTransacaoNoite


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
            dtHora,
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

),

tb_produtos_comprados AS (

    SELECT  t1.IdTransacao,
            t1.IdCliente,
            t1.DtCriacao,
            t3.DescNomeProduto,
            t3.DescCategoriaProduto

    FROM transacoes AS t1

    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao

    LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto


),

tb_share_produtos AS (

    SELECT  t1.IdCliente,

            1. * count(CASE WHEN DescCategoriaProduto = 'adaga' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtAdaga,
            1. * count(CASE WHEN DescCategoriaProduto = 'armadura' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtArmadura,
            1. * count(CASE WHEN DescCategoriaProduto = 'botas' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtBotas,
            1. * count(CASE WHEN DescCategoriaProduto = 'cajado' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtCajado,
            1. * count(CASE WHEN DescCategoriaProduto = 'chapeu' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtChapeu,
            1. * count(CASE WHEN DescCategoriaProduto = 'chat' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtChat,
            1. * count(CASE WHEN DescCategoriaProduto = 'churn_model' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtChurn_model,
            1. * count(CASE WHEN DescCategoriaProduto = 'espada' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtEspada,
            1. * count(CASE WHEN DescCategoriaProduto = 'fiel' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtFiel,
            1. * count(CASE WHEN DescCategoriaProduto = 'lovers' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtLovers,
            1. * count(CASE WHEN DescCategoriaProduto = 'ponei' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtPonei,
            1. * count(CASE WHEN DescCategoriaProduto = 'present' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtPresent,
            1. * count(CASE WHEN DescCategoriaProduto = 'rpg' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtRpg,
            1. * count(CASE WHEN DescCategoriaProduto = 'streamelements' THEN t1.IdTransacao END) / count(t1.IdTransacao) AS qtStreamelements

    FROM tb_transacao AS t1

    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao

    LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto

    GROUP BY t1.IdCliente

),

tb_join AS (

    SELECT  t1.*,
            t2.qtdeHorasVida,
            t2.qtdeHorasD7,
            t2.qtdeHorasD14,
            t2.qtdeHorasD28,
            t2.qtdeHorasD56,
            t3.avgIntervaloDiasVida,
            t3.avgIntervaloDiasD28,
            t4.qtAdaga,
            t4.qtArmadura,
            t4.qtBotas,
            t4.qtCajado,
            t4.qtChapeu,
            t4.qtChat,
            t4.qtChurn_model,
            t4.qtEspada,
            t4.qtFiel,
            t4.qtLovers,
            t4.qtPonei,
            t4.qtPresent,
            t4.qtRpg,
            t4.qtStreamelements

    FROM tb_agg_calc AS t1

    LEFT JOIN tb_hora_cliente as t2
    On t1.IdCliente = t2.IdCliente

    LEFT JOIN tb_intervalo_dias AS t3
    ON t1.IdCliente = t3.IdCliente

    LEFT JOIN tb_share_produtos AS t4
    ON t1.IdCliente = t4.IdCliente

)

SELECT  date('2025-10-01', '-1 day') AS dtRef,
        *

FROM tb_join