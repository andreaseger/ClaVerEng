export OMP_NUM_THREADS=8
export SVM_CACHESIZE=1024

# f_measure
#16time bin/verifier.rb --evaluator f1 --selector ngram --gram 3 --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --evaluator f1 --selector forman --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --evaluator f_5 --selector forman --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --evaluator f_5 --selector ngram --gram 3 --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --evaluator f2 --selector forman --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --evaluator f2 --selector ngram --gram 3 --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead

# forman word selection (grams1_2 is default)
time bin/verifier.rb --selector forman --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --selector forman --word-selection grams1_2_3_4 --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --selector forman --word-selection grams1_2_3 --samplesize 6000 --dictionary-size 1000 --classification function --trainer nelder_mead
time bin/verifier.rb --selector forman --word-selection grams1_2_3_4 --samplesize 6000 --dictionary-size 1000 --classification function --trainer nelder_mead


