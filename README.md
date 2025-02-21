# Analytics

## Project Description

This project aims to analyze data related to fast food menus to gain insights into nutritional values and other relevant information. Machine learning models have been applied to predict various features of fast food products.

### Repository Contents

- **FastFoodNutritionMenuV2.csv**: A dataset containing information about fast food menu items, including nutritional values, ingredients, and other product characteristics.
  
- **fastfood_df.R**: An R script that processes and cleans the dataset. This script removes null values, encodes categorical variables, and performs other preparatory steps necessary for data analysis.

- **naive_bayes_model.rds**: A naive Bayes model trained on the prepared dataset. This model can be used for classification and predicting features of products based on nutritional information.

- **random_forest_model.rds**: A random forest model trained on the prepared dataset. It allows for more complex analysis and classification compared to the naive Bayes model by utilizing multiple decision trees.

### How to Use

1. **Download the dataset**: Copy the `FastFoodNutritionMenuV2.csv` file to your local folder.
2. **Run the R script**: Open the `fastfood_df.R` file in RStudio or another R editor to preprocess the data.
3. **Utilize the models**: Load the `naive_bayes_model.rds` and `random_forest_model.rds` models to make predictions based on new data.

### Requirements

To run the scripts and models, you need to have R installed, along with the following packages:
- `dplyr`
- `ggplot2`
- `caret`
- `randomForest`
- `e1071`
