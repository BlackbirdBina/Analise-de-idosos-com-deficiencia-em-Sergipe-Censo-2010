setwd ("C:\\Users\\sabri\\OneDrive\\Documentos\\Bina\\UFRN\\Mestrado\\Disciplinas\\M�todos Quantitativos 1\\Aulas\\Trabalho final")

#Pacotes necess�rios
library(pacman)
p_load(tidyverse,data.table,readr,readxl,vroom, tableone, gtsummary, ggplot2)

#Importando dados em estudo
layoutdados <- read_excel("Layout_microdados_Amostra.xls", sheet = "PESS",
                          range = cell_limits(c(2, 1), c(NA, 12)))

#Exclus�o de colunas desnecess�rias
layoutdados <- layoutdados[ ,-c(2, 3, 4, 5, 6, 7, 11, 12)]

#Convertendo os dados importados em um novo formato (data frame) para armazenar tabelas
#Em seguida � utilizado o "rownames" para alterar o nome das linhas utilizando os c�digos das
#vari�veis para serem os �ndices/nomes dessas linhas
#Isso foi feito para que as linhas n�o tivessem refer�ncia num�rica.
layoutdados <- as.data.frame(layoutdados)
rownames(layoutdados) <- layoutdados[ , 1]
layoutdados <- layoutdados[ ,-c(1)]

#Colocando nome nas colunas e identificando quais vari�veis ser�o utilizadas para este algoritmo
colnames(layoutdados) <- c("Inicio", "Final", "INT")
layoutdados
#De acordo com a planilha do IBGE do c�digo V0614 at� o c�digo V0617 se refere �s dificuldades/defici�ncia
varalvo <- c("V0601", "V6036", "V6531", "V1006", "V0606", "V6400", "V0637", 
             "V0502", "V5030", "V0657", "V0614", "V0615", "V0616", "V0617")
              
layoutdados <- layoutdados[varalvo, ]
view(layoutdados)

#Lendo e guardando o arquivo .txt na vari�vel serg2010
serg2010 <- vroom_fwf(file = 'Amostra_Pessoas_28.txt', fwf_positions(layoutdados$Inicio,
                                                                    layoutdados$Final,
                                                        col_names = rownames(layoutdados)))

#------x------x------x------Alterando os valores de cada vari�vel------x------x------x------# 
serg2010$V0601[serg2010$V0601 == 1] <- "Masculino"
serg2010$V0601[serg2010$V0601 == 2] <- "Feminino"

serg2010 <- transform(serg2010,V6036 = as.numeric(V6036))
serg2010 <- transform(serg2010,V6531 = as.numeric(V6531))

serg2010$V6531 <- serg2010$V6531/100

serg2010$V1006[serg2010$V1006 == 1] <- "Urbana"
serg2010$V1006[serg2010$V1006 == 2] <- "Rural"

serg2010$V0606[serg2010$V0606 == 1] <- "Branca"
serg2010$V0606[serg2010$V0606 == 2] <- "Preta"
serg2010$V0606[serg2010$V0606 == 3] <- "Amarela"
serg2010$V0606[serg2010$V0606 == 4] <- "Parda"
serg2010$V0606[serg2010$V0606 == 5] <- "Ind�gena"
serg2010$V0606[serg2010$V0606 == 9] <- "Ignorado"

serg2010$V6400[serg2010$V6400 == 1] <- "Sem instru��o e fundamental incompleto"
serg2010$V6400[serg2010$V6400 == 2] <- "Fundamental completo e m�dio incompleto"
serg2010$V6400[serg2010$V6400 == 3] <- "M�dio completo e superior incompleto"
serg2010$V6400[serg2010$V6400 == 4] <- "Superior completo"
serg2010$V6400[serg2010$V6400 == 5] <- "N�o determinado"

serg2010$V0637[serg2010$V0637 == 1] <- "Sim"
serg2010$V0637[serg2010$V0637 == 2] <- "N�o, mas viveu"
serg2010$V0637[serg2010$V0637 == 3] <- "N�o, nunca viveu"

