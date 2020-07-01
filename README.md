# opendatauzb 0.1.1

Downloading available datasets from an official open data source of Uzbekistan

## RELEASE NOTES:
- Version 0.1.1 offers several new functions to download Uzbek Stock Market data along with a vignette documentation
- First release 0.1.0 provides a set of functions to access datasets on the Official Open Data Portal of Uzbekistan (data.gov.uz)

The package is provided under the GPL-3 license.

In the latest version (0.1.1), several new functions have been added to collect Uzbek Stock Market data.

**getTicker()**: obtains stock market prices over the given period 

**getMarketIndex()**: provides stock market indices across sectors

**currentBidsAsks()**: returns current bid and ask prices on the Republican Stock Exchange "Toshkent"

<br>

**ipo()**: returns a data frame with public offerings in last five years

**getSecurities()**: returns a data frame with the list of securities from the Republican Stock Exchange "Toshkent" database (www.uzse.uz)

**RegisteredSecurities()**: returns a data frame with the list of securities from the Central Securities Depository (www.deponet.uz) database

<br><br>

The package has also three key functions:

**availableDatasets()** - returns a data frame with the list of available datasets on https://data.gov.uz with corresponding **dataset_id**

**getData(dataset_id)** - downloads a dataset with **dataset_id**

**getData_dictionary(dataset_id)** - downloads a data dictionary (variables) for the dataset


<br><br>
If you have any suggestions to be included in further releases or find any bugs, please feel free to raise a trouble ticket on: https://github.com/alishersuyunov/opendatauzb/issues
