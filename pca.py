import numpy as np
import pandas as pd

# エクセルファイルのパスを指定
filePath = "pca.xlsx"
inSheet = "subjects"
outSheet = inSheet + "_PCA"
table = {
    "readCol": "H:K",
    "readrow1": 1,
    "readrow2": 21
}
elements = 4

# pandasを使用してエクセルファイルを開く。openpyxlをエンジンとして指定
df = pd.read_excel(filePath, engine = "openpyxl", sheet_name = inSheet, usecols = "H:K", skiprows = 0, nrows = 20)

# データをNumPy配列に変換
data_array = df.to_numpy()
data_array = data_array.T

# 分散共分散行列の計算
cov = np.cov(data_array, ddof = 0)

# 固有値計算
eival, eivec = np.linalg.eig(cov)
if eival.dtype == "complex":
    eival = np.real(eival)
    eivec = np.real(eivec)

# 寄与率順に並びなおし
sortIndex = np.argsort(eival)[::-1]
eival = eival[sortIndex]
eivec = eivec[:, sortIndex]
# 主成分得点を計算
pcs = eivec.T @ data_array
pcs = pcs.T

# Excelに追加する要素をDataFrameに変換
column = [f"要素{i}" for i in range(elements)]
cov_df = pd.DataFrame(cov, columns = column, index = column)
eival_df = pd.DataFrame(eival.reshape(1, elements), index = ["固有値"])
print(eival_df)
column = [None for i in range(elements)]
column[0] = "固有Vec"
eivec_df = pd.DataFrame(eivec, index = column)
print(eivec_df)
column = [f"PCS{i}" for i in range(elements)]
pcs_df = pd.DataFrame(pcs, columns = column)

with pd.ExcelWriter(filePath, engine='openpyxl', mode='a') as writer:
    cov_df.to_excel(writer, sheet_name = outSheet)
    eival_df.to_excel(writer, sheet_name = outSheet, startcol = elements + 2)
    eivec_df.to_excel(writer, sheet_name=outSheet, header = None, startcol = elements + 2, startrow = 2)
    pcs_df.to_excel(writer, sheet_name=outSheet, index=None, startcol = (elements + 2) * 2)
