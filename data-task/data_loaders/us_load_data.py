import pandas as pd
import glob
import os


@data_loader
def load_data(*args, **kwargs):
    """
    Loads and concatenates COVID-19 daily report CSV files from a specified directory.

    This function retrieves CSV files matching the pattern from the directory specified by the 
    environment variable 'DS_PATH', reads each file into a pandas DataFrame, and then 
    concatenates all DataFrames into a single DataFrame.

    Returns:
        df_combined: A single DataFrame containing the concatenated data from all CSV files.

    """
    # Retrieve the directory path from environment variable 'DS_PATH'
    path = os.getenv('DS_PATH')

    # Define the pattern to match CSV files in the directory
    dataset = os.path.join(path, 'csse_covid_19_daily_reports_us', '*.csv')

    # Get a list of all CSV files matching the pattern
    csv_files = glob.glob(dataset)

    # Initialize a list to store DataFrames
    dfs = []

    # Iterate over each CSV file
    for f in csv_files:
        # read the csv file
        df = pd.read_csv(f)
        # Collect DataFrames in a list
        dfs.append(df)

    # Concatenate all DataFrames in the list at once
    df_combined = pd.concat(dfs, ignore_index=True)

    
    # df_combined['Lat'] = df_combined['Lat'].fillna(value=0)

    # df_loc = df_combined[['Lat', 'Long_']]

    return df_combined


@test
def test_row_count(df, *args) -> None:
    """
    Tests if the DataFrame has at least one row of data.

    This function checks whether the provided DataFrame has a non-negative number of rows.
    If the DataFrame is empty (i.e., has zero rows), an assertion error is raised.

    Args:
        df (pd.DataFrame): The DataFrame to be tested.
    """
    assert len(df.index) >= 0, 'The data does not have enough rows.'
