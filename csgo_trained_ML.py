#Loads in packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sklearn.model_selection
import tensorflow as tf
from tensorflow import keras
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import StratifiedKFold
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline


## LOADING IN TRAINED MODEL ##
print('Loading trained model')
#Change location to whereever you have your model stored.
trained_model = keras.models.load_model("C:\\Users\\liana\\BZAN542project\\CSGO_ML_first_training_50_epochs")
print('Trained model loaded')


## TESTING ON SAMPLE ##
#Example of a sample round to read in 
sample_round = [[50, 2, 2, 59, 49, 29,
                56, 45, 40, 67, 75, 56, 89, 3,
                2, 30000, 1000, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0]]

#Creates sample prediction
sample_prediction=trained_model.predict(sample_round)
print(sample_prediction)