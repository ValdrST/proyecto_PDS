#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <math.h>
#include "fdacoefs.h"

int main()
{
    // Sacar el calculo de las cascadas
    double fsec = (double)MWSPT_NSEC;
    int num_cascada = (int)(fsec+1)/2;
    int nsec = (int)fsec;

    printf("%d %d\n",num_cascada, nsec);
    FILE *file;
    if (!(file = fopen("xne4.txt", "r"))) {
        fprintf(stderr, "Can't open the file.\n");
        return 1;
    }
    FILE *file1;
    if (!(file1 = fopen("yn.txt", "w"))) {
        fprintf(stderr, "Can't open the file.\n");
        return 1;
    }
    double xn, yn = 0.0;
    double kd = 1;
    double b[num_cascada][3];
    double a[num_cascada][3];
    double  yn_k[num_cascada][3];
    double  wn_k[num_cascada][3]; 
    int c = 0;
    int i = 0;
    int j = 0;
    int i2 = 0;
    // Poblar los coeficientes b y a
    printf("kd=");
    for (c = 0; c < nsec; c++)
    {
        if (c % 2 != 0)
        {
            for (i2 = 0; i2 < 3; i2++)
            {
                b[j][i2] = NUM[c][i2];
            }
            for (i2 = 0; i2 < 3; i2++)
            {
                a[j][i2] = DEN[c][i2];
            }
            j++;
        }else{
            kd *= NUM[c][0];
            printf("(%lf)",NUM[c][0]);
            
        }
    }
    printf("\n");
    printf("kd=%lf\n",kd);
    while (!(feof(file)))
    {
        fscanf(file, "%lf\n", &xn);
        for(i=0;i<num_cascada-1;i++){
            // Forma II
            if(i==0){
                wn_k[i][0] = a[i][0]*xn - a[i][1] * wn_k[i][1] - a[i][2] * wn_k[i][2];
            }
            else
                wn_k[i][0] = a[i][0]*yn_k[i][0] - a[i][1] * wn_k[i][1] - a[i][2] * wn_k[i][2];
            yn_k[i][0] = b[i][0] * wn_k[i][0] + b[i][1] * wn_k[i][1] + b[i][2] * wn_k[i][2];

            yn_k[i][2] = yn_k[i][1];
            yn_k[i][1] = yn_k[i][0];
            wn_k[i][2] = wn_k[i][1];
            wn_k[i][1] = wn_k[i][0];
            if(i < num_cascada-2){
                yn_k[i+1][0] = yn_k[i][0]; // yn+1 = yn
            }else{
                yn_k[num_cascada][0] = yn_k[i][0];   
            }
        }
        //printf("%f\n",yn_k[5][0]);
        yn = kd * yn_k[num_cascada][0];
        //printf("yn=%lf * [%d]%lf =%lf\n",kd,num_cascada, yn_k[num_cascada][0],yn);
        fprintf(file1, "%lf\n", yn);
    }
    fclose(file);
    fclose(file1);
    return 0;
}