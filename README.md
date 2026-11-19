# Dinâmica Temporal do IC-Br: Abordagem de Séries Temporais Aplicada aos Setores de Commodities

**Autor:** Olavo Francisquini  
**Orientadora:** Profa. Dra. Elisângela Aparecida da Silva Lizzi  
**Instituição:** Universidade Tecnológica Federal do Paraná (UTFPR) – Campus Cornélio Procópio  
**Curso:** Licenciatura em Matemática  
**Ano:** 2026

---

## Sobre o projeto

Este repositório reúne os códigos computacionais, dados e materiais complementares desenvolvidos no Trabalho de Conclusão de Curso intitulado *Dinâmica Temporal do IC-Br: Abordagem de Séries Temporais Aplicada aos Setores de Commodities*.

A pesquisa investiga o comportamento temporal do Índice de Commodities Brasil (IC-Br), indicador elaborado pelo Banco Central do Brasil, e de seus principais subgrupos: agropecuário, energético e metálico.

Por meio de técnicas estatísticas de análise de séries temporais e suavização exponencial, busca-se identificar padrões de comportamento, tendências e componentes sazonais, além de avaliar a capacidade dos modelos em produzir previsões para períodos futuros.

O projeto está inserido no campo da Matemática Aplicada e da Estatística, destacando a utilização de métodos quantitativos na compreensão de fenômenos econômicos.

## Objetivos

### Objetivo geral

Modelar e analisar as séries temporais do Índice de Commodities Brasil (IC-Br) e de seus subgrupos, utilizando métodos estatísticos de suavização exponencial para avaliar sua capacidade de representação dos padrões temporais e seu potencial preditivo.

### Objetivos específicos

- Revisar os fundamentos teóricos de probabilidade, processos estocásticos e séries temporais.
- Obter e organizar os dados históricos do IC-Br e de seus subgrupos.
- Realizar análise exploratória das séries, identificando tendências, sazonalidades e estruturas de dependência temporal.
- Ajustar modelos de suavização exponencial Holt-Linear e Holt-Winters.
- Avaliar o desempenho dos modelos por meio de métricas de erro.
- Comparar os resultados obtidos e discutir a aplicabilidade dos modelos na previsão de indicadores econômicos.

## Base de dados

Os dados utilizados correspondem ao Índice de Commodities Brasil (IC-Br) e aos seus três subgrupos:

| Série | Descrição |
|---|---|
| IC-Br Composto | Índice geral de commodities |
| Agropecuário | Subgrupo de commodities agropecuárias |
| Energético | Subgrupo de commodities energéticas |
| Metálico | Subgrupo de commodities metálicas |

**Fonte:** Banco Central do Brasil (BCB).

**Periodicidade:** mensal.

**Período de referência:** 1995 a 2026.

Os dados foram obtidos em bases públicas oficiais do Banco Central do Brasil.

