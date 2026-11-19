#Instalando pacotes
install.packages("TTR")
install.packages("forecast")
install.packages("dplyr")
#Leitura de Pacotes
library(dplyr)
library(forecast)
library(TTR)
library(scales)
library(ggplot2)
#Pasta de Trabalho
setwd("C:\\Users\\vivia\\OneDrive\\Documentos\\Olavo\\Trabalhos Faculdade UTFPR\\Trabalho Conclusão de Curso - TCC\\Banco de Dados")

#Leitura dos Dados
dados <- read.csv2("ICBR 2.csv", header = TRUE)

#Conferência das Leituras dos Dados
str(dados)
head(dados)
names(dados)
        
#Trabalhando somente com coluna da variável Metal
#Transformando em Série Temporal
metal <- ts(dados$Metal..em.R..,
               start = c(1998, 1),  # ano e período inicial
               frequency = 12)



##grafico metal
plot(metal,
     main = "Série Temporal ICBR metal",
     ylab = "Valor em Reais (R$)",
     xlab = "Tempo (Mensal)",
     col = "blue")



#Decomposição Aditiva da Série
decomp <- decompose(metal)

plot(decomp)

acf(metal)

pacf(metal)

#Suavização Por Holt-Linear / acurácia da suavização Metal.
metal_hl <- holt(metal, h = 12)
metal_hl

a <- round(metal_hl$mean, 2)
b <- round(metal_hl$lower[, "95%"], 2)
c <- round(metal_hl$upper[, "95%"], 2)

cbind(Previsao = a, Inferior_95 = b, Superior_95 = c)

plot(metal_hl,
     main = "Suavização Holt-Linear Metal",
     
     xlab = "Tempo (Mensal)",
     
     ylab = "Valor em Reais (R$)")

acuracia_metal_hl <- accuracy(metal_hl)
accuracy(metal_hl)

#Suavização Por Holt-Winters / acurácia da suavização Metal.

metal_hw<- hw(metal, h = 12, seasonal = "additive")
metal_hw

a <- round(metal_hw$mean, 2)
b <- round(metal_hw$lower[, "95%"], 2)
c <- round(metal_hw$upper[, "95%"], 2)

cbind(Previsao = a, Inferior_95 = b, Superior_95 = c)

plot(metal_hw,
     
     main = "Suavização Holt-Winters Metal",
     
     xlab = "Tempo (Mensal)",
     
     ylab = "Valor em Reais (R$)"
     )

acuracia_metal_hw <- accuracy(metal_hw)
accuracy(metal_hw)

# Criando tabela comparativa Metal
tabela_acuracia_metal <- data.frame(
  Modelo = c("Holt-Linear", "Holt-Winters"),
  
  ME = c(acuracia_metal_hl[1,"ME"],
         acuracia_metal_hw[1,"ME"]),
  
  RMSE = c(acuracia_metal_hl[1,"RMSE"],
           acuracia_metal_hw[1,"RMSE"]),
  
  MAE = c(acuracia_metal_hl[1,"MAE"],
          acuracia_metal_hw[1,"MAE"]),
  
  MPE = c(acuracia_metal_hl[1,"MPE"],
          acuracia_metal_hw[1,"MPE"]),
  
  MAPE = c(acuracia_metal_hl[1,"MAPE"],
           acuracia_metal_hw[1,"MAPE"]),
  
  MASE = c(acuracia_metal_hl[1,"MASE"],
           acuracia_metal_hw[1,"MASE"]),
  
  ACF1 = c(acuracia_metal_hl[1,"ACF1"],
           acuracia_metal_hw[1,"ACF1"])
)
####################################################################
###Criando Gráfico de comparação entre Holt-Linear e Holt-Winters###
####################################################################

# Organizando os dados para o ggplot2

df_metal <- data.frame(
  data = as.numeric(time(metal)),
  metal_observado = as.numeric(metal),
  hlm_fitted = as.numeric(metal_hl$fitted),
  hwm_fitted = as.numeric(metal_hw$fitted)
)

#Verificando se os vetores de valores são iguais

length(metal_hl$fitted)
length(metal_hw$fitted)
length(metal)

#Criando gráfico

