import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from itertools import islice
from collections import Counter
import math, csv, codecs
import sklearn.metrics

##### change here directory where data for testing is stored ####
cleanData = 
################################################################  
# Function to a look at each in turn
def benfolds(dataframe):
    for column in dataframe:
        if dataframe[column].dtypes=='float32':
            data = conflictExposure[column].loc[lambda x : x>0]
            data = [int(first_n_nonzero_digits(d, 1)) for d in data]
            benfolds = most_sig_digits_histogram(np.array(data))
            if sklearn.metrics.mean_squared_error(expected_benfold, benfolds)>0.015:
                plt.plot(np.arange(1, 10, step=1),benfolds, label=column)
                plt.plot(np.arange(1, 10, step=1),expected_benfold, label="Expected")
                plt.legend()
def first_n_nonzero_digits(l, n):
    return ''.join(islice((i for i in str(l) if i not in {'0', '.'}), n))
def most_sig_digits_from_numbers(numbers):
    '''
    >>> most_sig_digits_from_numbers([1,20,300,4000])
    [1, 2, 3, 4]
    '''
    msdigits = (n / int(math.pow(10, len(str(n))-1 ) ) for n in numbers)
    return list(msdigits)
def most_sig_digits_histogram(numbers):
    '''
    >>> most_sig_digits_histogram([1,20,300,4000])
    [0.25, 0.25, 0.25, 0.25, 0.0, 0.0, 0.0, 0.0, 0.0]
    '''
    msdcounts = Counter(most_sig_digits_from_numbers(numbers))
    return [float(msdcounts[d]) / len(numbers) for d in range(1,10)]
def plot_benfold(column, exp=0):
    if exp==1:
        data = np.exp(conflictExposure[column].loc[lambda x : x>0])
    else:
        data = conflictExposure[column].loc[lambda x : x>0]
    data = [int(first_n_nonzero_digits(d, 1)) for d in data]
    msdcounts = Counter(most_sig_digits_from_numbers(data))
    benfolds = [float(msdcounts[d]) / len(data) for d in range(1,10)]
    fig, ax = plt.subplots()
    plt.plot(np.arange(1, 10, step=1),benfolds, label=column)
    plt.plot(np.arange(1, 10, step=1),expected_benfold, label="expected")
    plt.xlabel('First digit')
    plt.ylabel('Frequency')
    plt.legend()
    plt.legend(loc="upper right")
    plt.savefig(column+'.pdf')
    
# This code creates figure 1
expected_benfold = np.array([30.1, 17.6, 12.5, 9.7, 7.9, 6.7, 5.8, 5.1, 4.6])/100
conflictExposure = pd.read_stata(cleanData + 'conflictexposure.dta')
plot_benfold('lnlights_001', 1)
plot_benfold('Land_250_1757', 0)
plot_benfold('lnpdgpd1990', 1)
plot_benfold('latitude_gadm', 0)

# Function to check MSE for all columns of dataset against critical value
def benfolds(dataframe):
    for column in dataframe:
        #print(column)
        if dataframe[column].dtypes=='float32':
            data = conflictExposure[column].loc[lambda x : x>0]
            data = [int(first_n_nonzero_digits(d, 1)) for d in data]
            benfolds = most_sig_digits_histogram(np.array(data))
            if sklearn.metrics.mean_squared_error(expected_benfold, benfolds)>0.015:
                print(column)
#data to test
conflictExposure = pd.read_stata(cleanData + 'conflictexposure.dta')
conflictExposure_native = pd.read_stata(cleanData + 'conflictexposure_native.dta')
leetaxdata = pd.read_stata(cleanData + 'leetaxdata.dta')
mukherjeedata = pd.read_stata(cleanData + 'mukherjeedata.dta')
vdsadataclean = pd.read_stata(cleanData + 'vdsadataclean.dta')
exposure_bi = pd.read_stata(cleanData + 'exposure_bi.dta')
literacy1881 = pd.read_stata(cleanData + 'literacy1881.dta')
literacy1921 = pd.read_stata(cleanData + 'literacy1921.dta')
exposure_bi_literacy = pd.read_stata(cleanData + 'exposure_bi_literacy.dta')
devcensuswgis = pd.read_stata(cleanData + 'devcensuswgis.dta')
bi_educ_exposure = pd.read_stata(cleanData + 'bi_educ_exposure.dta')
bi_infmort_exposure = pd.read_stata(cleanData + 'bi_infmort_exposure.dta')
james1 = pd.read_stata(cleanData + 'james1.dta')
jamesco1 = pd.read_stata(cleanData + 'jamesco1.dta')
tehsildata = pd.read_stata(cleanData + 'tehsildata.dta')
cells = pd.read_stata(cleanData + 'cells.dta')
districtgdp = pd.read_stata(cleanData + 'districtgdp.dta')
bgdpak= pd.read_stata(cleanData + 'bgdpak.dta')
biclean= pd.read_stata(cleanData + 'biclean.dta')

# Take a look at each in turn - will only return output if anything is wrong with the data
benfolds(conflictExposure)
benfolds(conflictExposure_native)
benfolds(leetaxdata)
benfolds(mukherjeedata)
benfolds(vdsadataclean)
benfolds(exposure_bi)
benfolds(literacy1881)
benfolds(literacy1921)
benfolds(exposure_bi_literacy)
benfolds(devcensuswgis)
benfolds(bi_educ_exposure)
benfolds(bi_infmort_exposure)
benfolds(james1)
benfolds(jamesco1)
benfolds(tehsildata)
benfolds(cells)
benfolds(districtgdp)
benfolds(bgdpak)
benfolds(biclean)