export OMP_NUM_THREADS=8
export SVM_CACHESIZE=1024

VERIFIER="time bin/verifier.rb"
# baseline
DEFAULTS="--classification function --preprocessor simple --selector simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800"
#eval $VERIFIER $DEFAULTS --id 1 --trainer nelder_mead
#eval $VERIFIER $DEFAULTS --id 2 --trainer doe

# feature selection metrics (grams1_2 is default here)
DEFAULTS="--classification function --preprocessor simple --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 3 --selector bns
#eval $VERIFIER $DEFAULTS --id 4 --selector ig
#eval $VERIFIER $DEFAULTS --id 5 --selector bns_ig

## including 3-grams
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 6 --selector simple
#eval $VERIFIER $DEFAULTS --id 7 --selector bns
#eval $VERIFIER $DEFAULTS --id 8 --selector ig

##only 3/4 grams
#DEFAULTS="--classification function --preprocessor simple --word-selection grams --gram-size 3 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 10 --selector simple
#eval $VERIFIER $DEFAULTS --id 11 --selector bns
#eval $VERIFIER $DEFAULTS --id 12 --selector ig

#DEFAULTS="--classification function --preprocessor simple --word-selection grams --gram-size 4 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 13 --selector simple
#eval $VERIFIER $DEFAULTS --id 14 --selector bns
#eval $VERIFIER $DEFAULTS --id 15 --selector ig

## with stemming
#DEFAULTS="--classification function --preprocessor stemming --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 16 --selector simple
#eval $VERIFIER $DEFAULTS --id 17 --selector bns
#eval $VERIFIER $DEFAULTS --id 18 --selector ig

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

## - samplesize
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 4000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 30 --selector simple
#eval $VERIFIER $DEFAULTS --id 31 --selector ig
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 8000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 35 --selector simple
#eval $VERIFIER $DEFAULTS --id 36 --selector ig

# - evaluators
DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator f1"
eval $VERIFIER $DEFAULTS --id 40 --selector simple
eval $VERIFIER $DEFAULTS --id 41 --selector ig
eval $VERIFIER $DEFAULTS --id 42 --selector bns
DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator f_5"
eval $VERIFIER $DEFAULTS --id 43 --selector simple
eval $VERIFIER $DEFAULTS --id 44 --selector ig
eval $VERIFIER $DEFAULTS --id 45 --selector bns
DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator precision"
eval $VERIFIER $DEFAULTS --id 46 --selector simple
eval $VERIFIER $DEFAULTS --id 47 --selector ig
eval $VERIFIER $DEFAULTS --id 48 --selector bns

# samplesize 3000/2 * 4 == 6000
DEFAULTS="--classification function --preprocessor simple --samplesize 3000 --dictionary-size 800 --trainer nelder_mead"
eval $VERIFIER $DEFAULTS --id 50 --distribution 3 --selector bns_ig
eval $VERIFIER $DEFAULTS --id 51 --distribution 3 --word-selection grams --gram-size 4 --selector simple
eval $VERIFIER $DEFAULTS --id 52 --distribution 3 --word-selection grams1_2_3 --selector bns --evaluator f_5
eval $VERIFIER $DEFAULTS --id 53 --distribution 3 --word-selection grams1_2_3 --selector ig --evaluator f_5



# TODO: after I know how these perform
# - dictionary_size
# - trainer
