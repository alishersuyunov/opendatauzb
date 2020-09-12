# opendatauzb 0.1.2

[![Travis build status](https://travis-ci.com/alishersuyunov/opendatauzb.svg?branch=master)](https://travis-ci.com/alishersuyunov/opendatauzb)

Downloading available datasets and Uzbek Stock Market data from an official open data sources of Uzbekistan 

## RELEASE NOTES:
- Version 0.1.2 improves performance, optimises dependencies; output data frames are sorted by design
- Version 0.1.1 offers several new functions to download Uzbek Stock Market data along with a vignette documentation
- First release 0.1.0 provides a set of functions to access datasets on [the Official Open Data Portal of Uzbekistan](http://data.gov.uz)

In the latest version (0.1.1), several new functions have been added to collect Uzbek Stock Market data. 

* `getTicker()`: obtains stock market prices over the given period 
* `getMarketIndex()`: provides stock market indices across sectors
* `currentBidsAsks()`: returns current bid and ask prices on the Republican Stock Exchange "Toshkent"
* `ipo()`: returns a data frame with public offerings in last five years
* `getSecurities()`: returns a data frame with the list of securities from [the Republican Stock Exchange "Toshkent" database](http://www.uzse.uz)
* `RegisteredSecurities()`: returns a data frame with the list of securities from [the Central Securities Depository](http://www.deponet.uz) database

<br>

Please refer to [vignette documentation](https://gitcdn.xyz/repo/alishersuyunov/opendatauzb/master/doc/opendatauzb.html) for additional examples:<br>

`browseVignettes("opendatauzb")`<br>
`vignette("opendatauzb", package = "opendatauzb")`

<br><br>

The 0.1.1 version of the package has three key functions:

* `availableDatasets()` - returns a data frame with the list of available datasets on https://data.gov.uz with corresponding **dataset_id**
* `getData(dataset_id)` - downloads a dataset with **dataset_id**
* `getData_dictionary(dataset_id)` - downloads a data dictionary (variables) for the dataset

## Installation
Execute the following code to install the R package from R environment:
`devtools::install_github("alishersuyunov/opendatauzb)`<br>
`remotes::install_github("alishersuyunov/opendatauzb)`<br>

To download and install using pre-compiled binary files, please refer to the [releases](https://github.com/alishersuyunov/opendatauzb/tree/master/releases) folder.

## License
The package is provided under the GPL-3 license.

<br><br>
If you have any feature suggestions or found any bugs, feel free to raise a trouble ticket on: https://github.com/alishersuyunov/opendatauzb/issues