names(df_metal)
head(df_metal)
# Gráfico Comparativo com ggplot2

ggplot(df_metal, aes(x = data)) +
  
  # Dados originais
  geom_line(
    aes(y = metal_observado),
    color = "black",
    linewidth = 0.8
  ) +
  
  geom_point(
    aes(y = metal_observado),
    color = "black",
    size = 1,
    alpha = 0.5
  ) +
  
  # Alisamento de Holt-Linear
  geom_line(
    aes(y = hlm_fitted, color = "Holt (Linear)"),
    linewidth = 1
  ) +
  
  # Alisamento de Holt-Winters
  geom_line(
    aes(y = hwm_fitted, color = "Holt-Winters"),
    linewidth = 1
  ) +
  
  # Cores dos métodos
  scale_color_manual(
    values = c(
      "Holt (Linear)" = "red",
      "Holt-Winters" = "blue"
    )
  ) +
  
  # Títulos e legendas
  labs(
    title = "Alisamento Exponencial: IC-Br Metal",
    subtitle = "Comparação entre Holt-Linear e Holt-Winters",
    x = "Ano",
    y = "Valor em Reais (R$)",
    color = "Método:"
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "bottom"
  )
################################################################################
############## ZOOM na Comparação Metal #####################################
################################################################################

ggplot(df_metal, aes(x = data)) +
  
  # Série observada
  geom_line(
    aes(y = metal_observado),
    color = "black",
    linewidth = 0.8
  ) +
  
  geom_point(
    aes(y = metal_observado),
    color = "black",
    size = 1,
    alpha = 0.5
  ) +
  
  # Alisamento de Holt-Linear
  geom_line(
    aes(y = hlm_fitted, color = "Holt (Linear)"),
    linewidth = 1
  ) +
  
  # Alisamento de Holt-Winters
  geom_line(
    aes(y = hwm_fitted, color = "Holt-Winters"),
    linewidth = 1
  ) +
  
  # Cores dos métodos
  scale_color_manual(
    values = c(
      "Holt (Linear)" = "red",
      "Holt-Winters" = "blue"
    )
  ) +
  
  # Títulos e legendas
  labs(
    title = "Alisamento Exponencial: IC-Br Metal",
    subtitle = "Comparação entre Holt-Linear e Holt-Winters",
    x = "Ano",
    y = "Valor em Reais (R$)",
    color = "Método:"
  ) +
  
  # Seleção do intervalo exibido
  coord_cartesian(
    xlim = c(2019, 2025)
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "bottom"
  )



#Trabalhando somente com coluna da variável Agropecuária
#Transformando em Série Temporal
agropecuaria <- ts(dados$Agropecuária..em.R..,
            start = c(1998, 1),  # ano e período inicial
            frequency = 12)



##grafico Agropecuária
plot(agropecuaria,
     main = "Série Temporal ICBR Agropecuaria",
     ylab = "Valor em Reais (R$)",
     xlab = "Tempo (Mensal)",
     col = "brown")

#Decomposição Aditiva da Série
decomp <- decompose(agropecuaria)

plot(decomp)

acf(agropecuaria)

pacf(agropecuaria)

#Suavização Por Holt-Linear / acurácia da suavização Agropecuaria
agropecuaria_hl <- holt(agropecuaria, h = 12)
agropecuaria_hl

a <- round(agropecuaria_hl$mean, 2)
b <- round(agropecuaria_hl$lower[, "95%"], 2)
c <- round(agropecuaria_hl$upper[, "95%"], 2)

cbind(Previsao = a, Inferior_95 = b, Superior_95 = c)

plot(agropecuaria_hl,
     main = "Suavização Holt-Linear Agropecuaria",
     
     xlab = "Tempo (Mensal)",
     
     ylab = "Valor em Reais (R$)")

acuracia_agropecuaria_hl <- accuracy(agropecuaria_hl)

accuracy(agropecuaria_hl)


#Suavização Por Holt-Winters / acurácia da suavização Agropecuária

agropecuaria_hw <- hw(agropecuaria, h = 12, seasonal = "additive")
agropecuaria_hw



