srcs="Deque.java RandomizedQueue.java Permutation.java"
cd src/main/java
cp $srcs ../../../
cd ../../../
zip queues-testing.zip $srcs
rm $srcs
