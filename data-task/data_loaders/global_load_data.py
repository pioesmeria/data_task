import pandas as pd
import glob
import os

# Decorator for marking the function as a data loader
@data_loader
def load_data(*args, **kwargs):
    """
    Load and combine COVID-19 data from CSV files into a single DataFrame.

    The function:
    - Retrieves the file path from an environment variable `DS_PATH`.
    - Constructs the file path pattern to locate CSV files.
    - Reads each CSV file into a DataFrame and collects these DataFrames into a list.
    - Concatenates all collected DataFrames into a single DataFrame.

    Returns:
        df_combined: A combined DataFrame containing all the data from the CSV files.
    """
    # Get the path to the directory containing the CSV files from an environment variable
    path = os.getenv('DS_PATH')
    
    # Construct the file pattern for CSV files
    dataset = os.path.join(path, 'csse_covid_19_daily_reports', '*.csv')

    # Find all CSV files matching the pattern
    csv_files = glob.glob(dataset)

    # Initialize an empty list to collect DataFrames
    dfs = []
    
    for f in csv_files:
        # Read each CSV file into a DataFrame
        df = pd.read_csv(f)
        # Append the DataFrame to the list
        dfs.append(df)
    
    # Concatenate all DataFrames in the list into a single DataFrame
    df_combined = pd.concat(dfs, ignore_index=True)

    return df_combined

# Decorator for marking the function as a test
@test
def test_row_count(df, *args) -> None:
    """
    Test to ensure the DataFrame contains at least one row.

    Args:
        df (pd.DataFrame): The DataFrame to test.
    
    Raises:
        AssertionError: If the DataFrame has no rows.
    """
    # Assert that the DataFrame has at least one row
    assert len(df.index) >= 0, 'The data does not have enough rows.'
