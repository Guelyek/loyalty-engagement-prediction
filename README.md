# Loyalty Predict: previsão de engajamento de usuários

🚧 **Projeto em desenvolvimento**

Projeto de Ciência de Dados e Machine Learning voltado à identificação
de mudanças no engajamento de usuários de uma comunidade, a partir do
histórico de pontos e atividades.

O trabalho é baseado no curso **Loyalty Predict**, de [Téo Me
Why](https://teomewhy.org/), e inclui uma extensão própria do período
analisado até **outubro de 2026**.

> **Nota sobre o escopo:** o projeto ainda está em desenvolvimento. Esta
> documentação distingue as etapas já implementadas das próximas etapas
> planejadas. Não há, neste momento, resultados de modelos preditivos a
> apresentar.

------------------------------------------------------------------------

## 1. Objetivo

Investigar como o comportamento dos usuários evolui ao longo do tempo e
construir uma base analítica que permita estudar perda ou ganho de
engajamento.

A proposta é organizar o histórico de atividades, caracterizar os
usuários por meio de variáveis comportamentais e, nas próximas etapas,
avaliar modelos capazes de apoiar a previsão de mudanças no engajamento.

## 2. Dados

São utilizados datasets públicos disponibilizados no Kaggle:

-   [Téo Me Why --- Loyalty
    System](https://www.kaggle.com/datasets/teocalvo/teomewhy-loyalty-system)
-   [Téo Me Why --- Education
    Platform](https://www.kaggle.com/datasets/teocalvo/teomewhy-education-platform)

A análise foi estendida até **outubro de 2026**. No material original do
curso, o período de referência chegava a setembro de 2025.

## 3. Etapas implementadas

### 3.1. Preparação e histórico analítico

Foi desenvolvido um pipeline utilizando **Python, SQL, SQLite,
SQLAlchemy e Pandas** para organizar o histórico de dados e acompanhar a
evolução dos usuários.

O processamento inclui a definição do ciclo de vida dos usuários e a
construção de **32 snapshots mensais**, cobrindo o período de 2024 a
2026.

### 3.2. Engenharia de atributos

Foi construída uma feature store analítica com **mais de 50 variáveis**
relacionadas ao comportamento dos usuários, incluindo:

-   Frequência e recência de atividades;
-   Saldo de pontos;
-   Intervalos entre ativações;
-   Janelas temporais de 7 a 56 dias;
-   Horários de atividade;
-   Categorias de produtos.

As variáveis foram organizadas para representar diferentes dimensões do
comportamento e permitir análises ao longo do tempo.

### 3.3. Segmentação de usuários

Foi aplicada uma abordagem de clusterização com **K-Means**, utilizando
`scikit-learn`, para explorar agrupamentos de usuários segundo
características de frequência e valor.

A etapa incluiu tratamento de outliers e visualização dos resultados com
Matplotlib e Seaborn.

**Importante:** a segmentação é uma análise exploratória não
supervisionada. Ela não deve ser interpretada como um modelo preditivo
de perda ou ganho de engajamento.

## 4. Tecnologias utilizadas

  -----------------------------------------------------------------------
  Área                                Tecnologias e métodos
  ----------------------------------- -----------------------------------
  Linguagem                           Python

  Banco de dados e consultas          SQL, SQLite

  Manipulação de dados                Pandas, SQLAlchemy

  Engenharia de atributos             Features comportamentais e janelas
                                      temporais

  Machine Learning                    scikit-learn, K-Means

  Visualização                        Matplotlib, Seaborn

  Organização do código               Git e GitHub
  -----------------------------------------------------------------------

## 5. Próximas etapas

As próximas etapas planejadas são:

1.  Definir a variável-alvo e a estratégia de validação temporal para o
    problema preditivo.
2.  Treinar e comparar modelos supervisionados adequados ao objetivo.
3.  Avaliar os modelos com métricas compatíveis com o problema e
    analisar seus erros.
4.  Registrar configurações e resultados dos experimentos com MLflow.
5.  Desenvolver uma aplicação de inferência com Streamlit.

Essas atividades são **planejadas** e não devem ser consideradas
implementadas até que estejam disponíveis no repositório.

## 6. Estrutura do repositório

O código analítico está organizado em `src/analytics`. A estrutura será
detalhada à medida que os módulos e etapas do projeto forem
consolidados.

## 7. Como executar

As instruções de instalação e execução serão adicionadas após a
consolidação dos pontos de entrada do projeto, das dependências e da
organização dos dados.

Os datasets devem ser obtidos diretamente nas páginas do Kaggle
indicadas na seção [Dados](#2-dados). Não são incluídos neste
repositório arquivos de dados de terceiros.

## 8. Créditos e contribuições

Este projeto foi desenvolvido **a partir do curso Loyalty Predict, de
[Téo Me Why](https://teomewhy.org/)**. A estrutura das consultas e a
definição do ciclo de vida dos usuários seguem o material do curso.

**Contribuição própria destacada:**

-   Extensão do período analisado até outubro de 2026, em comparação com
    setembro de 2025 no material do curso.

As demais implementações e adaptações devem ser interpretadas
considerando essa referência. O objetivo é documentar com transparência
o que foi desenvolvido a partir do curso e o que foi acrescentado ao
projeto.

------------------------------------------------------------------------

**Status:** em desenvolvimento.
