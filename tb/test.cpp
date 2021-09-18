#include <iostream>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>

// gcc test.cpp -o test.exe -lstdc++

int main()
{   
	
	

    /* generate inputs and expected results */
    int RowLength = 12;
	int Rows = 4;
	

	int i,j,k,x,y,z;

    int imgData[4][12];
    int result [4][12];

    
    std::cout << "here!\n";
    
    int kernel[3][3] = {{1,2,1},
	                    {2,4,2},
	                    {1,2,1}};

	int kernelX, kernelY;
	int temp;

	


	for(i=0; i<Rows; i++) {
		for(j=0; j<RowLength; j++) {
			temp = 0;
		/* IMAGE CORNERS */
			// top left of image
			if(i==0 && j==0) {
				temp = 0;
				temp += kernel[0][0]*imgData[0][0]; 
				temp += kernel[0][1]*imgData[0][0];
				temp += kernel[0][2]*imgData[0][1];
				//
				temp += kernel[1][0]*imgData[0][0];
				temp += kernel[1][1]*imgData[0][0];
				temp += kernel[1][2]*imgData[0][1];
				//
				temp += kernel[2][0]*imgData[1][0];
				temp += kernel[2][1]*imgData[1][0];
				temp += kernel[2][2]*imgData[1][1];
				//
				result[i][j] = temp/16;
			}

			// bottom left of image
			else if(i==Rows-1 && j==0) {
				temp    = 0;
				kernelY = 0;
				kernelX = 0;
				for(y=i-1; y<i+2; y++){
					for(kernelX=0; kernelX<3; kernelX++) {
						temp += kernel[kernelY][kernelX]*imgData[y][0]; 
						temp += kernel[kernelY][kernelX]*imgData[y][0];
						temp += kernel[kernelY][kernelX]*imgData[y][1];
					}
					kernelY++;
				}
				result[i][j] = temp/16;
			}

			// top right of image
			else if(i==0 && j==RowLength-1) {
				temp = 0;
				temp += kernel[0][0]*imgData[0][j-1]; 
				temp += kernel[0][1]*imgData[0][j];
				temp += kernel[0][2]*imgData[0][j];
				//
				temp += kernel[1][0]*imgData[0][j-1];
				temp += kernel[1][1]*imgData[0][j];
				temp += kernel[1][2]*imgData[0][j];
				//
				temp += kernel[2][0]*imgData[1][j-1];
				temp += kernel[2][1]*imgData[1][j];
				temp += kernel[2][2]*imgData[1][j];
				//
				result[i][j] = temp/16;
			}

			// bottom right of image
			else if(i==Rows-1 && j==RowLength-1) {
				temp = 0;
				temp += kernel[0][0]*imgData[i-1][j-1]; 
				temp += kernel[0][1]*imgData[i-1][j];
				temp += kernel[0][2]*imgData[i-1][j];
				//
				temp += kernel[1][0]*imgData[i][j-1];
				temp += kernel[1][1]*imgData[i][j];
				temp += kernel[1][2]*imgData[i][j];
				//
				temp += kernel[2][0]*imgData[i][j-1];
				temp += kernel[2][1]*imgData[i][j];
				temp += kernel[2][2]*imgData[i][j];
				//
				result[i][j] = temp/16;
			}

		/* IMAGE EDGES */
			// top edge of image
			else if(i==0) {
				temp = 0;
				temp += kernel[0][0]*imgData[i][j-1]; 
				temp += kernel[0][1]*imgData[i][j];
				temp += kernel[0][2]*imgData[i][j+1];
				//
				temp += kernel[1][0]*imgData[i][j-1];
				temp += kernel[1][1]*imgData[i][j];
				temp += kernel[1][2]*imgData[i][j+1];
				//
				temp += kernel[2][0]*imgData[i+1][j-1];
				temp += kernel[2][1]*imgData[i+1][j];
				temp += kernel[2][2]*imgData[i+1][j+1];
				//
				result[i][j] = temp/16;
			}

			// bottom edge of image
			else if(i==Rows-1) {
				temp = 0;
				temp += kernel[0][0]*imgData[i-1][j-1]; 
				temp += kernel[0][1]*imgData[i-1][j];
				temp += kernel[0][2]*imgData[i-1][j+1];
				//
				temp += kernel[1][0]*imgData[i][j-1];
				temp += kernel[1][1]*imgData[i][j];
				temp += kernel[1][2]*imgData[i][j+1];
				//
				temp += kernel[2][0]*imgData[i][j-1];
				temp += kernel[2][1]*imgData[i][j];
				temp += kernel[2][2]*imgData[i][j+1];
				//
				result[i][j] = temp/16;
			}

			// right edge of image
			else if(j==RowLength-1) {
				temp = 0;
				temp += kernel[0][0]*imgData[i-1][j-1]; 
				temp += kernel[0][1]*imgData[i-1][j];
				temp += kernel[0][2]*imgData[i-1][j];
				//
				temp += kernel[1][0]*imgData[i][j-1];
				temp += kernel[1][1]*imgData[i][j];
				temp += kernel[1][2]*imgData[i][j];
				//
				temp += kernel[2][0]*imgData[i+1][j-1];
				temp += kernel[2][1]*imgData[i+1][j];
				temp += kernel[2][2]*imgData[i+1][j];
				//
				result[i][j] = temp/16;
			}

			// left edge of image 
			else if(j==0) {
				temp = 0;
				temp += kernel[0][0]*imgData[i-1][j]; 
				temp += kernel[0][1]*imgData[i-1][j];
				temp += kernel[0][2]*imgData[i-1][j+1];
				//
				temp += kernel[1][0]*imgData[i][j];
				temp += kernel[1][1]*imgData[i][j];
				temp += kernel[1][2]*imgData[i][j+1];
				//
				temp += kernel[2][0]*imgData[i+1][j];
				temp += kernel[2][1]*imgData[i+1][j];
				temp += kernel[2][2]*imgData[i+1][j+1];
				//
				result[i][j] = temp/16;
			}

		/* DEFAULT */
			else {
				temp = 0;
				temp += kernel[0][0]*imgData[i-1][j-1]; 
				temp += kernel[0][1]*imgData[i-1][j  ];
				temp += kernel[0][2]*imgData[i-1][j+1];
				//
				temp += kernel[1][0]*imgData[i  ][j-1];
				temp += kernel[1][1]*imgData[i  ][j  ];
				temp += kernel[1][2]*imgData[i  ][j+1];
				//
				temp += kernel[2][0]*imgData[i+1][j-1];
				temp += kernel[2][1]*imgData[i+1][j  ];
				temp += kernel[2][2]*imgData[i+1][j+1];
				//
				result[i][j] = temp/16;
			}
		}
	}


	std::ofstream InputData;
	InputData.open("inputData.txt");
	while(!InputData.is_open());
	// generate random pixel data
    for(i=0; i<Rows; i++) {
    	for(j=0; j<RowLength; j++) {
    		imgData[i][j] = rand() % 256;
    	}
    }
    for(i=0; i<Rows; i++) {
    	for(j=0; j<RowLength; j++) {
    		InputData << imgData[i][j] << " ";
    	}
    	InputData << "\n";
    }
    InputData.close();

    std::ofstream OutputData;
	OutputData.open("ouputData.txt");
	while(!OutputData.is_open());
	
    for(i=0; i<Rows; i++) {
    	for(j=0; j<RowLength; j++) {
    		OutputData << result[i][j] << " ";
    	}
    	InputData << "\n";
    }
    OutputData.close();


	return 0;
}
