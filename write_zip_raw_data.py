##importing pandas and numpy to read raw data
import numpy as np
import pandas as pd

##read in raw data, skip first index column
raw_data = pd.read_csv("C:/Users/Jackson DeBord/Documents/archive/mm_master_demos.csv",
usecols = range(1,33), parse_dates = [2])

##compress data as gzip
raw_data.to_csv("C:/Users/Jackson DeBord/Documents/Fall_22/Data_Mining/BZAN542project/raw_csgo_data.gzip",
                    index = False,
                    compression = 'gzip')

