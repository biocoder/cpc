CXXC = g++
CFLAGS = -Wall -O3 

all: svm-train svm-predict svm-predict2 svm-scale

svm-predict2: svm-predict2.c svm.o
	$(CXXC) $(CFLAGS) svm-predict2.c svm.o -o svm-predict2 -lm
svm-predict: svm-predict.c svm.o
	$(CXXC) $(CFLAGS) svm-predict.c svm.o -o svm-predict -lm
svm-train: svm-train.c svm.o
	$(CXXC) $(CFLAGS) svm-train.c svm.o -o svm-train -lm
svm-scale: svm-scale.c
	$(CXXC) $(CFLAGS) svm-scale.c -o svm-scale
svm.o: svm.cpp svm.h
	$(CXXC) $(CFLAGS) -c svm.cpp
clean:
	rm -f *~ svm.o svm-train svm-predict svm-predict2 svm-scale
