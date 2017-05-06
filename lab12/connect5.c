#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "connect5.h"
uint32_t m_w = 0;
uint32_t m_z = 0; 
int bord[54];
int main()
{
	printf("Welcome to Connect Four, Five-in-a-Row variant! \nVersion 1.0\nImplemented by Steve Guerrero \n\n");
	printf("Enter two positive numbers to initialize the random number generator.\nNumber 1: ");
	scanf("%d", &m_w);
	printf("\nNumber 2: ");
	scanf("%d", &m_z);
	printf("\nHuman player (H)\nComputer player (C)\n");
	uint32_t flip = random_in_range(1,10);
	printf("Coin flip... ");
	
	if (flip <= 5)
	printf("HUMAN goes first.\n\n");

	else
	printf("COMPUTER goes first.\n\n");
	
	createBoard();
	printBoard();
	
	for(int i = 1; i <= 21; i++) // if board is full, then loop ends
	{
		if(EndGame()!=0)
			{
				break;
			}
		if (flip <= 5)
		{
			human();
			printBoard();
			comp();
			printBoard();
		
		}
		else
		{
			comp();
			printBoard();
			human();
			printBoard();
		}
				
	}


	printf("\nGAME OVER\n");

	return 0;
}

///functions
//get random function returns random number
uint32_t get_random()
{
	m_z = 36969 * (m_z & 65535) + (m_z >> 16);
	m_w = 18000 * (m_w & 65535) + (m_w >> 16);
	return (m_z << 16) + m_w; /* 32-bit result */
}

uint32_t random_in_range(uint32_t low, uint32_t high)
{
  uint32_t range = high-low+1;
  uint32_t rand_num = get_random();

  return (rand_num % range) + low;
}

void createBoard() //creates the board
{
	int s = 53; // s = 53
	int rows = 6; // rows = 6

	for (int k=0; k<s; k++)
	{
		bord[k]=0;
	}
	for (int i=0; i<rows; i++)//everyother side col with H
	{
		bord[i*9]=1;
		bord[i*9+8] =1;
		i++;//add 2 to i = alternations
	}
	for (int j=1; j<rows; j++)//everyother side col with C
	{
		bord[j*9]=2;
		bord[j*9 +8] =2;
		j++;//add 2 to j = alternations
	}
}

void printBoard()//prints out board. Converts integers to characters
{
	int s = 53;
	printf("    1  2  3  4  5  6  7   \n");
	printf("   ---------------------   \n");//top line of the board
	for (int i=0; i<=s; i++)//
	{

		if (bord[i]==0)
		{
			printf(" . ");
		}
		else if (bord[i]==1)
		{
			printf(" C ");
		}
		else if (bord[i]==2)
		{
			printf(" H ");
		}
		if((i+1)%9 == 0)
		{
			printf("\n");
		}

	}
	printf("   ---------------------   \n");// Bottom line of board
}

//Human player 
void human()
{
	int offset;
	printf("What column would you like to drop token into? Enter 1-7: ");
	scanf("%i", &offset);
	while(offset <1 || offset >7)
	{
		printf("\nInvalid input! \n");
		printf("What column would you like to drop token into? Enter 1-7: ");
		scanf("%i", &offset);
	}

	while(bord[offset] != 0)
	{
		printf("Column is full! \nWhat column would you like to drop token into? Enter 1-7: ");
		scanf("%i", &offset);
	}

	int row_num = 5;
	for (row_num =5; row_num >=0; row_num--)
	{
		if(bord[row_num*9+offset] == 0)
		{
			bord[row_num*9+offset] = 2;
			break;
		}
	}
}

// Computer player
void comp()
{
	int offset = random_in_range(1,7);
	while(bord[offset] != 0) // of column is full comp goes again
	{
		offset = random_in_range(1,7);
	}
	printf("Computer player selected column %i \n", offset);
	int row = 5;
	for (row =5; row >=0; row--)
	{
		if(bord[row*9+offset] == 0)
		{
			bord[row*9+offset] = 1;
			break;
		}
	}

}

// traverses array and checks for a winner in each case
int EndGame()
{
	for (int z = 1; z<3; z++) 
	{
		for (int x = 0; x<=53; x++) 
		{
			//check for diagonal win
			// positive slope
			if ((x>=4) && (x!=9) && (x!=10) && (x!=11) &&(x!=12) && (x<=17) && ((bord[x] == z)&&(bord[x+8] == z) &&(bord[x+16] == z)&&(bord[x+24] == z) &&(bord[x+32] == z))) 
			{ 
				if(z==1)
				{
					printf("You Lose, Computer Won Diagonally!\n");
					return z;
				}
				if(z==2)
				{
					printf("Congratulations, Human Won Diagonally!\n");
					return z; 
				}
			} 
			// negative slope
			if (x<=13 && (x!=5) && (x!=6) && (x!=7) && (x!=8) && ((bord[x] == z)&&(bord[x+10] == z) &&(bord[x+20] == z)&&(bord[x+30] == z) &&(bord[x+40] == z))) 
			{
				if(z==1)
				{
					printf("You Lose, Computer Won Diagonally!\n");
					return z;
				}
				if(z==2)
				{
					printf("Congratulations, Human Won Diagonally!\n");
					return z;
				}
			}
			// check for vertical win
			if ((bord[x] == z)&&(bord[x+9] == z) &&(bord[x+18] == z)&&(bord[x+27] == z) &&(bord[x+36] == z)) 
			{
				if(z==1)
				{
					printf("You Lose, Computer Won Vertically!\n");
					return z;
				}
				if(z==2)
				{
					printf("Congratulations, Human Won Vertically!\n");
					return z; 
				}
			}
			// check for horizontal win
			if ((bord[x] == z)&&(bord[x+1] == z) &&(bord[x+2] == z)&&(bord[x+3] == z) &&(bord[x+4] == z)) 
			{  
				if(z==1)
				{
					printf("You Lose, Computer Won Horizontally!\n");
					return z;
				}
				else
				{
					printf("Congratulations, Human Won Horizontally!\n");
					return z;
				}
			}
			
		}
	}
	return 0; 

}
