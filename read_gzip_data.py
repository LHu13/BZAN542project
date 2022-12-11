##import pandas/numpy
import numpy as np
import pandas as pd

##decompress and read data
#change pathname to match data location
csgo_raw = pd.read_csv("C:/Users/Jackson DeBord/Documents/Fall_22/Data_Mining/BZAN542project/raw_csgo_data.gzip",
                        compression = 'gzip',
                        parse_dates = [2])