Fonte de dados: [Banco Central do Brasil – Indicadores Econômicos Selecionados](https://www.bcb.gov.br/estatisticas/indicadoresselecionados).

## Metodologia

A pesquisa caracteriza-se como um estudo quantitativo de análise de séries temporais econômicas.

O desenvolvimento da análise foi organizado nas seguintes etapas:

### 1. Obtenção e organização dos dados

Coleta dos dados históricos do IC-Br e de seus subgrupos, seguida da organização das observações em séries temporais mensais.

### 2. Análise exploratória

Investigação das características temporais das séries por meio de:

- Inspeção gráfica das séries temporais;
- Decomposição dos componentes temporais;
- Função de autocorrelação (ACF);
- Função de autocorrelação parcial (PACF).

### 3. Modelagem estatística

Foram utilizados dois métodos de suavização exponencial:

**Holt-Linear**

Modelo indicado para séries temporais que apresentam tendência, considerando os componentes de nível e tendência.

**Holt-Winters**

Modelo de suavização exponencial que incorpora os componentes de nível, tendência e sazonalidade. Na implementação apresentada, utiliza-se a forma aditiva.

### 4. Previsão e avaliação dos modelos

O desempenho preditivo é investigado por meio da comparação entre valores observados e estimados, considerando a proposta de validação *out-of-sample* descrita na metodologia.

São utilizadas sete métricas de avaliação:

| Sigla | Métrica | Descrição |
|---|---|---|
| ME | Mean Error | Erro médio |
| RMSE | Root Mean Squared Error | Raiz do erro quadrático médio |
| MAE | Mean Absolute Error | Erro absoluto médio |
| MPE | Mean Percentage Error | Erro percentual médio |
| MAPE | Mean Absolute Percentage Error | Erro percentual absoluto médio |
| MASE | Mean Absolute Scaled Error | Erro absoluto médio escalonado |
| ACF1 | First-Order Autocorrelation | Autocorrelação de primeira ordem dos erros |

Essas métricas permitem avaliar a magnitude dos erros, o viés das previsões e a dependência temporal dos resíduos.

## Tecnologias e ferramentas

As análises foram desenvolvidas utilizando a linguagem R.

**Software:**
- R (versão 4.3, conforme metodologia do trabalho).
- RStudio.

**Principais pacotes utilizados:**

| Pacote | Aplicação |
|---|---|
| `forecast` | Modelagem, suavização exponencial, previsão e avaliação de acurácia |
| `TTR` | Ferramentas para análise de séries temporais |
| `scales` | Formatação de escalas e elementos gráficos |

## Organização do repositório

A estrutura sugerida para este repositório é:

```text
IC-Br-Series-Analysis/
│
├── README.md
│
├── data/
│   └── ICBR.csv
│
├── scripts/
│   ├── 01_analise_exploratoria.R
│   ├── 02_decomposicao_series.R
│   ├── 03_modelo_holt_linear.R
│   ├── 04_modelo_holt_winters.R
│   └── 05_avaliacao_modelos.R
│
├── results/
│   ├── figures/
│   └── tables/
│
├── docs/
│   └── TCC_Olavo_Francisquini.pdf
│
└── LICENSE
```

*Observação: a estrutura acima representa uma proposta de organização dos arquivos do projeto. Os nomes dos arquivos e scripts deverão ser ajustados conforme os materiais efetivamente disponibilizados no repositório.*

## Como executar o projeto

Para reproduzir as análises, é necessário ter o R instalado.

**1. Clone o repositório**

```bash
git clone URL_DO_REPOSITORIO
```

**2. Acesse o diretório do projeto**

```r
setwd("caminho/para/IC-Br-Series-Analysis")
```

**3. Instale os pacotes necessários**

```r
install.packages(c(
  "forecast",
  "TTR",
  "scales"
))
```

**4. Carregue os pacotes**

```r
library(forecast)
library(TTR)
library(scales)
```

**5. Disponibilize a base de dados**

Coloque o arquivo de dados na pasta `data/` e ajuste o caminho de leitura nos scripts, conforme o nome e a estrutura do arquivo utilizado.

**6. Execute os scripts**

Execute os arquivos da pasta `scripts/`, preferencialmente seguindo a ordem numérica indicada.

## Principais resultados

As análises identificaram tendências de crescimento nas séries estudadas, especialmente após 2020, além de componentes sazonais observados por meio da decomposição temporal.

Os modelos Holt-Linear e Holt-Winters apresentaram desempenho satisfatório na representação dos padrões temporais e na geração de previsões.

A comparação entre os modelos evidenciou diferenças nas métricas de acurácia, indicando que o desempenho relativo depende da série analisada e da medida estatística considerada.

Os resultados reforçam a aplicabilidade das técnicas de suavização exponencial na modelagem de séries econômicas relacionadas ao mercado de commodities.

## Referência bibliográfica

FRANCISQUINI, Olavo. **Dinâmica Temporal do IC-Br: Abordagem de Séries Temporais Aplicada aos Setores de Commodities**. 2026. Trabalho de Conclusão de Curso (Licenciatura em Matemática) – Universidade Tecnológica Federal do Paraná, Cornélio Procópio, 2026.

## Ciência Aberta e reprodutibilidade

Este repositório tem como finalidade promover a transparência metodológica, o compartilhamento dos códigos computacionais e a reprodutibilidade das análises desenvolvidas na pesquisa.

O compartilhamento dos materiais permite que outros pesquisadores e estudantes tenham acesso aos procedimentos empregados, possam reproduzir os resultados e desenvolvam novas investigações utilizando métodos estatísticos aplicados à análise de séries temporais econômicas.

---

**Universidade Tecnológica Federal do Paraná – UTFPR**  
Campus Cornélio Procópio | 2026
