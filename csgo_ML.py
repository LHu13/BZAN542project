#%%

#Loads in all the necessary packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sklearn.model_selection
import tensorflow as tf
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import StratifiedKFold
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline

#change to whereever your csv is stored.
dataframe = pd.DataFrame(pd.read_csv("C:\Users\liana\OneDrive\Desktop\all_game_state_data_train.csv"))


#%%
#Sometimes bomb_sites are not planted therefore it is now bomb site a, b, or none.
dataframe['bomb_site'] = dataframe['bomb_site'].fillna('none')
print(dataframe.isnull().sum())

#%%
#Drops all the nas.
dataframe.dropna(inplace=True)

#%%
#Subset the dataframe to the 'input' columns/variables.
dataframe_subset = dataframe[['seconds', 'is_bomb_planted', 'bomb_site', 'CT1_health', 'CT2_health', 'CT3_health',
                              'CT4_health', 'CT5_health', 'T1_health', 'T2_health', 'T3_health', 'T4_health', 'T5_health', 'map',
                              'round_type', 'ct_eq_val', 't_eq_val', 'T1_dead', 'T2_dead', 'T3_dead', 'T4_dead', 'T5_dead',
                              'CT1_dead', 'CT2_dead', 'CT3_dead', 'CT4_dead', 'CT5_dead', 'T_dead', 'CT_dead']]

#Change the the bomb_site, map, and round_type variables as integers.
dataframe_subset[['bomb_site', 'map', 'round_type']] = dataframe_subset[['bomb_site', 'map', 'round_type']].apply(LabelEncoder().fit_transform)
csgo_data = dataframe_subset.values
#%%

#Set the input and output variables
X = np.float32(csgo_data) #needs to be float32 format
Y = dataframe[['T_win']].values #win condition 
encoder = LabelEncoder()
encoder.fit(Y)
Y = encoder.transform(Y)
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.25) #splits the data into training and testing data subsets
# X = csgo_data[:,[5, 10, 11, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 30, 31, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44]]
# print(X['seconds'])

#%%
# First layer has to match number of inputs
model = tf.keras.models.Sequential([
    tf.keras.layers.Normalization(axis=None), #normalize the data and convert to z-score
    tf.keras.layers.Dense(29, input_shape=(29,), activation='relu'), #29 nodes for input
    tf.keras.layers.Dense(87, activation='tanh'), #calculates for interactions between variables
    tf.keras.layers.Dense(1, activation='sigmoid') #outputs 1 as probability of Terrorists winning
])

model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy']) 
print(Y)
#%%
model.fit(X_train, Y_train, batch_size=128, epochs=50) #fits the model, number of samples, and number of times to train

#%%
#See how the model performs on test data
model.evaluate(X_test, Y_test, verbose=2)
#%%
y_pred = model.predict(X_test)
#%%

#Save model to avoid re-training to get to the current point
model.save('first_training_50_epoch')
#%%

matrix = sklearn.metrics.confusion_matrix(Y_test, np.rint(y_pred).astype(int)) #Creates confusion matrix
#%%
print(matrix/len(y_pred)) #Calculates confusion matrix as proportion
#%%
