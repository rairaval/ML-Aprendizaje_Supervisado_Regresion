# UN  ANALISIS DE DATASET Y CAUSALIDADES.
# CON UN DATASET PROPIO DE R

#Descripción de las VARIABLES en Saratoga Houses DATA SET

#price price (US dollars): Precio de la vivienda en dolares.
#lotSize size of lot (acres): Tamaño del lote.
#age age of house (years): Antiguedad de la vivienda.
#landValue value of land (US dollars): Valor del terreno.
#livingArea living are (square feet): Espacios de vivienda.
#pctCollege percent of neighborhood that graduated college: Porcentaje de vecinos que se han graduado en la universidad.
#bedrooms number of bedrooms: Numero de dormitorios.
#firplaces number of fireplaces: Numero de matafuegos.
#bathrooms number of bathrooms (half bathrooms have no shower or tub); Numero de Baños.
#rooms number of rooms: Numero de dormitorios.
#heating type of heating system: Tipo de Calefacción.
#fuel fuel used for heating: Medio de comustion de la calefaccion.
#sewer type of sewer system: Sistema de alcantarillado.
#waterfront whether property includes waterfront: Si tiene vista al mar.
#newConstruction whether the property is a new construction: Si se trata de una vivienda de nueva contruccion.
#centralAir whether the house has central air: Si tiene Aire central. 

#install.packages("mosaicData")
data(SaratogaHouses, package="mosaicData")

#The Saratoga housing dataset contains information on 1,728 houses in Saratoga Country, NY, USA in 2006. 
#Variables include price (in thousands of US dollars) and 15 property characteristics (lotsize, living area, age, number of bathrooms, etc.)

#The dataset can be accessed using

data(SaratogaHouses, package="mosaicData")
View(SaratogaHouses)

#is.data.frame(SaratogaHouses)
#TRUE

#UNICAMENTE SELECCIONO LAS VARIABLES NUMERICAS.

df <- dplyr::select_if(SaratogaHouses, is.numeric)

# calulate the correlations

r <- cor(df, use="complete.obs")
round(r,2) #La funcion me redondea a dos cifras significativas.

#Para Visualizar las correlaciones utilizo la funcion: ggcorrplot en el paquete del mismo nombre. 
#install.packages("ggcorrplot")

library(ggplot2)
library(ggcorrplot)
ggcorrplot(r)
#Mayor cantidad de baños y de areas para vivir, mayor seria el precio. 

ggcorrplot(r, 
           hc.order = TRUE, 
           type = "lower",
           lab = TRUE)

#REGRESION LINEAL: EXPLORACION DE LAS CAUSALIDADES

houses_lm <- lm(price ~ lotSize + age + landValue +
                  livingArea + bedrooms + bathrooms +
                  waterfront, data = SaratogaHouses)

houses_lm


#install.packages("visreg")
library(visreg)
visreg(houses_lm, "livingArea", gg = TRUE) 
#Si mantenemos constantes el resto de variables el precio de la vivienda aumenta con las 'livingArea'


#GRAFICO: ANALISIS DE DIFERENCIAS entre una variable CONTINUA y otra DICOTOMICA

visreg(houses_lm, "waterfront", gg = TRUE) +
      scale_y_continuous(label = scales::dollar) +
  labs(title = "Relationship between price and location",
       subtitle = "controlling for lot size, age, land value, bedrooms and bathrooms",
       caption = "source: Saratoga Housing Data (2006)",
       y = "Home Price",
       x = "Waterfront")
# Hay muchas menos viviendas frente al mar y tienden a ser mas caras que el resto de las viviendas.
# Aun habiendo controlado por el resto de las variables: Tamaño, años de la viviendo, valor del terreno, baños y dormitorios.

#Si quisieramos analizar el precio por comprar vivienda nueva:

houses_lm2 <- lm(price ~ lotSize + age + landValue +
                  livingArea + bedrooms + bathrooms +
                  waterfront + newConstruction, data = SaratogaHouses)

visreg(houses_lm2, "newConstruction", gg = TRUE) +
  scale_y_continuous(label = scales::dollar) +
  labs(title = "Relationship between price and newConstruction",
       subtitle = "controlling for lot size, age, land value, bedrooms and bathrooms",
       caption = "source: Saratoga Housing Data (2006)",
       y = "Home Price",
       x = "newConstruction")

# Las nuevas construcciones dan en promedio un menor nivel de precio respecto a las que no lo son. 
# Pero este valor es muy sensible a datos atípicos, de los cuales se pueden observar en el grafico. 
# Habria que ver con la variable landvalue, si es que se esta contuyendo residencias nuevas en zonas periferica.

#Nuevo Modelo.
houses_lm3 <- lm(landValue ~ lotSize + age + price +
                   livingArea + bedrooms + bathrooms +
                   waterfront + newConstruction, data = SaratogaHouses)

visreg(houses_lm3, "newConstruction", gg = TRUE) +
    scale_y_continuous(label = scales::dollar) +
  labs(title = "Relationship between landvalue and newcontruction",
       subtitle = "controlling for lot size, age, price, bedrooms and bathrooms",
       caption = "source: Saratoga Housing Data (2006)",
       y = "land value",
       x = "newConstruction")

# Los precios de los terrenos de las nuevas contrucciones son en promedio mayores a los precios de las que NO son nuevas contrucciones. 
# Se esta contruyendo en donde el valor del terreno es mayor. 

#RAUL vILA