serg2010$V0502[serg2010$V0502 == "01"] <- "Pessoa respons�vel pelo domic�lio"
serg2010$V0502[serg2010$V0502 == "02"] <- "C�njuge ou companheiro(a) de sexo diferente"
serg2010$V0502[serg2010$V0502 == "03"] <- "C�njuge ou companheiro(a) do mesmo sexo"
serg2010$V0502[serg2010$V0502 == "04"] <- "Filho(a) do respons�vel e do c�njuge"
serg2010$V0502[serg2010$V0502 == "05"] <- "Filho(a) somente do respons�vel"
serg2010$V0502[serg2010$V0502 == "06"] <- "Enteado(a)"
serg2010$V0502[serg2010$V0502 == "07"] <- "Genro ou nora"
serg2010$V0502[serg2010$V0502 == "08"] <- "Pai, m�e, padrasto ou madrasta"
serg2010$V0502[serg2010$V0502 == "09"] <- "Sogro(a)"
serg2010$V0502[serg2010$V0502 == 10] <- "Neto(a)"
serg2010$V0502[serg2010$V0502 == 11] <- "Bisneto(a)"
serg2010$V0502[serg2010$V0502 == 12] <- "Irm�o ou irm�"
serg2010$V0502[serg2010$V0502 == 13] <- "Av� ou av�"
serg2010$V0502[serg2010$V0502 == 14] <- "Outro parente"
serg2010$V0502[serg2010$V0502 == 15] <- "Agregado(a)"
serg2010$V0502[serg2010$V0502 == 16] <- "Convivente"
serg2010$V0502[serg2010$V0502 == 17] <- "Pensionista"
serg2010$V0502[serg2010$V0502 == 18] <- "Empregado(a) dom�stico(a)"
serg2010$V0502[serg2010$V0502 == 19] <- "Parente do(a) empregado(a)  dom�stico(a)"
serg2010$V0502[serg2010$V0502 == 20] <- "Individual em domic�lio coletivo"

serg2010$V5030[serg2010$V5030 == 1] <- "Unipessoal"
serg2010$V5030[serg2010$V5030 == 2] <- "Duas pessoas ou mais sem parentesco"
serg2010$V5030[serg2010$V5030 == 3] <- "Duas pessoas ou mais com parentesco"

serg2010$V0657[serg2010$V0657 == 1] <- "Sim"
serg2010$V0657[serg2010$V0657 == 0] <- "N�o"
serg2010$V0657[serg2010$V0657 == 9] <- "Ignorado"

#Vari�veis de pessoas com defici�ncia/dificuldade
serg2010$V0614[serg2010$V0614 == 1] <- "Sim, n�o consegue de modo algum"
serg2010$V0614[serg2010$V0614 == 2] <- "Sim, grande dificuldade"
serg2010$V0614[serg2010$V0614 == 3] <- "Sim, alguma dificuldade"
serg2010$V0614[serg2010$V0614 == 4] <- "N�o, nenhuma dificuldade"
serg2010$V0614[serg2010$V0614 == 9] <- "Ignorado"

serg2010$V0615[serg2010$V0615 == 1] <- "Sim, n�o consegue de modo algum"
serg2010$V0615[serg2010$V0615 == 2] <- "Sim, grande dificuldade"
serg2010$V0615[serg2010$V0615 == 3] <- "Sim, alguma dificuldade"
serg2010$V0615[serg2010$V0615 == 4] <- "N�o, nenhuma dificuldade"
serg2010$V0615[serg2010$V0615 == 9] <- "Ignorado"

serg2010$V0616[serg2010$V0616 == 1] <- "Sim, n�o consegue de modo algum"
serg2010$V0616[serg2010$V0616 == 2] <- "Sim, grande dificuldade"
serg2010$V0616[serg2010$V0616 == 3] <- "Sim, alguma dificuldade"
serg2010$V0616[serg2010$V0616 == 4] <- "N�o, nenhuma dificuldade"
serg2010$V0616[serg2010$V0616 == 9] <- "Ignorado"

serg2010$V0617[serg2010$V0617 == 1] <- "Sim"
serg2010$V0617[serg2010$V0617 == 2] <- "N�o"
serg2010$V0617[serg2010$V0617 == 9] <- "Ignorado"

#Criando a vari�vel de "pelo menos uma das dificuldades anteriores"
serg2010["Pelo menos uma das dificuldades anteriores"] <- with(serg2010,
                                                               ifelse(V0614 == "N�o, nenhuma dificuldade" & 
                                                                      V0615 == "N�o, nenhuma dificuldade" &
                                                                      V0616 == "N�o, nenhuma dificuldade" &
                                                                      V0617 == "N�o", "N�o", "Sim"))