plot(agropecuaria_hw,
     main = "Suavização Holt-Winters Agropecuária",
     
     xlab = "Tempo (Mensal)",
     
     ylab = "Valor em Reais (R$)"
)

acuracia_agropecuaria_hw <- accuracy(agropecuaria_hw)
accuracy(agropecuaria_hw)


# Criando tabela comparativa Agropecuária
tabela_acuracia_agropecuaria <- data.frame(
  Modelo = c("Holt-Linear", "Holt-Winters"),
  
  ME = c(acuracia_agropecuaria_hl[1,"ME"],
         acuracia_agropecuaria_hw[1,"ME"]),
  
  RMSE = c(acuracia_agropecuaria_hl[1,"RMSE"],
           acuracia_agropecuaria_hw[1,"RMSE"]),
  
  MAE = c(acuracia_agropecuaria_hl[1,"MAE"],
          acuracia_agropecuaria_hw[1,"MAE"]),
  
  MPE = c(acuracia_agropecuaria_hl[1,"MPE"],
          acuracia_agropecuaria_hw[1,"MPE"]),
  
  MAPE = c(acuracia_agropecuaria_hl[1,"MAPE"],
           acuracia_agropecuaria_hw[1,"MAPE"]),
  
  MASE = c(acuracia_agropecuaria_hl[1,"MASE"],
           acuracia_agropecuaria_hw[1,"MASE"]),
  
  ACF1 = c(acuracia_agropecuaria_hl[1,"ACF1"],
           acuracia_agropecuaria_hw[1,"ACF1"])

)

####################################################################
###Criando Gráfico de comparação entre Holt-Linear e Holt-Winters###
####################################################################

# Organizando os dados para o ggplot2

df_agropecuaria <- data.frame(
  data = as.numeric(time(agropecuaria)),
  agropecuaria_observado = as.numeric(agropecuaria),
  hla_fitted = as.numeric(agropecuaria_hl$fitted),
  hwa_fitted = as.numeric(agropecuaria_hw$fitted)
)

#Verificando se os vetores de valores são iguais

length(agropecuaria_hl$fitted)
length(agropecuaria_hw$fitted)
length(agropecuaria)

#Criando gráfico

# Gráfico Comparativo com ggplot2

ggplot(df_agropecuaria, aes(x = data)) +
  
  # Dados originais
  geom_line(
    aes(y = agropecuaria_observado),
    color = "black",
    linewidth = 0.8
  ) +
  
  geom_point(
    aes(y = agropecuaria_observado),
    color = "black",
    size = 1,
    alpha = 0.5
  ) +
  
  # Alisamento de Holt-Linear
  geom_line(
    aes(y = hla_fitted, color = "Holt (Linear)"),
    linewidth = 1
  ) +
  
  # Alisamento de Holt-Winters
  geom_line(
    aes(y = hwa_fitted, color = "Holt-Winters"),
    linewidth = 1
  ) +
  
  # Cores dos métodos
  scale_color_manual(
    values = c(
      "Holt (Linear)" = "red",
      "Holt-Winters" = "blue"
    )
  ) +
  
  # Títulos e legendas
  labs(
    title = "Alisamento Exponencial: IC-Br Agropecuaria",
    subtitle = "Comparação entre Holt-Linear e Holt-Winters",
    x = "Ano",
    y = "Valor em Reais (R$)",
    color = "Método:"
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "bottom"
  )

################################################################################
############## ZOOM na Comparação Agropecuária #################################
################################################################################

ggplot(df_agropecuaria, aes(x = data)) +
  
  # Série observada
  geom_line(
    aes(y = agropecuaria_observado),
    color = "black",
    linewidth = 0.8
  ) +
  
  geom_point(
    aes(y = agropecuaria_observado),
    color = "black",
    size = 1,
    alpha = 0.5
  ) +
  
  # Alisamento de Holt-Linear
  geom_line(
    aes(y = hla_fitted, color = "Holt (Linear)"),
    linewidth = 1
  ) +
  
  # Alisamento de Holt-Winters
  geom_line(
    aes(y = hwa_fitted, color = "Holt-Winters"),
    linewidth = 1
  ) +
  
  # Cores dos métodos
  scale_color_manual(
    values = c(
      "Holt (Linear)" = "red",
      "Holt-Winters" = "blue"
    )
  ) +
  
  # Títulos e legendas
  labs(
    title = "Alisamento Exponencial: IC-Br Agropecuária",
    subtitle = "Comparação entre Holt-Linear e Holt-Winters",
    x = "Ano",
    y = "Valor em Reais (R$)",
    color = "Método:"
  ) +
  
  # Seleção do intervalo exibido
  coord_cartesian(
    xlim = c(2019, 2025)
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "bottom"
  )

