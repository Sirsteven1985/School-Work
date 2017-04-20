#ifndef FUNCTIONS_H
#define FUNCTIONS_H

void print_hello();
int factorial(int n);

struct clue {

    char  word[50]; //title
    char  clues[50]; //author
    int  row;
    int  col;
    char  orient;
    int solved;
};

#endif

