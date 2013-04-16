export OMP_NUM_THREADS=8
export SVM_CACHESIZE=1024

VERIFIER="time bin/verifier.rb"
# baseline
DEFAULTS="--classification function --preprocessor simple --selector simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 400"
#eval $VERIFIER $DEFAULTS --id 1 --trainer nelder_mead
#eval $VERIFIER $DEFAULTS --id 2 --trainer doe

#eval $VERIFIER $DEFAULTS --selector simple
#eval $VERIFIER $DEFAULTS --selector bns
eval $VERIFIER $DEFAULTS --selector ig

## feature selection metrics (grams1_2 is default here)
#DEFAULTS="--classification function --preprocessor simple --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 10 --selector bns
#eval $VERIFIER $DEFAULTS --id 11 --selector ig
#eval $VERIFIER $DEFAULTS --id 12 --selector bns_ig
#DEFAULTS="--classification function --preprocessor simple --samplesize 6000 --dictionary-size 600 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 15 --selector simple --word-selection grams1_2
#eval $VERIFIER $DEFAULTS --id 16 --selector bns
#eval $VERIFIER $DEFAULTS --id 17 --selector ig

### including 3-grams
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 20 --selector simple
#eval $VERIFIER $DEFAULTS --id 21 --selector bns
#eval $VERIFIER $DEFAULTS --id 22 --selector ig
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 600 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 25 --selector simple
#eval $VERIFIER $DEFAULTS --id 26 --selector bns
#eval $VERIFIER $DEFAULTS --id 27 --selector ig
#
###only 3/4 grams
#DEFAULTS="--classification function --preprocessor simple --word-selection grams --gram-size 3 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 30 --selector simple
#eval $VERIFIER $DEFAULTS --id 31 --selector bns
#eval $VERIFIER $DEFAULTS --id 32 --selector ig
#DEFAULTS="--classification function --preprocessor simple --word-selection grams --gram-size 3 --samplesize 6000 --dictionary-size 600 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 35 --selector simple
#eval $VERIFIER $DEFAULTS --id 36 --selector bns
#eval $VERIFIER $DEFAULTS --id 37 --selector ig
#
#DEFAULTS="--classification function --preprocessor simple --word-selection grams --gram-size 4 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 40 --selector simple
#eval $VERIFIER $DEFAULTS --id 41 --selector bns
#eval $VERIFIER $DEFAULTS --id 42 --selector ig
#DEFAULTS="--classification function --preprocessor simple --word-selection grams --gram-size 4 --samplesize 6000 --dictionary-size 600 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 45 --selector simple
#eval $VERIFIER $DEFAULTS --id 46 --selector bns
#eval $VERIFIER $DEFAULTS --id 47 --selector ig

#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 3000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 50 --distribution 3 --selector simple
#eval $VERIFIER $DEFAULTS --id 51 --distribution 3 --selector bns
#eval $VERIFIER $DEFAULTS --id 52 --distribution 3 --selector ig
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 3000 --dictionary-size 600 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 55 --distribution 3 --selector simple
#eval $VERIFIER $DEFAULTS --id 56 --distribution 3 --selector bns
#eval $VERIFIER $DEFAULTS --id 57 --distribution 3 --selector ig

#DEFAULTS="--classification function --preprocessor simple --samplesize 6000 --word-selection single --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 60 --selector simple
#eval $VERIFIER $DEFAULTS --id 61 --selector bns
#eval $VERIFIER $DEFAULTS --id 62 --selector ig

## with stemming
#DEFAULTS="--classification function --preprocessor stemming --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 70 --selector simple
#eval $VERIFIER $DEFAULTS --id 71 --selector bns
#eval $VERIFIER $DEFAULTS --id 72 --selector ig

## - samplesize
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 4000 --dictionary-size 800 --trainer doe"
#eval $VERIFIER $DEFAULTS --id 80 --selector simple
#eval $VERIFIER $DEFAULTS --id 81 --selector bns
#eval $VERIFIER $DEFAULTS --id 82 --selector ig
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 8000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 90 --selector simple
#eval $VERIFIER $DEFAULTS --id 91 --selector bns
#eval $VERIFIER $DEFAULTS --id 92 --selector ig

#DEFAULTS="--classification function --preprocessor simple --samplesize 6000 --dictionary-size 400 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 100 --selector simple --word-selection grams1_2
#eval $VERIFIER $DEFAULTS --id 101 --selector bns
#eval $VERIFIER $DEFAULTS --id 102 --selector ig

# cross-validation
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 20 --number-of-folds 1 --selector simple
#eval $VERIFIER $DEFAULTS --id 21 --number-of-folds 1 --selector bns
#eval $VERIFIER $DEFAULTS --id 22 --number-of-folds 1 --selector ig
#eval $VERIFIER $DEFAULTS --id 23 --number-of-folds 2 --selector simple
#eval $VERIFIER $DEFAULTS --id 24 --number-of-folds 2 --selector bns
#eval $VERIFIER $DEFAULTS --id 25 --number-of-folds 2 --selector ig

# distribution real samplesize=samplesize/2 * n+1
# samplesize 3000/2 * 4 == 6000
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 3000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 25 --distribution 3 --selector simple
#eval $VERIFIER $DEFAULTS --id 26 --distribution 3 --selector bns
#eval $VERIFIER $DEFAULTS --id 27 --distribution 3 --selector ig


# - evaluators
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator f1"
#eval $VERIFIER $DEFAULTS --id 40 --selector simple
#eval $VERIFIER $DEFAULTS --id 41 --selector ig
#eval $VERIFIER $DEFAULTS --id 42 --selector bns
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator f_5"
#eval $VERIFIER $DEFAULTS --id 43 --selector simple
#eval $VERIFIER $DEFAULTS --id 44 --selector ig
#eval $VERIFIER $DEFAULTS --id 45 --selector bns
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator precision"
#eval $VERIFIER $DEFAULTS --id 46 --selector simple
#eval $VERIFIER $DEFAULTS --id 47 --selector ig
#eval $VERIFIER $DEFAULTS --id 48 --selector bns
#
## samplesize 3000/2 * 4 == 6000
#DEFAULTS="--classification function --preprocessor simple --samplesize 3000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 50 --distribution 3 --selector bns_ig
#eval $VERIFIER $DEFAULTS --id 51 --distribution 3 --word-selection grams --gram-size 4 --selector simple
#eval $VERIFIER $DEFAULTS --id 52 --distribution 3 --word-selection grams1_2_3 --selector bns --evaluator f_5
#eval $VERIFIER $DEFAULTS --id 53 --distribution 3 --word-selection grams1_2_3 --selector ig --evaluator f_5


# TODO: after I know how these perform
# - dictionary_size
# - trainer
