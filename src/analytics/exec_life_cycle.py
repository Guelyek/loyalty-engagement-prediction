# %%

import pandas as pd
import sqlalchemy
import datetime as dt
from tqdm import tqdm 

# %%

engine_app = sqlalchemy.create_engine("sqlite:///../../data/loyalty-system/database.db")
engine_analytical = sqlalchemy.create_engine("sqlite:///../../data/analytics/database.db")

# %%

def import_query(path):

    with open(path) as open_file:
        query = open_file.read()

    return query 

query = import_query("life_cycle.sql")

# %%

def date_range(start, stop):

    dates = []

    while start <= stop:

        dates.append(start)
        df_start = dt.datetime.strptime(start, '%Y-%m-%d') + dt.timedelta(days = 1)
        start = dt.datetime.strftime(df_start, '%Y-%m-%d')

    return dates

dates = date_range('2024-03-01', '2026-11-01')

# %%

for i in tqdm(dates):

    with engine_analytical.connect() as con:

        try:
                
                query_delete = f"DELETE FROM life_cycle WHERE dtRef = date('{i}', '-1 day')"
                con.execute(sqlalchemy.text(query_delete))
                con.commit()

        except Exception as err:

            print(err)

    query_format = query.format(date = i)
    df = pd.read_sql(query_format, engine_app)
    df.to_sql("life_cycle", engine_analytical, index = False, if_exists = 'append')