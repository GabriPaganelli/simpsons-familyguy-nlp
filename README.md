# Analisi testuale comparativa: I Simpson e I Griffin
# *Comparative Text Analysis: The Simpsons and Family Guy*

---

## Italiano

### Panoramica

Progetto universitario di *text mining* e *natural language processing* (NLP) applicato
alle sceneggiature di *I Simpson* e *I Griffin*. L'analisi confronta le due serie
attraverso analisi delle frequenze, *topic modeling* (LDA e STM) e *sentiment analysis*,
correlando i risultati con i rating IMDb degli episodi.

**Report compilato:** [`simpsons_familyguy_report.html`](simpsons_familyguy_report.html)

### Metodologia

Pipeline di analisi in sette fasi:

1. **Web scraping** (`appendix.Rmd`, Appendice A) — trascrizioni da *Springfield!Springfield!* e rating da IMDb
2. **Pre-processing** (`appendix.Rmd`, Appendice C) — pulizia, tokenizzazione, lemmatizzazione
3. **Text mining** (`simpsons_familyguy_analysis.Rmd`, §1) — frequenze, keyness, word cloud
4. **Topic modeling LDA** (`simpsons_familyguy_analysis.Rmd`, §2) — macro-temi per serie
5. **Topic modeling STM** (`simpsons_familyguy_analysis.Rmd`, §3) — modello strutturale con varia covariate
6. **Sentiment analysis** (`simpsons_familyguy_analysis.Rmd`, §4) — evoluzione del tono emotivo per stagione
7. **Correlazioni IMDb** (`simpsons_familyguy_analysis.Rmd`, §5) — relazione tra sentiment/topic e rating

### Repository Structure

```
simpsons-familyguy-nlp/
├── README.md
├── LICENSE
├── simpsons_familyguy_report.html        # Report compilato
├── analysis/
│   ├── simpsons_familyguy_analysis.Rmd   # Report principale
│   └── appendix.Rmd                      # Appendice: scraping, pre-processing, funzioni
├── scripts/
│   └── plots.R                           # 3 grafici comparativi standalone
└── data/
    ├── raw/
    │   ├── simpsons_scripts.RData         # Trascrizioni grezze dei Simpson
    │   ├── familyguy_scripts.RData        # Trascrizioni grezze dei Griffin
    │   └── imdb_ratings.RData             # Rating IMDb e metadati episodi
    ├── processed/
    │   ├── simpsons_clean.RData           # Testi puliti e lemmatizzati (senza personaggi)
    │   ├── simpsons_clean_chars.RData     # Testi puliti e lemmatizzati (con personaggi)
    │   ├── familyguy_clean.RData
    │   └── familyguy_clean_chars.RData
    └── models/
        ├── lda_simpsons.RData             # LDA Simpson
        ├── lda_simpsons_chars.RData
        ├── lda_familyguy.RData            # LDA Griffin
        ├── lda_familyguy_chars.RData
        ├── stm_simpsons.RData             # STM Simpson
        └── stm_simpsons_v2.RData
```

### Installazione

R ≥ 4.0 e RStudio. Dati pre-elaborati e modelli già inclusi — non è necessario
rieseguire scraping e pre-processing.

```r
install.packages(c(
  "cowplot", "dplyr", "future", "future.apply", "ggplot2", "ggwordcloud",
  "gridExtra", "knitr", "LDAvis", "lda", "lubridate", "parallel",
  "patchwork", "quanteda", "quanteda.textstats", "reshape2",
  "RColorBrewer", "SnowballC", "stm", "stringr", "textstem",
  "tidytext", "tidyverse", "tm", "tokenizers", "topicmodels",
  "tsne", "wordcloud", "textdata"
))
```

### Utilizzo

```r
# Analisi completa
# 1. Aprire analysis/simpsons_familyguy_analysis.Rmd in RStudio
# 2. Session → Set Working Directory → To Source File Location
# 3. Ctrl+Shift+K per fare knit

# Solo grafici comparativi standalone
setwd("scripts/")
source("plots.R")
```

### Risultati

Il report compilato include:
- Analisi comparative delle frequenze lessicali e keyness tra le due serie
- I topic LDA identificati per ciascuna serie, con interpretazione tematica
- Modello STM con diverse covariate
- Evoluzione del sentiment per stagione e correlazione con i rating IMDb
- Modelli salvati in `data/models/` per riproducibilità senza ricalcolo