#------x------x------x------x------Fim da altera��o dos valores------x------x------x------x------#



#Alterando o nome das colunas, substituindo os c�digos por suas respectivas descri��es/categorias
colnames(serg2010) <- c("Sexo",
                        "Idade",
                        "Renda domiciliar per capta",
                        "Situa��o do Domic�lio",
                        "Ra�a/Cor",
                        "N�vel de Instru��o",
                        "Vive com c�njuge ou companheiro(a)",
                        "Rela��o de parentesco com a pessoa respons�vel pelo domic�lio",
                        "Tipo de unidade dom�stica",
                        "Recebe benef�cio programa social",
                        "Dificuldade visual",
                        "Dificuldade auditiva",
                        "Dificuldade motora",
                        "Dificuldade mental ou intelectual",
                        "Pelo menos uma das dificuldades anteriores")

#Criando vari�veis categ�ricas para Idade (grupo et�rio) e Renda (categoria de renda)
serg2010["Grupo etario"] <- serg2010["Idade"]
serg2010["Grupo etario"][serg2010["Idade"] >= 0 & serg2010["Idade"] < 5 ] <- "0 a 4 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 4 & serg2010["Idade"] < 10 ] <- "5 a 9 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 9 & serg2010["Idade"] < 15 ] <- "10 a 14 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 14 & serg2010["Idade"] < 20 ] <- "15 a 19 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 19 & serg2010["Idade"] < 25 ] <- "20 a 24 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 24 & serg2010["Idade"] < 30 ] <- "25 a 29 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 29 & serg2010["Idade"] < 35 ] <- "30 a 34 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 34 & serg2010["Idade"] < 40 ] <- "35 a 39 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 39 & serg2010["Idade"] < 45 ] <- "40 a 44 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 44 & serg2010["Idade"] < 50 ] <- "45 a 49 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 49 & serg2010["Idade"] < 55 ] <- "50 a 55 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 54 & serg2010["Idade"] < 60 ] <- "55 a 59 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 59 & serg2010["Idade"] < 65 ] <- "60 a 64 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 64 & serg2010["Idade"] < 70 ] <- "65 a 69 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 69 & serg2010["Idade"] < 75 ] <- "70 a 74 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 74 & serg2010["Idade"] < 80 ] <- "75 a 79 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 79 & serg2010["Idade"] < 85 ] <- "80 a 84 anos"
serg2010["Grupo etario"][serg2010["Idade"] > 84 & serg2010["Idade"] < 90 ] <- "85 a 89 anos"
serg2010["Grupo etario"][serg2010["Idade"] >= 90 ] <- "90 anos ou mais"
serg2010["Categoria de renda"] <- serg2010["Renda domiciliar per capta"]
serg2010["Categoria de renda"][serg2010["Renda domiciliar per capta"] <= 205 ] <- "At� meio sal�rio m�nimo"
serg2010["Categoria de renda"][serg2010["Renda domiciliar per capta"] > 205 & serg2010["Renda domiciliar per capta"] <= 510] <- "Entre meio e 1 sal�rio m�nimo"
serg2010["Categoria de renda"][serg2010["Renda domiciliar per capta"] > 510 & serg2010["Renda domiciliar per capta"] <= 715] <- "Entre 1 e 1,5 sal�rios m�nimos"
serg2010["Categoria de renda"][serg2010["Renda domiciliar per capta"] > 715 & serg2010["Renda domiciliar per capta"] <= 1020] <- "Entre 1,5 e 2 sal�rios m�nimos"
serg2010["Categoria de renda"][serg2010["Renda domiciliar per capta"] > 1020 ] <- "mais de 2 sal�rios m�nimos"


