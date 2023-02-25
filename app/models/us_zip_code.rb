# Income: https://data.census.gov/table?tid=ACSST5Y2020.S1901
#   Ensure using a 5-year data set and a recent year
# Filter by Geos } ZIP Code Tabulation Area } All 5-digit ZIP...
# Download Table
# Remove all columns except
#   NAME: Geographic Area Name
#   S1901_C01_001E: Estimate!!Households!!Total
#   S1901_C01_013E: Estimate!!Households!!Mean income (dollars)
# Sort by S1901_C01_013E descending and delete non-numeric rows
class UsZipCode < ApplicationRecord
end
