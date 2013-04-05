export OMP_NUM_THREADS=8
export SVM_CACHESIZE=1024

# think about which trainer to use by default
DEFAULTS = 'time bin/verifier.rb --classification function --trainer nelder_mead'

# baseline
$DEFAULTS --preprocessor simple --selector simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800

# feature selection metrics (grams1_2 is default here)
$DEFAULTS --preprocessor simple --selector bns --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector ig --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector bns_ig --samplesize 6000 --dictionary-size 800

# including 3-grams
$DEFAULTS --preprocessor simple --selector simple --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector bns --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector ig --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector bns_ig --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 800

#only 3/4 grams
$DEFAULTS --preprocessor simple --selector simple --word-selection grams --gram-size 3 --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector bns --word-selection grams --gram-size 3 --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector ig --word-selection grams --gram-size 3 --samplesize 6000 --dictionary-size 800

$DEFAULTS --preprocessor simple --selector simple --word-selection grams --gram-size 4 --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector bns --word-selection grams --gram-size 4 --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor simple --selector ig --word-selection grams --gram-size 4 --samplesize 6000 --dictionary-size 800

# with stemming
$DEFAULTS --preprocessor stemming --selector bns --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor stemming --selector ig --samplesize 6000 --dictionary-size 800
$DEFAULTS --preprocessor stemming --selector bns_ig --samplesize 6000 --dictionary-size 800

# TODO: after I know how these perform
# - samplesize
# - dictionary_size
# - evaluators
# - trainer