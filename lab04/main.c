/// This is a crossword puzzle program
//By: Steve Guerrero
//email: s_guerrero1@u.pacific.edu

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "functions.h"

///function declarations
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

    // function calls for crossword array
    myArray = createArray(ROWS, COLS);
    fillArray(myArray, ROWS, COLS);

    /// reading in the text file and storing in struct params
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

    /// prints top of puzzle

    printf("CURRENT PUZZLE: \n \n");

    for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 7; j++)
    printf("%c ", numArray[i][j]);
    printf("\n");
    }

    // prints crossword array
    printArray(myArray, ROWS, COLS);


    printf("\n Unsolved Clues: \n");
    printf("-------------------- \n");
    printf("#       Direction      Row/Col      Clues: \n");

    // prints structure parameters
    int c_num = 6;
    for (int j=0;j<c_num;j++)
    {
        printf("%i          %c           %i/%i       %.40s\n",j+1,clue[j].orient, clue[j].row, clue[j].col, clue[j].clues);

    }
    int sel;
    char ans[30];
    int clue_num =50;
    int dun=0;
    while(clue_num!=0)
    {

    printf("\nPlease enter a clue to solve, or -1 to exit: ");
    scanf("%d", &sel );

    if(sel==-1)
        return 1;
      /* local variable definition */
    if(dun==6){
        printf("\n You've completed the puzzle.\n");
        return EXIT_SUCCESS;
    }

    // user input and updated crossword array

   switch(sel) {
        case 1 :
        printf("Enter your answer for Clue 1!\n" );
        scanf("%s",&ans);

        if(!strcmp(ans,"baa")||!strcmp(ans,"Baa")||!strcmp(ans,"BAA")){
            myArray[0][2] = 'B';
            myArray[0][3] = 'A';
            myArray[0][4] = 'A';
            dun++;
            printArray(myArray, ROWS, COLS);
        }
        else
        printf("Try Again. \n");
         break;
        case 2 :
        printf("Enter your answer for Clue 2!\n" );
        scanf("%s",&ans);

        if(!strcmp(ans,"solid")||!strcmp(ans,"Solid")||!strcmp(ans,"SOLID")){
            myArray[2][2] = 'S';
            myArray[2][3] = 'O';
            myArray[2][4] = 'L';
            myArray[2][5] = 'I';
            myArray[2][6] = 'D';
            dun++;
            printArray(myArray, ROWS, COLS);
        }
        else
        printf("Try Again. \n");
         break;
        case 3 :
             printf("Enter your answer for Clue 3!\n" );
        scanf("%s",&ans);

        if(!strcmp(ans,"wit")||!strcmp(ans,"Wit")||!strcmp(ans,"WIT")){
            myArray[4][4] = 'W';
            myArray[4][5] = 'I';
            myArray[4][6] = 'T';
            dun++;
            printArray(myArray, ROWS, COLS);
        }
        else
        printf("Try Again. \n");
        break;
        case 4 :
        printf("Enter your answer for Clue 4!\n" );
        scanf("%s",&ans);

        if(!strcmp(ans,"bus")||!strcmp(ans,"Bus")||!strcmp(ans,"BUS")){
            myArray[0][2] = 'B';
            myArray[1][2] = 'U';
            myArray[2][2] = 'S';
            dun++;
            printArray(myArray, ROWS, COLS);
        }
        else
        printf("Try Again. \n");
        break;
        case 5 :
        printf("Enter your answer for Clue 5!\n" );
        scanf("%s",&ans);

        if(!strcmp(ans,"allow")||!strcmp(ans,"Allow")||!strcmp(ans,"ALLOW")){
            myArray[0][4] = 'A';
            myArray[1][4] = 'L';
            myArray[2][4] = 'L';
            myArray[3][4] = 'O';
            myArray[4][4] = 'W';
            dun++;
            printArray(myArray, ROWS, COLS);
        }
        else
        printf("Try Again. \n");
        break;
        case 6 :
        printf("Enter your answer for Clue 6!\n" );
        scanf("%s",&ans);

        if(!strcmp(ans,"dot")||!strcmp(ans,"Dot")||!strcmp(ans,"DOT")){
            myArray[2][6] = 'D';
            myArray[3][6] = 'O';
            myArray[4][6] = 'T';
            dun++;
            printArray(myArray, ROWS, COLS);
        }
        else
        printf("Try Again. \n");
        break;
        default :
         printf("Invalid input, choose from selected clues \n");
         break;
        }
        printf("\n");
         printf("#       Direction      Row/Col      Clues: \n");
      for (int j=0;j<c_num;j++)
    {
        printf("%i          %c           %i/%i       %.40s\n",j+1,clue[j].orient, clue[j].row, clue[j].col, clue[j].clues);

    }
    clue_num --;
    }
    deleteArray(myArray, ROWS);
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

    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {

            myArray[i][j] = '#';
            if(i==0&&j<5)
                myArray[i][j] = '_';
            if(i==1)
                myArray[i][2] = '_';
                myArray[i][4] = '_';
            if(i==2)
                myArray[i][j] = '_';
            if(i==3)
                myArray[i][4] = '_';
                myArray[i][6] = '_';
            if(i==4&&j>3)
                myArray[i][j] = '_';
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