#Trabalhando somente com coluna da variável Composto
#Transformando em Série Temporal
composto <- ts(dados$Composto..em.R..,
                   start = c(1998, 1),  # ano e período inicial
                   frequency = 12)



##grafico Composto
plot(composto,
     main = "Série Temporal ICBR Composto",
     ylab = "Valor em Reais (R$)",
     xlab = "Tempo (Mensal)",
     col = "black")

#Decomposição Aditiva da Série
decomp <- decompose(composto)

plot(decomp)

acf(composto)

pacf(composto)

#Suavização Por Holt-Linear / acurácia da suavização Composto.
composto_hl <- holt(composto, h = 12)
composto_hl

a <- round(composto_hl$mean, 2)
b <- round(composto_hl$lower[, "95%"], 2)
c <- round(composto_hl$upper[, "95%"], 2)

cbind(Previsao = a, Inferior_95 = b, Superior_95 = c)


plot(composto_hl,
     main = "Suavização Holt-Linear Composto",
     
     xlab = "Tempo (Mensal)",
     
     ylab = "Valor em Reais (R$)")

acuracia_composto_hl <- accuracy(composto_hl)
accuracy(composto_hl)

#Suavização Por Holt-Winters / acurácia da suavização Composto.

composto_hw<- hw(composto, h = 12, seasonal = "additive")
composto_hw

a <- round(composto_hw$mean, 2)
b <- round(composto_hw$lower[, "95%"], 2)
c <- round(composto_hw$upper[, "95%"], 2)

cbind(Previsao = a, Inferior_95 = b, Superior_95 = c)

plot(composto_hw,
     
     main = "Suavização Holt-Winters Composto",
     
     xlab = "Tempo (Mensal)",
     
     ylab = "Valor em Reais (R$)"
)

acuracia_composto_hw <- accuracy(composto_hw)
accuracy(composto_hw)


# Criando tabela comparativa Composto
tabela_acuracia_composto <- data.frame(
  Modelo = c("Holt-Linear", "Holt-Winters"),
  
  ME = c(acuracia_composto_hl[1,"ME"],
         acuracia_composoto_hw[1,"ME"]),
  
  RMSE = c(acuracia_composto_hl[1,"RMSE"],
           acuracia_composto_hw[1,"RMSE"]),
  
  MAE = c(acuracia_composto_hl[1,"MAE"],
          acuracia_composto_hw[1,"MAE"]),
  
  MPE = c(acuracia_composto_hl[1,"MPE"],
          acuracia_composto_hw[1,"MPE"]),
  
  MAPE = c(acuracia_composto_hl[1,"MAPE"],
           acuracia_composto_hw[1,"MAPE"]),
  
  MASE = c(acuracia_composto_hl[1,"MASE"],
           acuracia_composto_hw[1,"MASE"]),
  
  ACF1 = c(acuracia_composto_hl[1,"ACF1"],
           acuracia_composto_hw[1,"ACF1"])
)


####################################################################
###Criando Gráfico de comparação entre Holt-Linear e Holt-Winters###
####################################################################

# Organizando os dados para o ggplot2

df_composto <- data.frame(
  data = as.numeric(time(composto)),
  composto_observado = as.numeric(composto),
  hlc_fitted = as.numeric(composto_hl$fitted),
  hwc_fitted = as.numeric(composto_hw$fitted)
)

#Verificando se os vetores de valores são iguais

length(composto_hl$fitted)
length(composto_hw$fitted)
length(composto)

#Criando gráfico

# Gráfico Comparativo com ggplot2

