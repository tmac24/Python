# -*- coding: utf-8 -*-
"""
=========================================================
Linear Regression Example
=========================================================
The example below uses only the first feature of the `diabetes` dataset,
in order to illustrate the data points within the two-dimensional plot.
The straight line can be seen in the plot, showing how linear regression
attempts to draw a straight line that will best minimize the
residual sum of squares between the observed responses in the dataset,
and the responses predicted by the linear approximation.

The coefficients, residual sum of squares and the coefficient of
determination are also calculated.

"""

# Code source: Jaques Grobler
# License: BSD 3 clause

import matplotlib.pyplot as plt
import numpy as np
from sklearn import datasets, linear_model
from sklearn.metrics import mean_squared_error, r2_score

# Load the diabetes dataset 加载糖尿病数据集
diabetes_X, diabetes_y = datasets.load_diabetes(return_X_y=True)

# Use only one feature 仅使用一个功能
diabetes_X = diabetes_X[:, np.newaxis, 2]

# Split the data into training/testing sets 将数据拆分为训练/测试集
diabetes_X_train = diabetes_X[:-20] # 除了后20个数据的前面所有数据
diabetes_X_test = diabetes_X[-20:] # 后20个数据

# Split the targets into training/testing sets 将目标划分为训练/测试集
diabetes_y_train = diabetes_y[:-20]
diabetes_y_test = diabetes_y[-20:]

# Create linear regression object 创建线性回归对象
regr = linear_model.LinearRegression()

# Train the model using the training sets 使用训练集训练模型
regr.fit(diabetes_X_train, diabetes_y_train)

# Make predictions using the testing set 使用测试集进行预测
diabetes_y_pred = regr.predict(diabetes_X_test)

# The coefficients 系数
print("Coefficients: \n", regr.coef_)
# The mean squared error 均方误差
print("Mean squared error: %.2f" % mean_squared_error(diabetes_y_test, diabetes_y_pred))
# The coefficient of determination: 1 is perfect prediction 决定系数：1是完美的预测
print("Coefficient of determination: %.2f" % r2_score(diabetes_y_test, diabetes_y_pred))

# Plot outputs 绘图输出
plt.scatter(diabetes_X_test, diabetes_y_test, color="black")
plt.plot(diabetes_X_test, diabetes_y_pred, 'r',label = 'Prediction')
plt.xlabel('Economy..GDP')
plt.ylabel('Happiness.Score')
# plt.xticks(()) #标记
# plt.yticks(())
plt.legend() #刻度值
plt.show()