**Fonti dei dati:**
- [Springfield! Springfield!](https://www.springfieldspringfield.co.uk/) — uso accademico/non commerciale
- [IMDb](https://www.imdb.com/) — rating e riassunti episodi

### Autori

**Caicchiolo Giorgia, Carollo Daniele, Paganelli Gabriele, Pati Riccardo, Tossici Giorgia** — Academic Portfolio

---

## English

### Overview

University project applying *text mining* and *natural language processing* (NLP) to the
scripts of *The Simpsons* and *Family Guy*. The analysis compares the two shows through
word frequency analysis, *topic modeling* (LDA and STM), and *sentiment analysis*,
correlating results with IMDb episode ratings.

**Compiled report:** [`simpsons_familyguy_report.html`](simpsons_familyguy_report.html)

### Methodology

Seven-stage analysis pipeline:

1. **Web scraping** (`appendix.Rmd`, Appendix A) — transcripts from *Springfield!Springfield!* and ratings from IMDb
2. **Pre-processing** (`appendix.Rmd`, Appendix C) — cleaning, tokenization, lemmatization
3. **Text mining** (`simpsons_familyguy_analysis.Rmd`, §1) — frequency analysis, keyness, word clouds
4. **LDA topic modeling** (`simpsons_familyguy_analysis.Rmd`, §2) — macro-themes per series
5. **STM topic modeling** (`simpsons_familyguy_analysis.Rmd`, §3) — structural topic model with several covariates
6. **Sentiment analysis** (`simpsons_familyguy_analysis.Rmd`, §4) — emotional tone evolution across seasons
7. **IMDb correlations** (`simpsons_familyguy_analysis.Rmd`, §5) — relationship between sentiment/topics and ratings

### Repository Structure

```
simpsons-familyguy-nlp/
├── README.md
├── LICENSE
├── simpsons_familyguy_report.html        # Compiled report
├── analysis/
│   ├── simpsons_familyguy_analysis.Rmd   # Main analysis report
│   └── appendix.Rmd                      # Appendix: scraping, pre-processing, helper functions
├── scripts/
│   └── plots.R                           # 3 standalone comparative plots
└── data/
    ├── raw/
    │   ├── simpsons_scripts.RData         # Raw Simpsons episode transcripts
    │   ├── familyguy_scripts.RData        # Raw Family Guy episode transcripts
    │   └── imdb_ratings.RData             # IMDb ratings and episode metadata
    ├── processed/
    │   ├── simpsons_clean.RData           # Cleaned and lemmatized texts (no character names)
    │   ├── simpsons_clean_chars.RData     # Cleaned and lemmatized texts (with character names)
    │   ├── familyguy_clean.RData
    │   └── familyguy_clean_chars.RData
    └── models/
        ├── lda_simpsons.RData             # LDA model — Simpsons
        ├── lda_simpsons_chars.RData
        ├── lda_familyguy.RData            # LDA model — Family Guy
        ├── lda_familyguy_chars.RData
        ├── stm_simpsons.RData             # STM model — Simpsons
        └── stm_simpsons_v2.RData
```

### Installation

R ≥ 4.0 and RStudio. Pre-processed data and fitted models are already included —
re-running scraping and pre-processing is not required.

```r
install.packages(c(
  "cowplot", "dplyr", "future", "future.apply", "ggplot2", "ggwordcloud",
  "gridExtra", "knitr", "LDAvis", "lda", "lubridate", "parallel",
  "patchwork", "quanteda", "quanteda.textstats", "reshape2",
  "RColorBrewer", "SnowballC", "stm", "stringr", "textstem",
  "tidytext", "tidyverse", "tm", "tokenizers", "topicmodels",
  "tsne", "wordcloud", "textdata"
))
```

### Usage

```r
# Full analysis
# 1. Open analysis/simpsons_familyguy_analysis.Rmd in RStudio
# 2. Session → Set Working Directory → To Source File Location
# 3. Knit the document (Ctrl+Shift+K)

# Standalone comparative plots only
setwd("scripts/")
source("plots.R")
```

### Results

The compiled report includes:
- Comparative lexical frequency and keyness analysis between the two shows
- LDA topics identified per series, with thematic interpretation
- STM model with different covariates
- Sentiment evolution across seasons and correlation with IMDb ratings
- Fitted models saved in `data/models/` for reproducibility without recomputation

**Data sources:**
- [Springfield! Springfield!](https://www.springfieldspringfield.co.uk/) — academic and non-commercial use only
- [IMDb](https://www.imdb.com/) — scraped user ratings and episode summaries

### Authors

**Caicchiolo Giorgia, Carollo Daniele, Paganelli Gabriele, Pati Riccardo, Tossici Giorgia** — Academic Portfolio
