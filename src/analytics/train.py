# %%

import pandas as pd
import sqlalchemy 
from sklearn import model_selection
from feature_engine import selection, imputation, encoding
from sklearn import tree, ensemble, metrics

# %%

pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

# %%

con = sqlalchemy.create_engine("sqlite:///../../data/analytics/database.db")

# %%

# SAMPLE - IMPORT DOS DADOS

df = pd.read_sql("select * from abt_fiel", con)
df.head()

# %%

# SAMPLE - OOT

df_oot = df[df['DtRef'] >= '2026-07-01'].reset_index(drop=True)
df_oot

# %%

# SAMPLE - Teste e Treino

target = 'flgFiel'
features = df.columns.to_list()[3:]

df_treino_teste = df[df['DtRef'] <  '2026-07-01'].reset_index(drop = True)

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

s_nas = X_train.isna().mean()
s_nas = s_nas[s_nas > 0]

s_nas

# %%

# EXPLORE BIVARIADA 

cat_features = ['DescLifeCycleAtual', 'DescLifeCycleD28']
num_features = list(set(features) - set(cat_features))

df_train = X_train.copy()
df_train[target] = y_train.copy()

df_train[num_features] = df_train[num_features].astype(float)

bivariada = df_train.groupby(target)[num_features].median().T
bivariada['ratio'] = (bivariada[1] + 0.001)/(bivariada[0] + 0.001)
bivariada = bivariada.sort_values(by = 'ratio', ascending = False)
bivariada

# %%

df_train.groupby('DescLifeCycleAtual')[target].mean()

# %%

df_train.groupby('DescLifeCycleD28')[target].mean()

# %%

# MODIFY - DROP

X_train[num_features] = X_train[num_features].astype(float)

to_remove = bivariada[bivariada['ratio'] == 1].index.tolist()

#REMOÇÂO DE FEATURES COM A RAZÂO ENTRE MEDIANAS VAR RESPOSTA = 1

drop_features = selection.DropFeatures(to_remove)

# %%

# MODIFY - MISSING


fill_0 = ['github_2025', 'python_2025']
imput_0 = imputation.ArbitraryNumberImputer(arbitrary_number = 0,
                                            variables = fill_0)

# %%

imput_new = imputation.CategoricalImputer(fill_value = 'Não usuário',
                                          variables = ['DescLifeCycleD28'])

imput_1000 = imputation.ArbitraryNumberImputer(
    arbitrary_number = 1000,
    variables = ['avgIntervaloDiasVida', 'avgIntervaloDiasD28',
                 'UltimaAtivacao']
)

# %%

# MODIFY - ONEHOT

onehot = encoding.OneHotEncoder(variables = cat_features)

# %%

# MODIFY - APLICANDO TRANSFORMAÇÕES NO DATASET

X_train_transform = drop_features.fit_transform(X_train)
X_train_transform = imput_0.fit_transform(X_train_transform)
X_train_transform = imput_new.fit_transform(X_train_transform)
X_train_transform = imput_1000.fit_transform(X_train_transform)
X_train_transform = onehot.fit_transform(X_train_transform)

# %%

# MODEL

#model = tree.DecisionTreeClassifier(random_state = 42, min_samples_leaf = 50)
model = ensemble.AdaBoostClassifier(random_state = 42, n_estimators = 150, learning_rate = 0.1)

model.fit(X_train_transform, y_train)

# %%

def predict_proba(X):

    return model.predict(X), model.predict_proba(X)

y_train_predict, y_train_proba = predict_proba(X_train_transform)


acc_train = metrics.accuracy_score(y_train, y_train_predict)
auc_train = metrics.roc_auc_score(y_train, y_train_proba[:,1])

# %% TESTE

X_test[num_features] = X_test[num_features].astype(float)

X_test_transform = drop_features.transform(X_test)
X_test_transform = imput_0.transform(X_test_transform)
X_test_transform = imput_new.transform(X_test_transform)
X_test_transform = imput_1000.transform(X_test_transform)
X_test_transform = onehot.transform(X_test_transform)

y_test_predict, y_test_proba = predict_proba(X_test_transform)

acc_test = metrics.accuracy_score(y_test, y_test_predict)
auc_test = metrics.roc_auc_score(y_test, y_test_proba[:,1])

# %% OOT

y_oot = df_oot[target]
X_oot = df_oot[features].copy()

X_oot[num_features] = X_oot[num_features].astype(float)

X_oot_transform = drop_features.transform(X_oot)
X_oot_transform = imput_0.transform(X_oot_transform)
X_oot_transform = imput_new.transform(X_oot_transform)
X_oot_transform = imput_1000.transform(X_oot_transform)
X_oot_transform = onehot.transform(X_oot_transform)

y_oot_predict, y_oot_proba = predict_proba(X_oot_transform)

acc_oot = metrics.accuracy_score(y_oot, y_oot_predict)
auc_oot = metrics.roc_auc_score(y_oot, y_oot_proba[:,1])

# %%

print(f"ACC TREINO {acc_train:.2f}, ACC Teste {acc_test:.2f}, ACC oot {acc_oot:.2f}")

print(f"auc TREINO {auc_train:.2f}, auc Teste {auc_test:.2f}, auc oot {auc_oot:.2f}")
# %%

features_names = X_train_transform.columns.tolist()
featutes_importance = pd.Series(model.feature_importances_, index = features_names)

featutes_importance.sort_values(ascending =  False)

# %%
