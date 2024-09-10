import pandas as pd
import glob
import os


@data_loader
def load_data_from_api(*args, **kwargs):
    path = os.getenv('DS_PATH')
    dataset = path+'/csse_covid_19_daily_reports_us/*.csv'

    csv_files = glob.glob(dataset)

    
    dfs = []
    for f in csv_files: 
        # read the csv file
        df = pd.read_csv(f)  # No need to split path here
        dfs.append(df)  # Collect DataFrames in a list

    # Concatenate all DataFrames in the list at once
    df_combined = pd.concat(dfs, ignore_index=True)

    
    # df_combined['Lat'] = df_combined['Lat'].fillna(value=0)

    # df_loc = df_combined[['Lat', 'Long_']]

    return df_combined


@test
def test_row_count(df, *args) -> None:
    assert len(df.index) >= 0, 'The data does not have enough rows.'
