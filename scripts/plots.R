# ============================================================
# plots.R — Tre grafici comparativi Simpson vs Griffin
# ============================================================
# Eseguire con la working directory impostata su questa cartella (scripts/).
# In RStudio: Session > Set Working Directory > To Source File Location

# --- Librerie ---
library(dplyr)
library(ggplot2)
library(tidytext)
library(textstem)
library(stringr)
library(quanteda)
library(quanteda.textstats)
library(textdata)
library(tidyr)

set.seed(42)

# --- Dati ---
load("../data/raw/simpsons_scripts.RData")
load("../data/processed/simpsons_clean.RData")
load("../data/raw/familyguy_scripts.RData")
load("../data/processed/familyguy_clean.RData")


# ============================================================
# GRAFICO 1 — Frequenze logaritmiche delle parole comuni
# ============================================================

simpson$testo <- lemmatize_strings(simpson$testo)
griffin$testo <- lemmatize_strings(griffin$testo)

elabora_testo <- function(df) {
  df %>%
    unnest_tokens(word, testo) %>%
    filter(!word %in% stop_words$word) %>%
    filter(str_detect(word, "^[a-z]+$")) %>%
    mutate(lemma = lemmatize_words(word)) %>%
    count(lemma, sort = TRUE) %>%
    filter(!lemma %in% stop_words$word)
}

frequenze_simpson <- elabora_testo(simpson) %>% rename(word = lemma, n = n)
frequenze_griffin <- elabora_testo(griffin) %>% rename(word = lemma, n = n)
rm(elabora_testo)

# Stopword personalizzate (parole poco frequenti + nomi dei personaggi)
merged_tmp <- full_join(frequenze_simpson, frequenze_griffin, by = "word", suffix = c("_1", "_2")) %>%
  replace_na(list(n_1 = 0, n_2 = 0))

stopwords_nostre <- c(
  merged_tmp$word[merged_tmp$n_1 < 200 & merged_tmp$n_2 < 170],
  'huh', 'hmm', 'ooh', 'mmm', 'shh', 'hoo', 'aah', 'ugh', 'hmmm', 'hey', 'uh',
  'time', 'gonna', 'gasp', 'whoa', 'yea', 'heh', 'yay', 'ohh', 'woo', 'aye',
  'ahh', 'wee', 'hee', 'aaah', 'whew', 'aha', 'wha', 'boo', 'doo', 'dee', 'arr'
)
rm(merged_tmp)

personaggi <- c(
  'homer','marge','bart','lisa','maggie','abe','mona','mrburns',
  'herb','milhouse','kirk','luann','ned','maude','rod','todd',
  'agnes','seymour','patty','selma','jacqueline','moe','barney',
  'lenny','carl','apu','manjula','ralph','wiggum','lou',
  'eddie','krusty','bob','mel',
  'groundskeeper_willie','skinner','edna','martin',
  'nelson','sherri','terri','janey','database','kearney',
  'dolph','jimbo','miss_hoover','dr_hibbert','nick',
  'professor_frink','comicguy','duffman','snake',
  'bumblebee_man','disco_stu','sea_captain','gil','agnes_skinner',
  'otto','kent_brockman','reverend_lovejoy','helen_lovejoy',
  'judge_snyder','jasper','lunchlady_doris',
  'blue-haired_lawyer','rich_texan','quimby','fat_tony',
  'legs','louie','lionel','troy','artie_ziff',
  'rainier_wolfcastle','kodos','kang','itchy','scratchy',
  "santa's_little_helper",'snowball_ii','snowball_v','grumple',
  'crazy_cat_lady','cookie_kwan','lindsey_naegle','hibbert',
  'sarah_wiggum','lewis','wendell','shauna','brandine',
  'cletus','julio','johnny_tightlips','smithers',
  'matt_groening','el_barto','hugo','amber_simpson',
  "peter", "lois", "meg", "chris", "stewie", "brian",
  "quagmire", "cleveland", "joe", "bonnie",
  "carter", "barbara", "herbert", "consuela", "tom",
  "tricia", "seamus", "jerome", "bruce", "vinny",
  "mayor_west", "adam", "bertram", "rupert", "angela",
  "death", "jillian_russell", "connie", "alice", "babs",
  "carol", "derek_wilcox",
  'griffin', 'simpson', 'springfield', 'flanders', 'willie',
  'simpsons', 'glenn'
)

frequenze_simpson <- frequenze_simpson %>% filter(!word %in% c(stopwords_nostre, personaggi))
frequenze_griffin <- frequenze_griffin %>% filter(!word %in% c(stopwords_nostre, personaggi))

