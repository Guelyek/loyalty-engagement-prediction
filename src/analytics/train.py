# %%

import pandas as pd
import sqlalchemy 
from sklearn import model_selection

# %%

pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

# %%

con = sqlalchemy.create_engine("sqlite:///../../data/analytics/database.db")

# %%

# SAMPLE - IMPORT DOS DADOS

df = pd.read_sql("abt_fiel", con)
df.head()

# %%

# SAMPLE - OOT

df_oot = df[df['DtRef'] ==  df['DtRef'].max()].reset_index(drop = True)
df_oot

# %%

# SAMPLE - Teste e Treino

target = 'flgFiel'
features = df.columns.to_list()[3:]

df_treino_teste = df[df['DtRef'] <  df['DtRef'].max()].reset_index(drop = True)

y = df_treino_teste[target]
X = df_treino_teste[features]

X_train, X_test, y_train, y_test = \
    model_selection.train_test_split(X, y, 
                                     test_size = 0.2, 
                                     random_state = 42,
                                     stratify = y)

print(f"Base treino: {y_train.shape[0]} Unid. | Tx. Target \
      {100*y_train.mean():.2f}%")

print(f"Base teste: {y_train.shape[0]} Unid. | Tx. Target \
      {100*y_test.mean():.2f}%")

# %%

# EXPLORE - MISSING

cat_features = ['DescLifeCycleAtual', 'DescLifeCycleD28']
num_features = list(set(features) - set(cat_features))

df_train = X_train.copy()
df_train[target] = y_train.copy()

df_train[num_features] = df_train[num_features].astype(float)

bivariada = df_train.groupby(target)[num_features].median().T
bivariada['ratio'] = (bivariada[1] + 0.001)/(bivariada[0] + 0.001)
bivariada.sort_values(by = 'ratio', ascending = False)

to_remove = bivariada[bivariada['ratio'] == 1].index.tolist()

for i in to_remove:
    features.remove(i)
    num_features.remove(i)

bivariada = df_train.groupby(target)[num_features].median().T
bivariada['ratio'] = (bivariada[1] + 0.001)/(bivariada[0] + 0.001)
bivariada.sort_values(by = 'ratio', ascending = False)

# %%

df_train.groupby('DescLifeCycleAtual')[target].mean()


# %%

df_train.groupby('DescLifeCycleD28')[target].mean()
# %%
