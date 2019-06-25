#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu May 16 18:54:03 2019

@author: satyukt
"""
import random
import numpy as np
import matplotlib.pyplot as plt
import keras
from keras.models import Model, Sequential
from keras import optimizers
from keras.layers import Input, Dense, Activation, Dropout
from keras.optimizers import SGD
from sklearn.model_selection import train_test_split
from math import log, exp
random.seed(100)
import pandas as pd 
class Vector:
import tensorflow as tf

inputs = tf.keras.Input(shape=(1,))
x = tf.keras.layers.Dense(1, activation=tf.nn.relu)(inputs)
outputs = tf.keras.layers.Dense(1, activation=tf.nn.softmax)(x)
model = tf.keras.Model(inputs=inputs, outputs=outputs)

import tensorflow as tf

class MyModel(tf.keras.Model):

  def __init__(self):
    super(MyModel, self).__init__()
    self.dense1 = tf.keras.layers.Dense(4, activation=tf.nn.relu)
    self.dense2 = tf.keras.layers.Dense(5, activation=tf.nn.softmax)
    self.dropout = tf.keras.layers.Dropout(0.5)

  def call(self, inputs, training=False):
    x = self.dense1(inputs)
    if training:
      x = self.dropout(x, training=training)
    return self.dense2(x)

model = MyModel()

bn = keras.layers.BatchNormalization()
x1 = keras.layers.Input(shape=(10,))
_ = bn(x1)  # This creates 2 updates.

x2 = keras.layers.Input(shape=(10,))
y2 = bn(x2)  # This creates 2 more updates.

# The BN layer has now 4 updates.
self.assertEqual(len(bn.updates), 4)

# Let's create a model from x2 to y2.
model = keras.models.Model(x2, y2)

# The model does not list all updates from its underlying layers,
# but only the updates that are relevant to it. Updates created by layers
# outside of the model are discarded.
self.assertEqual(len(model.updates), 2)

# If you keep calling the model, you append to its updates, just like
# what happens for a layer.
x3 = keras.layers.Input(shape=(10,))
y3 = model(x3)
self.assertEqual(len(model.updates), 4)

# But if you call the inner BN layer independently, you don't affect
# the model's updates.
x4 = keras.layers.Input(shape=(10,))
_ = bn(x4)
self.assertEqual(len(model.updates), 4)