frequenze_simpson <- frequenze_simpson %>% rename(freq_simpson = n)
frequenze_griffin <- frequenze_griffin %>% rename(freq_griffin = n)

words_compare <- inner_join(frequenze_simpson, frequenze_griffin, by = "word")

normalize_simpson <- function(x) x / sum(frequenze_simpson$freq_simpson)
normalize_griffin <- function(x) x / sum(frequenze_griffin$freq_griffin)

words_compare_n <- words_compare %>%
  mutate(
    freq_simpson = normalize_simpson(freq_simpson),
    freq_griffin = normalize_griffin(freq_griffin)
  )

words_compare_f <- words_compare_n %>%
  mutate(total = freq_simpson + freq_griffin) %>%
  slice_max(order_by = total, n = 100)

ggplot(words_compare_f, aes(x = freq_simpson, y = freq_griffin, label = word)) +
  geom_point(alpha = 0.7, color = "steelblue") +
  geom_text(check_overlap = TRUE, hjust = 0, vjust = 1, size = 3) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  scale_x_log10() +
  scale_y_log10() +
  labs(
    title = "Shared Word Frequency: The Simpsons vs. Family Guy",
    x = "Relative Frequency — The Simpsons (log scale)",
    y = "Relative Frequency — Family Guy (log scale)"
  ) +
  theme_minimal()


# ============================================================
# GRAFICO 2 — Parole più distintive: Griffin vs Simpson
# ============================================================

griffin_clean$serie <- "Griffin"
simpson_clean$serie <- "Simpson"

corpus_data <- bind_rows(griffin_clean, simpson_clean)

corp        <- corpus(corpus_data, text_field = "testo")
toks        <- quanteda::tokens(corp)
dfm_all     <- dfm(toks)
dfm_grouped <- dfm_group(dfm_all, groups = docvars(dfm_all, "serie"))

result_keyness <- textstat_keyness(dfm_grouped, target = "Griffin")

n <- 12
top_griffin <- result_keyness %>% filter(chi2 > 0) %>% slice_max(chi2, n = n)
top_simpson  <- result_keyness %>% filter(chi2 < 0) %>% slice_min(chi2, n = n)

top_words <- bind_rows(top_griffin, top_simpson) %>%
  mutate(
    group   = ifelse(chi2 > 0, "Family Guy", "The Simpsons"),
    feature = reorder(feature, chi2)
  )

ggplot(top_words, aes(x = feature, y = chi2, fill = group)) +
  geom_col(show.legend = TRUE) +
  coord_flip() +
  labs(
    title = "Most Distinctive Words: Family Guy vs. The Simpsons",
    x = "Word",
    y = "Chi\u00b2 Statistic",
    fill = "Series"
  ) +
  scale_fill_manual(values = c("Family Guy" = "#1E90FF", "The Simpsons" = "#FFD700")) +
  theme_minimal()


# ============================================================
# GRAFICO 3 — Sentiment medio per stagione (sovrapposto)
# ============================================================

token_simpson <- simpson_clean %>% unnest_tokens(word, testo)
token_griffin <- griffin_clean %>% unnest_tokens(word, testo)

lexicon <- get_sentiments("afinn")

sentiment_per_season_s <- token_simpson %>%
  left_join(lexicon, by = "word") %>%
  group_by(stagione, episodio) %>%
  summarise(sentiment = mean(value, na.rm = TRUE), n_words = n(), .groups = "drop") %>%
  filter(n_words > 10) %>%
  group_by(stagione) %>%
  summarise(sentiment = mean(sentiment)) %>%
  mutate(show = "simpson")

sentiment_per_season_g <- token_griffin %>%
  left_join(lexicon, by = "word") %>%
  group_by(stagione, episodio) %>%
  summarise(sentiment = mean(value, na.rm = TRUE), n_words = n(), .groups = "drop") %>%
  filter(n_words > 10) %>%
  group_by(stagione) %>%
  summarise(sentiment = mean(sentiment)) %>%
  mutate(show = "griffin")

combined_results <- bind_rows(
  sentiment_per_season_s %>% mutate(stagione = stagione + 1988),
  sentiment_per_season_g %>% mutate(stagione = stagione + 13 + 1988)
)

ggplot(combined_results, aes(x = stagione, y = sentiment, color = show, group = show)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c("simpson" = "#FFD700", "griffin" = "#1E90FF"),
    labels = c("Family Guy", "The Simpsons")
  ) +
  labs(
    title = "Average Sentiment Score by Season",
    x = "Year",
    y = "Mean Sentiment Score (AFINN)",
    color = "TV Series"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "bottom"
  )
