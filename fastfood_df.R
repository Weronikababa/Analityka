# Instalacja brakujących pakietów
needed_packages <- c("tidyverse","reshape2", "ggplot2", "caret", "randomForest", "readr", "corrplot", "nnet", "e1071", "xgboost")
new_packages <- needed_packages[!(needed_packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) install.packages(new_packages)

# Załadowanie bibliotek
library(tidyverse)
library(caret)
library(randomForest)
library(readr)
library(corrplot)
library(nnet)
library(e1071)
library(ggplot2)
library(reshape2)

# Wczytanie danych
fastfood_df <- read_csv("/Users/weronikababa/Downloads/FastFoodNutritionMenuV2.csv")

# Czyszczenie nazw kolumn
colnames(fastfood_df) <- make.names(colnames(fastfood_df), unique = TRUE)

# Usunięcie duplikatów w kolumnie Item
fastfood_df <- fastfood_df[!duplicated(fastfood_df$Item), ]

# Uzupełnienie brakujących wartości
for (col in names(fastfood_df)) {
  if (is.numeric(fastfood_df[[col]])) {
    fastfood_df[[col]][is.na(fastfood_df[[col]])] <- median(fastfood_df[[col]], na.rm = TRUE)
  } else if (is.factor(fastfood_df[[col]]) || is.character(fastfood_df[[col]])) {
    most_common <- names(sort(table(fastfood_df[[col]]), decreasing = TRUE))[1]
    fastfood_df[[col]][is.na(fastfood_df[[col]])] <- most_common
  }
}

# Usunięcie wierszy z brakującymi wartościami
fastfood_df <- na.omit(fastfood_df)

# Ustawienie kolumny Company jako faktor
fastfood_df$Company <- as.factor(fastfood_df$Company)

# Podział na zbiory treningowy i testowy
set.seed(123)
n <- nrow(fastfood_df)
train_indices <- sample(seq_len(n), size = 0.7 * n)
train_data <- fastfood_df[train_indices, ]
test_data <- fastfood_df[-train_indices, ]

# Trenowanie modelu Random Forest
rf_model <- randomForest(Company ~ ., data = train_data, ntree = 400, importance = TRUE)

# Predykcja i ocena modelu
predictions <- predict(rf_model, test_data)
conf_matrix <- confusionMatrix(predictions, test_data$Company)

# Wyświetlenie macierzy pomyłek
print(conf_matrix)

# Obliczanie wskaźnika błędów
accuracy <- conf_matrix$overall['Accuracy']  # Pobranie wartości dokładności
error_rate <- 1 - accuracy                    # Obliczenie wskaźnika błędów

# Wyświetlenie wskaźnika błędów
cat("Wskaźnik błędów modelu: ", error_rate, "\n") # Wskaźnik błędów modelu wynoszący 0.28 oznacza, że model błędnie klasyfikuje około 28%

# Model Naive Bayes
nb_model <- naiveBayes(Company ~ ., data = train_data)
nb_predictions <- predict(nb_model, test_data)
conf_matrix_nb <- confusionMatrix(nb_predictions, test_data$Company)
accuracy_nb <- conf_matrix_nb$overall['Accuracy']
error_rate_nb <- 1 - accuracy_nb

cat("Wskaźnik błędów modelu Naive Bayes: ", error_rate_nb, "\n")

# Załadowanie dodatkowego pakietu

library(ggplot2)
library(reshape2)

# Funkcja do tworzenia wykresu macierzy pomyłek
plot_confusion_matrix <- function(conf_matrix, model_name) {
  conf_matrix_melted <- melt(conf_matrix$table)
  colnames(conf_matrix_melted) <- c("Actual", "Predicted", "Count")
  
  ggplot(data = conf_matrix_melted, aes(x = Actual, y = Predicted, fill = Count)) +
    geom_tile(color = "white") +
    scale_fill_gradient(low = "white", high = "blue") +
    geom_text(aes(label = Count), color = "black") +
    labs(title = paste("Macierz pomyłek dla modelu", model_name),
         x = "Klasa rzeczywista",
         y = "Klasa przewidywana") +
    theme_minimal()
}
# Rysowanie wykresów dla macierzy pomyłek
plot_confusion_matrix(conf_matrix_nb, "Naive Bayes")
plot_confusion_matrix(conf_matrix, "Random Forest")

# Model Random Forest myli się o około 16.46% rzadziej niż model Naive Bayes, co oznacza, że jest znacznie bardziej dokładny w przewidywaniach.
# Oba modele najlepiej radzą sobie z rozpoznaniem restauracji Pizza Hut po menu, a najczęściej się mylą przy Burger Kingu

# Zapis modelu do pliku

# Zapisanie modelu Random Forest do pliku
saveRDS(rf_model, file = "random_forest_model.rds")

# Zapisanie modelu Naive Bayes do pliku
saveRDS(nb_model, file = "naive_bayes_model.rds")