ggplot(df_composto, aes(x = data)) +
  
  # Dados originais
  geom_line(
    aes(y = composto_observado),
    color = "black",
    linewidth = 0.8
  ) +
  
  geom_point(
    aes(y = composto_observado),
    color = "black",
    size = 1,
    alpha = 0.5
  ) +
  
  # Alisamento de Holt-Linear
  geom_line(
    aes(y = hlc_fitted, color = "Holt (Linear)"),
    linewidth = 1
  ) +
  
  # Alisamento de Holt-Winters
  geom_line(
    aes(y = hwc_fitted, color = "Holt-Winters"),
    linewidth = 1
  ) +
  
  # Cores dos métodos
  scale_color_manual(
    values = c(
      "Holt (Linear)" = "red",
      "Holt-Winters" = "blue"
    )
  ) +
  
  # Títulos e legendas
  labs(
    title = "Alisamento Exponencial: IC-Br Composto",
    subtitle = "Comparação entre Holt-Linear e Holt-Winters",
    x = "Ano",
    y = "Valor em Reais (R$)",
    color = "Método:"
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "bottom"
  )

################################################################################
############## ZOOM na Comparação Composto #####################################
################################################################################

ggplot(df_composto, aes(x = data)) +
  
  # Série observada
  geom_line(
    aes(y = composto_observado),
    color = "black",
    linewidth = 0.8
  ) +
  
  geom_point(
    aes(y = composto_observado),
    color = "black",
    size = 1,
    alpha = 0.5
  ) +
  
  # Alisamento de Holt-Linear
  geom_line(
    aes(y = hlc_fitted, color = "Holt (Linear)"),
    linewidth = 1
  ) +
  
  # Alisamento de Holt-Winters
  geom_line(
    aes(y = hwc_fitted, color = "Holt-Winters"),
    linewidth = 1
  ) +
  
  # Cores dos métodos
  scale_color_manual(
    values = c(
      "Holt (Linear)" = "red",
      "Holt-Winters" = "blue"
    )
  ) +
  
  # Títulos e legendas
  labs(
    title = "Alisamento Exponencial: IC-Br Composto",
    subtitle = "Comparação entre Holt-Linear e Holt-Winters",
    x = "Ano",
    y = "Valor em Reais (R$)",
    color = "Método:"
  ) +
  
  # Seleção do intervalo exibido
  coord_cartesian(
    xlim = c(2019, 2025)
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "bottom"
  )


#Trabalhando somente com coluna da variável Energia
#Transformando em Série Temporal
energia <- ts(dados$Energia..em.R..,
               start = c(1998, 1),  # ano e período inicial
               frequency = 12)



##grafico Energia
plot(energia,
     main = "Série Temporal ICBR Energia",
     ylab = "Valor em Reais (R$)",
     xlab = "Tempo (Mensal)",
     col = "darkgreen")

#Decomposição Aditiva da Série
decomp <- decompose(energia)

plot(decomp)

acf(energia)

pacf(energia)

#Suavização Por Holt-Linear / acurácia da suavização Energia.
energia_hl <- holt(energia, h = 12)
energia_hl

a <- round(energia_hl$mean, 2)
b <- round(energia_hl$lower[, "95%"], 2)
c <- round(energia_hl$upper[, "95%"], 2)

cbind(Previsao = a, Inferior_95 = b, Superior_95 = c)


plot(energia_hl,
     main = "Suavização Holt-Linear Energia",
     
     xlab = "Tempo (Mensal)",
     
     ylab = "Valor em Reais (R$)")

acuracia_energia_hl <- accuracy(energia_hl)
accuracy(energia_hl)

#Suavização Por Holt-Winters / acurácia da suavização Energia.

energia_hw<- hw(energia, h = 12, seasonal = "additive")
energia_hw

a <- round(energia_hw$mean, 2)
b <- round(energia_hw$lower[, "95%"], 2)
c <- round(energia_hw$upper[, "95%"], 2)

cbind(Previsao = a, Inferior_95 = b, Superior_95 = c)


plot(energia_hw,
     main = "Suavização Holt-Winters Energia",
     
     xlab = "Tempo (Mensal)",
     
     ylab = "Valor em Reais (R$)"
)

