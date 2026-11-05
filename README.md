# Which microbes live in four different types of forest, and what is their functional potential?

Repository for the DTU course 27200 - Data-driven Bioengineering.

## Software environment

All tools are installed with [conda](https://docs.conda.io/) (e.g. via
[Miniconda](https://www.anaconda.com/docs/getting-started/miniconda/install/linux-install)
or [Miniforge](https://github.com/conda-forge/miniforge)). The environments are defined in
[`envs/`](envs/) with pinned versions, and are built for Linux (x86-64), e.g. the DTU HPC.
There are two environments:

| Environment | File | Tools | Pipeline steps |
|---|---|---|---|
| `meta` | [`envs/meta.yml`](envs/meta.yml) | seqkit, porechop, filtlong, flye | 1–4: QC, adaptor trimming, filtering, assembly |
| `bakta` | [`envs/bakta.yml`](envs/bakta.yml) | bakta | 5: gene annotation |

Bakta has many dependencies, so it gets its own environment to avoid conflicts with the other tools.

### Setup

On the DTU HPC, run `linuxsh` first. Then, from the repository root:

```bash
conda env create -f envs/meta.yml
conda env create -f envs/bakta.yml
```

### Activation

Interactively:

```bash
conda activate meta     # for QC, trimming, filtering and assembly
conda activate bakta    # for annotation
conda deactivate        # to leave an environment
```

Inside a `bsub` job script, use `source activate` instead (`conda activate` does not work there):

```bash
source activate meta
```

Bakta also needs a database. On the DTU HPC the course provides one at
`/dtu/datasets3/c27200/databases/bakta/db-light/`. The bakta version must match the
database version (bakta ≥ 1.10 needs a v6 database). If bakta reports an incompatible
database, change the pinned bakta version in `envs/bakta.yml` to match.

To update an environment after the `.yml` file changes:

```bash
conda env update -f envs/meta.yml --prune
```
