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
DEFAULTS="--classification function --preprocessor stemming --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
#eval $VERIFIER $DEFAULTS --id 16 --selector simple
eval $VERIFIER $DEFAULTS --id 17 --selector bns
eval $VERIFIER $DEFAULTS --id 18 --selector ig

# cross-validation
DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
eval $VERIFIER $DEFAULTS --id 20 --number-of-folds 1 --selector simple
eval $VERIFIER $DEFAULTS --id 21 --number-of-folds 1 --selector bns
eval $VERIFIER $DEFAULTS --id 22 --number-of-folds 1 --selector ig

# distribution real samplesize=samplesize * n+1/n
DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead"
eval $VERIFIER $DEFAULTS --id 25 --distribution 3 --selector simple
eval $VERIFIER $DEFAULTS --id 26 --distribution 3 --selector bns
eval $VERIFIER $DEFAULTS --id 27 --distribution 3 --selector ig

# - samplesize
DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 4000 --dictionary-size 800 --trainer nelder_mead"
eval $VERIFIER $DEFAULTS --id 30 --selector simple
eval $VERIFIER $DEFAULTS --id 31 --selector ig
DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 8000 --dictionary-size 800 --trainer nelder_mead"
eval $VERIFIER $DEFAULTS --id 35 --selector simple
eval $VERIFIER $DEFAULTS --id 36 --selector ig




# - evaluators
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator f1"
#eval $VERIFIER $DEFAULTS --id 30 --selector ig
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator accuracy"
#eval $VERIFIER $DEFAULTS --id 31 --selector ig
#DEFAULTS="--classification function --preprocessor simple --word-selection grams1_2 --samplesize 6000 --dictionary-size 800 --trainer nelder_mead --evaluator precision"
#eval $VERIFIER $DEFAULTS --id 32 --selector ig

# TODO: after I know how these perform
# - dictionary_size
# - trainer