#Reordenando as colunas para incluir o "Grupo et�rio" ap�s a coluna de "Idade" e "Categoria de renda" ap�s
#a coluna "Renda domiciliar per capta"
serg2010 <- serg2010[c("Sexo",
                       "Idade",
                       "Grupo etario",
                       "Renda domiciliar per capta",
                       "Categoria de renda",
                       "Situa��o do Domic�lio",
                       "Ra�a/Cor",
                       "N�vel de Instru��o",
                       "Vive com c�njuge ou companheiro(a)",
                       "Rela��o de parentesco com a pessoa respons�vel pelo domic�lio",
                       "Tipo de unidade dom�stica",
                       "Recebe benef�cio programa social",
                       "Dificuldade visual",
                       "Dificuldade auditiva",
                       "Dificuldade motora",
                       "Dificuldade mental ou intelectual",
                       "Pelo menos uma das dificuldades anteriores")]

#Criando as vari�veis para agrupar os idosos e, em seguida, para agrupar os idosos com alguma dificuldade/defici�ncia
idososerg2010 <- serg2010[serg2010["Idade"] >= 60, ]
idosodific <- idososerg2010[idososerg2010["Pelo menos uma das dificuldades anteriores"] == "Sim", ]
view(idosodific)

#------x------x------x------Criando as tabelas com as an�lises descritivas das vari�veis------x------x------x------#
theme_gtsummary_language(language = "pt", big.mark = ".",decimal.mark =",")

#Vis�o estat�stica geral
tbl_summary(serg2010,
            digits = list(everything() ~ c(0,1)),
            type = all_continuous() ~ "continuous2",
            statistic = list(all_continuous() ~ c("{mean} ({sd})",
                                                  "{median} ({p25} - {p75})",
                                                  "{min} - {max}"),
                             all_categorical() ~ "{n} / {N} ({p}%)"))

#Vis�o estat�stica de idosos
tbl_summary(idososerg2010,
            digits = list(everything() ~ c(0,1)),
            type = all_continuous() ~ "continuous2",
            statistic = list(all_continuous() ~ c("{mean} ({sd})",
                                                  "{median} ({p25} - {p75})",
                                                  "{min} - {max}"),
                             all_categorical() ~ "{n} / {N} ({p}%)"))

#Vis�o estat�stica organizada por presen�a ou n�o de alguma dificuldade/defici�ncia
tbl_summary(idososerg2010, by = "Pelo menos uma das dificuldades anteriores",
            digits = list(everything() ~ c(0,1)), percent = "row",
            type = all_continuous() ~ "continuous2",
            statistic = list(all_continuous() ~ c("{mean} ({sd})",
                                                  "{median} ({p25} - {p75})",
                                                  "{min} - {max}"),
                             all_categorical() ~ "{n} / {N} ({p}%)")) %>% add_p()


#------x------x------x------x------Testes qui-quadrado de Pearson------x------x------x------x------#

#Teste qui-quadrado para vari�veis categ�ricas
#Considerando que as duas vari�veis comparadas possuem uma distribui��o estat�stica id�ntica (H0)
#� verificado a seguir se rejeita ou n�o essa hip�tese, por meio do teste qui-quadrado:
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$Sexo)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`Grupo etario`)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`Categoria de renda`)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`Situa��o do Domic�lio`)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`Ra�a/Cor`)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`N�vel de Instru��o`)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`Vive com c�njuge ou companheiro(a)`)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`Rela��o de parentesco com a pessoa respons�vel pelo domic�lio`)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`Tipo de unidade dom�stica`)
chisq.test(x = idososerg2010$`Pelo menos uma das dificuldades anteriores`,
           y = idososerg2010$`Recebe benef�cio programa social`)


#------x------x------x------x------x------Gr�ficos------x------x------x------x------x------#
#------Gr�ficos comparando com vari�vel "Pelo menos uma das dificuldades anteriores"------#


