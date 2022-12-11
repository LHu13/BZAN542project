#useful packages
library(tidyverse)
library(lubridate)


##read in zipped file as data frame
#remember to change path name to where file is located
raw_csgo = read.csv(gzfile("C:/Users/Jackson DeBord/Documents/Fall_22/Data_Mining/BZAN542project/raw_csgo_data.gzip"))

#parsing date
raw_csgo$date = parse_date_time(raw_csgo$date, "Ymd HMS")

