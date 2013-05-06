export OMP_NUM_THREADS=8
export SVM_CACHESIZE=1024

VERIFIER="time bin/verifier.rb --classification function --samplesize 6000"

for LANGUAGE in en de fr; do
     for PREPROCESSOR in simple stemming; do
          for SELECTOR in simple bns ig; do
               for TOKEN in single grams1_2 grams1_2_3; do
                    for DSIZE in 400 600 800; do
                         eval $VERIFIER --language $LANGUAGE \
                         --preprocessor $PREPROCESSOR --selector $SELECTOR \
                         --word-selection $TOKEN --dictionary-size $DSIZE
                    done
               done
          done
     done
done
