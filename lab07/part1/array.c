#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

int main(int argc, char *argv[])
{


    uint32_t array1[3][5]; // 2D array
    uint32_t array2[3][5][7];  // 3D array
    int len, wide, hyte;
    len = 3;
    wide = 5;
    hyte = 7;

    printf("\n2-D array addresses in order \n \n");
    for (int i = 0; i < len; i++)
        {
        for (int j = 0; j < wide; j++)
            {

                    printf("array1[%i][%i] address->  %p \n",i,j, &array1[i][j]);

            }
        }
    printf("\n \n3-D array addresses in order \n \n");
    for (int i = 0; i < len; i++)
        {
        for (int j = 0; j < wide; j++)
            {
           for (int h = 0; h < hyte; h++)
                {
                    printf("array2[%i][%i][%i] address->  %p \n",i,j,h, &array2[i][h][j]);
                }
            }
        }

  return 0;
}
