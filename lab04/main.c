/// This is a crossword puzzle program
//By: Steve Guerrero
//email: s_guerrero1@u.pacific.edu

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "functions.h"

char** createArray(int rows, int cols);
void fillArray(char** myArray, int rows, int cols);
void printArray(char** myArray, int rows, int cols);
void deleteArray(char** myArray, int rows);


int main(void)
{


    const int ROWS = 5;
    const int COLS = 7;
    char** myArray;
    char numArray[2][8]={{' ',' ','1','2','3','4','5'},
    {' ',' ','-','-','-','-','-',}};


    myArray = createArray(ROWS, COLS);
    fillArray(myArray, ROWS, COLS);



    char filename[256];
    char garbage;
    int row, col, clues;

    printf("Enter game filename to load: ");
    FILE *myfile=NULL;
    scanf("%255s",filename);
    myfile = fopen(filename,"r");
    struct clue clue[6];// builds array of clues
    
    fscanf(myfile, "%i %i %i\n",&row, &col, &clues);
    printf("Game is %i rows x %i cols with %i words \n",row,col,clues);
    for(int count=0;count<6;count++){
        fscanf(myfile, "%c %i %i %255s %255[^\n]", &clue[count].orient, &clue[count].row, &clue[count].col, clue[count].word, clue[count].clues);

        fscanf(myfile, "%c", &garbage);

        clue[count].solved=0;
    }

    /// printf(clue[count].orient, clue[count].row, clue[count].col, clue[count].word, clue[count].clues);

    printf("CURRENT PUZZLE: \n \n");

    for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 7; j++)
    printf("%c ", numArray[i][j]);
    printf("\n");
    }


    printArray(myArray, ROWS, COLS);
    deleteArray(myArray, ROWS);

    printf("\n Unsolved Clues: \n");
    printf("-------------------- \n");
    printf("#       Direction      Row/Col      Clues: \n");


    int c_num = 6;
    for (int j=0;j<c_num;j++)
    {
        printf("%i          %c           %i/%i       %.40s\n",j+1,clue[j].orient, clue[j].row, clue[j].col, clue[j].clues);

    }

    int sel;
    int clue_num =4;
    while(clue_num!=0)
    {


    printf("\nPlease enter a clue to solve, or -1 to exit: ");
    scanf("%d", &sel );

    if(sel==-1)
        return 1;

    if(sel>7)
        printf("Invalid input, choose from selected clues \n");

    clue_num --;
    }

    return EXIT_SUCCESS;
}

char** createArray(int rows, int cols) {
    char **myArray;

    // Allocate a 1xROWS array to hold pointers to more arrays
    myArray = calloc(rows, sizeof(int *));
    if (myArray == NULL) {
    printf("FATAL ERROR: out of memory: %s\n", strerror(errno));
    exit(EXIT_FAILURE);
    }

    // Allocate each row in that column
    for (int i = 0; i < rows; i++) {
    myArray[i] = calloc(cols, sizeof(int));
    if (myArray[i] == NULL) {
      printf("FATAL ERROR: out of memory: %s\n", strerror(errno));
      exit(EXIT_FAILURE);
    }
    }

    return myArray;
}

void fillArray(char** myArray, int rows, int cols) {

    int cnt =0;
    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            cnt++;
            myArray[i][j] = '#';
            if(j==0)
            myArray[i][j] = i+'1';
            if(j==1)
            myArray[i][j] = '|';
        }
    }
  return;
}

void printArray(char** myArray, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
    printf("%c ", myArray[i][j]);
    }
    printf("\n");
    }
}

void deleteArray(char** myArray, int rows) {
    for (int i = 0; i < rows; i++) {
    free(myArray[i]);
    }
    free(myArray);
    return;
}

