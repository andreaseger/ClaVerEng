export OMP_NUM_THREADS=8
export SVM_CACHESIZE=1024

# baseline
time bin/verifier.rb --preprocessor simple --selector forman --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead

# trainer
time bin/verifier.rb --preprocessor simple --selector forman --samplesize 6000 --dictionary-size 800 --classification function --trainer grid
time bin/verifier.rb --preprocessor simple --selector forman --samplesize 6000 --dictionary-size 800 --classification function --trainer doe

# dictionary
time bin/verifier.rb --preprocessor simple --selector forman --samplesize 6000 --dictionary-size 400 --classification function --trainer nelder_mead
time bin/verifier.rb --preprocessor simple --selector forman --samplesize 6000 --dictionary-size 600 --classification function --trainer nelder_mead
time bin/verifier.rb --preprocessor simple --selector forman --samplesize 6000 --dictionary-size 1000 --classification function --trainer nelder_mead
time bin/verifier.rb --preprocessor simple --selector forman --samplesize 6000 --dictionary-size 1500 --classification function --trainer nelder_mead

# selectors
# n-gram
time bin/verifier.rb --preprocessor simple --selector simple --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --preprocessor simple --selector ngram --gram-size 2 --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --preprocessor simple --selector ngram --gram-size 3 --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --preprocessor simple --selector ngram --gram-size 4 --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead

# binary encoded classification_id
# time bin/verifier.rb --preprocessor simple --selector binary_encoded --samplesize 6000 --dictionary-size 800 --classification function --trainer nelder_mead

# samplesize
time bin/verifier.rb --preprocessor simple --selector simple --samplesize 3000 --dictionary-size 800 --classification function --trainer nelder_mead
time bin/verifier.rb --preprocessor simple --selector simple --samplesize 9000 --dictionary-size 800 --classification function --trainer nelder_mead

# more samplesize w/o parameter search
# $cost=
# $gamma=
# time ruby train.rb -p industry_map -s simple -n 12000 -d 600 -c function -t --cost $cost --gamma $gamma -v
# time ruby train.rb -p industry_map -s simple -n 15000 -d 600 -c function -t --cost $cost --gamma $gamma -v
