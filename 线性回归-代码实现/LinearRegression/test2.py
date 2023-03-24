# 使用sklearn工具进行线性回归预测
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score

file_data = pd.read_csv('../data/world-happiness-report-2017.csv')

input_param_name = 'Economy..GDP.per.Capita.'
output_param_name = 'Happiness.Score'

# 得到训练和测试数据
data = file_data.sample(frac = 0.8) #随机抽取比例
drop_data = file_data.drop(file_data.index) #drop([])，默认情况下删除某一行；

happynes_X = data[[input_param_name]].values
happynes_y = data[[output_param_name]].values

# Split the data into training/testing sets 将数据拆分为训练/测试集
happynes_X_train = happynes_X[:-20] # 除了后20个数据的前面所有数据
happynes_X_test = happynes_X[-20:] # 后20个数据

# Split the targets into training/testing sets 将目标划分为训练/测试集
happynes_y_train = happynes_y[:-20]
happynes_y_test = happynes_y[-20:]

# Create linear regression object 创建线性回归对象
regr = linear_model.LinearRegression()

# Train the model using the training sets 使用训练集训练模型
regr.fit(happynes_X_train, happynes_y_train)

# Make predictions using the testing set 使用测试集进行预测
happynes_y_pred = regr.predict(happynes_X_test)

# The coefficients 系数
print("Coefficients: \n", regr.coef_)
# The mean squared error 均方误差
print("Mean squared error: %.2f" % mean_squared_error(happynes_y_test, happynes_y_pred))
# The coefficient of determination: 1 is perfect prediction 决定系数：1是完美的预测
print("Coefficient of determination: %.2f" % r2_score(happynes_y_test, happynes_y_pred))

# Plot outputs 绘图输出
plt.scatter(happynes_X_test, happynes_y_test, color="black")
plt.plot(happynes_X_test, happynes_y_pred, 'r',label = 'Prediction')
plt.xlabel('Economy..GDP')
plt.ylabel('Happiness.Score')
plt.legend() #刻度值
plt.show()