import os
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt


def list_dir(rel_path):
    ABS = os.path.abspath(rel_path)
    listed_paths = os.listdir(rel_path)
    prepend = lambda path: os.path.join(ABS, path)
    return list(map(prepend, listed_paths))


def read_data(
    filenames,
    columns=None,
    labels=None,
    as_type=None,
    skip_rows=2,
    **kwargs,
):
    read_data = []
    for i, file in enumerate(filenames):
        DATA = pd.read_csv(file, **kwargs)

        if skip_rows:
            DATA = DATA.iloc[skip_rows:, :]
            DATA = DATA.reset_index()

        if columns:
            DATA = DATA[columns]

        if as_type:
            DATA = DATA.astype(as_type)

        if labels:
            DATA["Sort"] = labels[i]

        read_data.append(DATA)

    return read_data if len(filenames) > 1 else read_data[0]


def read_isochrones(*paths, **kwargs):
    data = []
    for path in paths:
        _temp = pd.read_csv(path, **kwargs)
        _temp = _temp.iloc[2:, :]
        _temp = _temp.reset_index()
        _temp = _temp.drop(columns=["index"])
        data.append(_temp)
    return tuple(data)


def histrogram(
    data, bins, xtitle, ytitle, figtitle, color="skyblue", edgecolor="black", save_as=None, **kwargs
):
    fig, axes = plt.subplots(**kwargs)
    axes.hist(data=data, bins=bins, color=color, edgecolor=edgecolor)
    axes.set_xlabel(xtitle)
    axes.set_ylabel(ytitle)
    axes.set_title(figtitle)

    if save_as:
        fig.savefig(save_as)
    plt.show()


def prepare_data(*dframes):
    newdframes = []
    for i, dframe in enumerate(dframes):
        dframe = dframe[["B-V", "Vmag"]]
        dframe = dframe.astype(np.float64)
        dframe = tuple(dframe[column] for column in dframe.columns)
        newdframes.append(dframe)
        print(f"Isohrone #{i} prepared")

    return tuple(newdframes)


def change_col_dtype(*dframes, colname, new_dtype=np.float64, remove_cols=None):
    for dframe in dframes:
        if remove_cols:
            dframe = dframe.drop(columns=remove_cols)

        dframe[colname] = dframe[colname].astype(new_dtype)


def distance_modulus(dist_mod, extinction=None):
    if extinction:
        return 10 ** (0.2 * dist_mod + 1 - extinction)
    return 10 ** (0.2 * dist_mod + 1)
