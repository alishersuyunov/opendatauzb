# opendatauzb 0.1.0
Downloading available datasets from an official open data source of Uzbekistan

Import data from an official open data source of Uzbekistan: https://data.gov.uz

The R package provides several functions to find and download datasets (and related information) right from the R interface. 
The package is provided under the GPL-3 license.

The package has three key functions:

**availableDatasets()** - the data frame with the list of of available datasets on https://data.gov.uz and corresponding **dataset_id**

**getData(dataset_id)** - Downloads available dataset with dataset_id

**getData_dictionary(dataset_id)** - Downloads a dataset dictionary (variables) for the datasets

<br><br>
If you have any suggestions to be included in further releases or notice any bugs in the package, please feel free to raise trouble tickets on: https://github.com/alishersuyunov/opendatauzb/issues
