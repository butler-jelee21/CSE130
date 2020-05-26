#!/bin/sh

BUFFER="#########"
BASE="tests/"
i=0

echo "$BUFFER Test $i: Testing nonexistent file $BUFFER"
cat foo > test_out/test.cat.out.$i 2>test_out/test.cat.err.out.$i
./dog foo > test_out/test.dog.out.$i 2>test_out/test.dog.err.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
if diff test_out/test.cat.err.out.$i test_out/test.dog.err.out.$i | grep -q "(dog|cat):.*"; then
	echo "Error: error messages does not match cat... FAILURE!"
fi
i=$((i+1))
echo "\n"

echo "$BUFFER Test $i: Testing dog on directory $BUFFER"
cat $BASE > test_out/test.cat.out.$i 2>test_out/test.cat.err.out.$i
./dog $BASE > test_out/test.dog.out.$i 2>test_out/test.dog.err.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
if diff test_out/test.cat.err.out.$i test_out/test.dog.err.out.$i | grep -q "(dog|cat):.*"; then
	echo "Error: error messages does not match cat... FAILURE!"
fi
i=$((i+1))
echo "\n"

echo "$BUFFER Test $i: Testing stdin with binary file $BUFFER"
cat - < $BASE/test.bin > test_out/test.cat.out.$i
./dog - < $BASE/test.bin > test_out/test.dog.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
i=$((i+1))
echo "\n"

echo "$BUFFER Test $i: Testing stdin with text file $BUFFER"
cat - < $BASE/test.txt > test_out/test.cat.out.$i
./dog - < $BASE/test.txt > test_out/test.dog.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
i=$((i+1))
echo "\n"

echo "$BUFFER Test $i: Testing with binary files as argument $BUFFER"
cat $BASE/test.bin > test_out/test.cat.out.$i
./dog $BASE/test.bin > test_out/test.dog.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
i=$((i+1))
echo "\n"

echo "$BUFFER Test $i: Testing with text files as argument $BUFFER"
cat $BASE/test.txt > test_out/test.cat.out.$i
./dog $BASE/test.txt > test_out/test.dog.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
i=$((i+1))
echo "\n"

echo "$BUFFER Test $i: Testing with pdf files as argument $BUFFER"
cat DESIGN.pdf > test_out/test.cat.out.$i
./dog DESIGN.pdf > test_out/test.dog.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
i=$((i+1))
echo "\n"

echo "$BUFFER Test $i: Testing with multiple files as argument $BUFFER"
cat $BASE/test.bin $BASE/test.txt > test_out/test.cat.out.$i
./dog $BASE/test.txt $BASE/test.bin> test_out/test.dog.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
i=$((i+1))
echo "\n"

#### TODO ####
# echo "$BUFFER Test $i: Testing with multiple - (dash) as argument $BUFFER"
# cat $BASE/test.bin $BASE/test.txt > test_out/test.cat.out.$i
# ./dog $BASE/test.txt $BASE/test.bin> test_out/test.dog.out.$i
# diff test_out/test.cat.out.$i test_out/test.dog.out.$i
# i=$((i+1))
# echo "\n"

echo "$BUFFER Test $i: Testing with one file and one - (dash) as argument $BUFFER"
cat $BASE/test.bin - < $BASE/test.txt > test_out/test.cat.out.$i
./dog - $BASE/test.bin < $BASE/test.txt > test_out/test.dog.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
i=$((i+1))
echo "\n"

echo "$BUFFER Test $i: Testing with multiple files and one - (dash) as argument $BUFFER"
cat $BASE/test.bin - < $BASE/test.txt $BASE/test.txt > test_out/test.cat.out.$i
./dog $BASE/test.txt - $BASE/test.bin < $BASE/test.txt > test_out/test.dog.out.$i
diff test_out/test.cat.out.$i test_out/test.dog.out.$i
i=$((i+1))
echo "\n"

#### TODO ####
# echo "$BUFFER Test $i: Testing with multiple files and multiple - (dash) as argument $BUFFER"
# cat $BASE/test.bin - < $BASE/test.txt $BASE/test.txt - < $BASE/test.bin > test_out/test.cat.out.$i
# ./dog - < $BASE/test.bin $BASE/test.txt - < ($BASE/test.txt) $BASE/test.bin > test_out/test.dog.out.$i
# diff test_out/test.cat.out.$i test_out/test.dog.out.$i
# i=$((i+1))
# echo "\n"