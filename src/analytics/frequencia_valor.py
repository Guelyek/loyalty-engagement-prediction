# %%

import pandas as pd
import sqlalchemy
import matplotlib.pyplot as plt
import seaborn as sns
from exec_life_cycle import import_query
from sklearn import cluster, preprocessing


# %%

#abre conexão com o database transacional
engine = sqlalchemy.create_engine("sqlite:///../../data/loyalty-system/database.db")

# %%

#importa a query frequencia_valor.sql e guarda como str

def import_query(path):

    with open(path) as open_file:
        query = open_file.read()

    return query 

query = import_query("frequencia_valor.sql")

# %%

'''executa a query no database do loyalty-predict e guarda a 
tabela como dataframe, além de remover o cliente caju que
é um ponto fora da curva consequência de um bug no sistema
de pontos da live'''

df = pd.read_sql(query, engine)
df = df[df['QtdePontosPos'] < 4000]

# %%

#padronização dos dados
minmax = preprocessing.MinMaxScaler()

X = minmax.fit_transform(df[['QtdeFrequencia', 'QtdePontosPos']])

kmean = cluster.KMeans(n_clusters = 5, random_state = 42,
                       max_iter = 1000)


kmean.fit(X)

df['cluster_calc'] = kmean.labels_

df.groupby(by = 'cluster_calc')['IdCliente'].count()

# %%

sns.scatterplot(data = df, x = df['QtdeFrequencia'],
                y = df['QtdePontosPos'], hue = 'cluster_calc',
                palette = 'deep')
plt.vlines(x = 10, ymin = 0, ymax = 3000)
plt.vlines(x = 4, ymin = 0, ymax = 750)
plt.hlines(y = 1500, xmin = 0, xmax = 25)
plt.hlines(y = 750, xmin = 0, xmax = 25)
plt.grid()

# %%
