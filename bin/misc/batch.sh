export OMP_NUM_THREADS=8
export SVM_CACHESIZE=512

# baseline
time bin/verifier.rb --preprocessor simple --selector simple --samplesize 6000 --dictionary-size 600 --classification function --trainer nelder_mead

# trainer
#time bin/verifier.rb -p industry_map -s simple -n 6000 -d 600 -c function -t doe -v
#time bin/verifier.rb -p industry_map -s simple -n 6000 -d 600 -c function -t grid -v
#
## dictionary
#time be ruby verifier.rb -p industry_map -s simple -n 6000 -d 400 -c function -t nelder_mead -v
#time be ruby verifier.rb -p industry_map -s simple -n 6000 -d 800 -c function -t nelder_mead -v
#time be ruby verifier.rb -p industry_map -s simple -n 6000 -d 1000 -c function -t nelder_mead -v
#
## n-gram
#time be ruby verifier.rb -p industry_map -s ngram -g 2 -n 6000 -d 600 -c function -t nelder_mead -v
#time be ruby verifier.rb -p industry_map -s ngram -g 3 -n 6000 -d 600 -c function -t nelder_mead -v
#time be ruby verifier.rb -p industry_map -s ngram -g 4 -n 6000 -d 600 -c function -t nelder_mead -v
#
## binary encoded classification_id
#time be ruby verifier.rb -p simple -s binary_encoded -n 6000 -d 600 -c function -t nelder_mead -v
#
## samplesize
#time be ruby verifier.rb -p industry_map -s simple -n 3000 -d 600 -c function -t nelder_mead -v
#time be ruby verifier.rb -p industry_map -s simple -n 9000 -d 600 -c function -t nelder_mead -v

# more samplesize w/o parameter search
# $cost=
# $gamma=
# time be ruby train.rb -p industry_map -s simple -n 12000 -d 600 -c function -t --cost $cost --gamma $gamma -v
# time be ruby train.rb -p industry_map -s simple -n 15000 -d 600 -c function -t --cost $cost --gamma $gamma -v