#Gr�fico Boxplot relacionando homens e mulheres idosos, por idade, com e sem dificuldade/defici�ncia
ggplot(idososerg2010, aes(x = `Pelo menos uma das dificuldades anteriores`, y = Idade, fill=`Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos sem e com dificuldade/defici�ncia", y = "Idade dos Idosos") + 
  geom_boxplot(show.legend = F) + facet_wrap(.~as.factor(Sexo)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico Boxplot sem filtro, mostrando outliers e as diferen�as entre as vari�veis para idosos com e sem defici�ncia
ggplot(idososerg2010, aes(x = `Pelo menos uma das dificuldades anteriores`, y = `Renda domiciliar per capta`, fill=`Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos sem e com dificuldade/defici�ncia", y = "Renda per capta") + 
  geom_boxplot(show.legend = F) + facet_wrap(.~as.factor(Sexo)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico Box plot com filtro, mostrando principalmente se h� ou n�o diferen�as entre as vari�veis para idosos com e sem defici�ncia
idososerg2010 %>% filter(`Renda domiciliar per capta` < 1000) %>% ggplot(aes(x = `Pelo menos uma das dificuldades anteriores`, y = `Renda domiciliar per capta`, fill=`Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos sem e com dificuldade/defici�ncia", y = "Renda per capta abaixo de mil reais") + 
  geom_boxplot(show.legend = F) + facet_wrap(.~as.factor(Sexo)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico de barras relacionando homens e mulheres idosos com e sem dificuldade/defici�ncia
ggplot(idososerg2010, aes(x = `Pelo menos uma das dificuldades anteriores`, fill = `Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos com e sem dificuldade/defici�ncia", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(Sexo)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico de barras relacionando situa��o do domic�lio com idosos que t�m ou n�o algum tipo de dificuldade/defici�ncia
ggplot(idososerg2010, aes(x = `Pelo menos uma das dificuldades anteriores`, fill = `Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos com e sem dificuldade/defici�ncia", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Situa��o do Domic�lio`)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico apresentando a porcentagem da rela��o acima
freq <- idososerg2010 %>%
  group_by(`Situa��o do Domic�lio`, `Pelo menos uma das dificuldades anteriores`) %>%
  summarise(n = n()) %>% 
  mutate(freq = n / sum(n) * 100) %>% 
  ungroup()

ggplot(freq, aes(x = `Pelo menos uma das dificuldades anteriores`, y = freq, fill = `Pelo menos uma das dificuldades anteriores`, label = round(freq, 1))) +
  geom_col(position = 'dodge', show.legend = F) +
  facet_wrap(~`Situa��o do Domic�lio`) + 
  geom_text(position = position_nudge(x = 0, y = 2)) +
  theme_classic() + scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico de barras relacionando Ra�a/cor com idosos que t�m ou n�o alguma dificuldade/defici�ncia
ggplot(idososerg2010, aes(x = `Pelo menos uma das dificuldades anteriores`, fill = `Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos com e sem dificuldade/defici�ncia", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Ra�a/Cor`)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico apresentando a porcentagem da rela��o acima
freq <- idososerg2010 %>%
  group_by(`Ra�a/Cor`, `Pelo menos uma das dificuldades anteriores`) %>%
  summarise(n = n()) %>% 
  mutate(freq = n / sum(n) * 100) %>% 
  ungroup()

ggplot(freq, aes(x = `Pelo menos uma das dificuldades anteriores`, y = freq, fill = `Pelo menos uma das dificuldades anteriores`, label = round(freq, 1))) +
  geom_col(position = 'dodge', show.legend = F) +
  facet_wrap(~`Ra�a/Cor`) + 
  geom_text(size = 2, position = position_nudge(x = 0, y = 2)) +
  theme_classic() + scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico de barras relacionando N�vel de instru��o com idosos que t�m ou n�o alguma dificuldade/defici�ncia
idososerg2010 %>% filter(`N�vel de Instru��o` != "N�o determinado") %>% ggplot(aes(x = `Pelo menos uma das dificuldades anteriores`, fill = `Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos com e sem dificuldade/defici�ncia", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`N�vel de Instru��o`)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico apresentando a porcentagem da rela��o acima
freq <- idososerg2010 %>% filter(`N�vel de Instru��o` != "N�o determinado") %>%
  group_by(`N�vel de Instru��o`, `Pelo menos uma das dificuldades anteriores`) %>%
  summarise(n = n()) %>% 
  mutate(freq = n / sum(n) * 100) %>% 
  ungroup()

ggplot(freq, aes(x = `Pelo menos uma das dificuldades anteriores`, y = freq, fill = `Pelo menos uma das dificuldades anteriores`, label = round(freq, 1))) +
  geom_col(position ='dodge',show.legend = F) +
  facet_wrap(~`N�vel de Instru��o`) + 
  geom_text(size = 2, position = position_nudge(x = 0, y = 2)) +
  theme_classic() + scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico de barras relacionando a vari�vel Vive com c�njuge ou companheiro(a) com idosos que t�m ou n�o alguma dificuldade/defici�ncia 
ggplot(idososerg2010, aes(x=`Pelo menos uma das dificuldades anteriores`, fill = `Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos com e sem dificuldade/defici�ncia", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Vive com c�njuge ou companheiro(a)`)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico para vari�vel "Rela��o de parentesco" (IGNORADO POR N�O SER MUITO SIGNIFICATIVO)
#ggplot(idososerg2010, aes(x=`Pelo menos uma das dificuldades anteriores`, fill = `Pelo menos uma das dificuldades anteriores`)) +
#  labs(x="Idosos com e sem dificuldade/defici�ncia", y = "Quantidade de Idosos") + 
#  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Rela��o de parentesco com a pessoa respons�vel pelo domic�lio`)) + 
#  scale_fill_manual(values=c("#84D959","#D9574A"))

#Gr�fico de barras relacionando o Tipo de unidade dom�stica com idosos que t�m ou n�o alguma dificuldade/defici�ncia
idososerg2010 %>% filter(!is.na(`Tipo de unidade dom�stica`)) %>% ggplot(aes(x = `Pelo menos uma das dificuldades anteriores`, fill = `Pelo menos uma das dificuldades anteriores`)) +
  labs(x = "Idosos com e sem dificuldade/defici�ncia", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Tipo de unidade dom�stica`)) + 
  scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico apresentando a porcentagem da rela��o acima
freq <- idososerg2010 %>% filter(!is.na(`Tipo de unidade dom�stica`)) %>%
  group_by(`Tipo de unidade dom�stica`, `Pelo menos uma das dificuldades anteriores`) %>%
  summarise(n = n()) %>% 
  mutate(freq = n / sum(n) * 100) %>% 
  ungroup()

ggplot(freq, aes(x = `Pelo menos uma das dificuldades anteriores`, y = freq, fill = `Pelo menos uma das dificuldades anteriores`, label = round(freq, 1))) +
  geom_col(position ='dodge',show.legend = F) +
  facet_wrap(~`Tipo de unidade dom�stica`) + 
  geom_text(size = 2, position = position_nudge(x = 0, y = 2)) +
  theme_classic() + scale_fill_manual(values = c("#84D959","#D9574A"))

#Gr�fico para vari�vel "Se recebe benef�cio" (IGNORADO POR N�O SER MUITO SIGNIFICATIVO) 
#------Fim da compara��o com vari�vel "Pelo menos uma das dificuldades anteriores"------#


#------Gr�ficos comparando com vari�veis de dificuldade/defici�ncia espec�ficas------#

#Gr�fico de barras relacionando idosos categorizados por feminino e masculino com e sem dificuldade visual
idososerg2010 %>% filter(`Dificuldade visual` != "Ignorado") %>% ggplot(aes(x = `Dificuldade visual`, fill = `Dificuldade visual`)) +
  labs(x = "Idosos com e sem dificuldade/defici�ncia visual", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Sexo`)) + 
  scale_fill_manual(values = c("#84D959","#F59D37", "#D9574A", "#8C0404")) +
  scale_x_discrete(guide = guide_axis(angle = -90))

#Gr�fico apresentando a porcentagem da rela��o acima
freq <- idososerg2010 %>% filter(`Dificuldade visual` != "Ignorado") %>%
  group_by(Sexo, `Dificuldade visual`) %>%
  summarise(n = n()) %>% 
  mutate(freq = n / sum(n) * 100) %>% 
  ungroup()

ggplot(freq, aes(x = `Dificuldade visual`, y = freq, fill = `Dificuldade visual`, label = round(freq, 1))) +
  geom_col(position ='dodge',show.legend = F) +
  facet_wrap(~Sexo) + 
  geom_text(size = 2, position = position_nudge(x = 0, y = 2)) +
  theme_classic() + scale_fill_manual(values = c("#84D959","#F59D37", "#D9574A", "#8C0404")) +
  scale_x_discrete(guide = guide_axis(angle = -90))

#Gr�fico de barras relacionando idosos categorizados por feminino e masculino com e sem dificuldade auditiva
idososerg2010 %>% filter(`Dificuldade auditiva` != "Ignorado") %>% ggplot(aes(x = `Dificuldade auditiva`, fill = `Dificuldade auditiva`)) +
  labs(x = "Idosos com e sem dificuldade/defici�ncia auditiva", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Sexo`)) + 
  scale_fill_manual(values = c("#84D959","#F59D37", "#D9574A", "#8C0404")) +
  scale_x_discrete(guide = guide_axis(angle = -90))

#Gr�fico apresentando a porcentagem da rela��o acima
freq <- idososerg2010 %>% filter(`Dificuldade auditiva` != "Ignorado") %>%
  group_by(Sexo, `Dificuldade auditiva`) %>%
  summarise(n = n()) %>% 
  mutate(freq = n / sum(n) * 100) %>% 
  ungroup()

ggplot(freq, aes(x = `Dificuldade auditiva`, y = freq, fill = `Dificuldade auditiva`, label = round(freq, 1))) +
  geom_col(position ='dodge',show.legend = F) +
  facet_wrap(~Sexo) + 
  geom_text(size = 2, position = position_nudge(x = 0, y = 2)) +
  theme_classic() + scale_fill_manual(values = c("#84D959","#F59D37", "#D9574A", "#8C0404")) +
  scale_x_discrete(guide = guide_axis(angle = -90))

#Gr�fico de barras relacionando idosos categorizados por feminino e masculino com e sem dificuldade motora
idososerg2010 %>% filter(`Dificuldade motora` != "Ignorado") %>% ggplot(aes(x = `Dificuldade motora`, fill = `Dificuldade motora`)) +
  labs(x = "Idosos sem e com dificuldade/defici�ncia Motora", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Sexo`)) + 
  scale_fill_manual(values = c("#84D959","#F59D37", "#D9574A", "#8C0404")) +
  scale_x_discrete(guide = guide_axis(angle = -90))

#Gr�fico apresentando a porcentagem da rela��o acima
freq <- idososerg2010 %>% filter(`Dificuldade motora` != "Ignorado") %>%
  group_by(Sexo, `Dificuldade motora`) %>%
  summarise(n = n()) %>% 
  mutate(freq = n / sum(n) * 100) %>% 
  ungroup()

ggplot(freq, aes(x = `Dificuldade motora`, y = freq, fill = `Dificuldade motora`, label = round(freq, 1))) +
  geom_col(position ='dodge',show.legend = F) +
  facet_wrap(~Sexo) + 
  geom_text(size = 2, position = position_nudge(x = 0, y = 2)) +
  theme_classic() + scale_fill_manual(values = c("#84D959","#F59D37", "#D9574A", "#8C0404")) +
  scale_x_discrete(guide = guide_axis(angle = -90))

#Gr�fico de barras relacionando idosos categorizados por feminino e masculino com e sem dificuldade mental ou intelectual
idososerg2010 %>% filter(`Dificuldade mental ou intelectual` != "Ignorado") %>% ggplot(aes(x = `Dificuldade mental ou intelectual`, fill = `Dificuldade mental ou intelectual`)) +
  labs(x = "Idosos sem e com dificuldade/defici�ncia mental/intelectual", y = "Quantidade de Idosos") + 
  geom_bar(show.legend = F) + facet_wrap(.~as.factor(`Sexo`)) + 
  scale_fill_manual(values = c("#84D959","#D9574A")) +
  scale_x_discrete(guide = guide_axis(angle = -90))

#Gr�fico apresentando a porcentagem da rela��o acima
freq <- idososerg2010 %>% filter(`Dificuldade mental ou intelectual` != "Ignorado") %>%
  group_by(Sexo, `Dificuldade mental ou intelectual`) %>%
  summarise(n = n()) %>% 
  mutate(freq = n / sum(n) * 100) %>% 
  ungroup()

ggplot(freq, aes(x = `Dificuldade mental ou intelectual`, y = freq, fill = `Dificuldade mental ou intelectual`, label = round(freq, 1))) +
  geom_col(position ='dodge',show.legend = F) +
  facet_wrap(~Sexo) + 
  geom_text(size = 3, position = position_nudge(x = 0, y = 2)) +
  theme_classic() + scale_fill_manual(values = c("#84D959","#D9574A")) +
  scale_x_discrete(guide = guide_axis(angle = -90))
#------x------x------x------Fim da compara��o com vari�veis espec�ficas------x------x------x------#

#------x------x------x------x------Fim do algoritmo \o/------x------x------x------x------#