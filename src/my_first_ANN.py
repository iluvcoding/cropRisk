#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue May 28 12:58:34 2019

@author: rishu
"""
import csv
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.pipeline import Pipeline
from sklearn.model_selection import KFold
from sklearn.preprocessing import MinMaxScaler
from tensorflow.python.keras.layers import Dense
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split
from tensorflow.python.keras.models import Sequential
from tensorflow.python.keras.wrappers.scikit_learn import KerasRegressor


rice_csv = pd.read_csv("/home/rishu/Projects/1056/cropRisk/data_2/Rice and Wheat_rainfall/Rice/02_Kharif_season.csv")

x = np.array(rice_csv.RAIN.fillna(0)).reshape(len(rice_csv.RAIN),1)
y = np.array(rice_csv.Yield.fillna(0)).reshape(len(rice_csv.RAIN),1)

scaler_x = MinMaxScaler()
scaler_y = MinMaxScaler()
scaler_x.fit(x)
scaler_y.fit(y)
xscaled = scaler_x.transform(x)
yscaled = scaler_y.transform(y)
x_train, x_test, y_train, y_test = train_test_split(xscaled, yscaled)
model = Sequential()
model.add(Dense(1, input_dim=1, kernel_initializer='normal', activation='relu'))
model.add(Dense(8, activation='relu'))
model.add(Dense(1, activation='linear'))
model.summary()
model.compile(loss='mse', optimizer='adam', metrics=['mse','mae'])
history = model.fit(x_train, y_train, epochs=120, batch_size=50,  verbose=1, validation_split=0.2)
print(history.history.keys())
plt.plot(x_train, y_train)
plt.plot(x_)
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'validation'], loc='upper left')
plt.show()
x_new = x_test
y_new = model.predict(x_test)