acuracia_energia_hw <- accuracy(energia_hw)
accuracy(energia_hw)

# Criando tabela comparativa Energia
tabela_acuracia_energia <- data.frame(
  Modelo = c("Holt-Linear", "Holt-Winters"),
  
  ME = c(acuracia_energia_hl[1,"ME"],
         acuracia_energia_hw[1,"ME"]),
  
  RMSE = c(acuracia_energia_hl[1,"RMSE"],
           acuracia_energia_hw[1,"RMSE"]),
  
  MAE = c(acuracia_energia_hl[1,"MAE"],
          acuracia_energia_hw[1,"MAE"]),
  
  MPE = c(acuracia_energia_hl[1,"MPE"],
          acuracia_energia_hw[1,"MPE"]),
  
  MAPE = c(acuracia_energia_hl[1,"MAPE"],
           acuracia_energia_hw[1,"MAPE"]),
  
  MASE = c(acuracia_energia_hl[1,"MASE"],
           acuracia_energia_hw[1,"MASE"]),
  
  ACF1 = c(acuracia_energia_hl[1,"ACF1"],
           acuracia_energia_hw[1,"ACF1"])
)


####################################################################
###Criando Gráfico de comparação entre Holt-Linear e Holt-Winters###
####################################################################

# Organizando os dados para o ggplot2

df_energia <- data.frame(
  data = as.numeric(time(energia)),
  energia_observado = as.numeric(energia),
  hle_fitted = as.numeric(energia_hl$fitted),
  hwe_fitted = as.numeric(energia_hw$fitted)
)


#Verificando se os vetores de valores são iguais

length(energia_hl$fitted)
length(energia_hw$fitted)
length(energia)

#Criando gráfico

# Gráfico Comparativo com ggplot2

ggplot(df_energia, aes(x = data)) +
  
  # Dados originais
  geom_line(
    aes(y = energia_observado),
    color = "black",
    linewidth = 0.8
  ) +
  
  geom_point(
    aes(y = energia_observado),
    color = "black",
    size = 1,
    alpha = 0.5
  ) +
  
  # Alisamento de Holt-Linear
  geom_line(
    aes(y = hle_fitted, color = "Holt (Linear)"),
    linewidth = 1
  ) +
  
  # Alisamento de Holt-Winters
  geom_line(
    aes(y = hwe_fitted, color = "Holt-Winters"),
    linewidth = 1
  ) +
  
  # Cores dos métodos
  scale_color_manual(
    values = c(
      "Holt (Linear)" = "red",
      "Holt-Winters" = "blue"
    )
  ) +
  
  # Títulos e legendas
  labs(
    title = "Alisamento Exponencial: IC-Br Energia",
    subtitle = "Comparação entre Holt-Linear e Holt-Winters",
    x = "Ano",
    y = "Valor em Reais (R$)",
    color = "Método:"
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "bottom"
  )

################################################################################
############## ZOOM na Comparação Energia ######################################
################################################################################

ggplot(df_energia, aes(x = data)) +
  
  # Série observada
  geom_line(
    aes(y = energia_observado),
    color = "black",
    linewidth = 0.8
  ) +
  
  geom_point(
    aes(y = energia_observado),
    color = "black",
    size = 1,
    alpha = 0.5
  ) +
  
  # Alisamento de Holt-Linear
  geom_line(
    aes(y = hle_fitted, color = "Holt (Linear)"),
    linewidth = 1
  ) +
  
  # Alisamento de Holt-Winters
  geom_line(
    aes(y = hwe_fitted, color = "Holt-Winters"),
    linewidth = 1
  ) +
  
  # Cores dos métodos
  scale_color_manual(
    values = c(
      "Holt (Linear)" = "red",
      "Holt-Winters" = "blue"
    )
  ) +
  
  # Títulos e legendas
  labs(
    title = "Alisamento Exponencial: IC-Br Energia",
    subtitle = "Comparação entre Holt-Linear e Holt-Winters",
    x = "Ano",
    y = "Valor em Reais (R$)",
    color = "Método:"
  ) +
  
  # Seleção do intervalo exibido
  coord_cartesian(
    xlim = c(2019, 2025)
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "bottom"
  )



