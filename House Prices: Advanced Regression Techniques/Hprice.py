import pandas as pd
import sklearn
from sklearn.ensemble import RandomForestRegressor

data = pd.read_csv("train.csv")
train_y = data.SalePrice
train_id = data.Id
train_x = data.drop(['Id', 'SalePrice'], axis = 1)
without_miss_x = train_x.dropna(axis = 1)
missing = (without_miss_x.isnull().sum())
print(missing[missing>0])