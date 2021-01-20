// testcases.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <stdio.h>
using namespace std;

//generate a set of 16 bytes, or 8 pixels 
int frame;
int column;
int row;
int pixel;

int href;
int vsync;

double t_pixel = 40;
double t_line = t_pixel * 784;

/*
timing: pclk = 24Mhz, T = 40ns

*/

char test_bytes[][15] = { "00001111", "11110000", "11100010", "11110100", "00110110", "10101010", "00000001", "00001001", "10000100", "01101110", "10000000", "00001111", "11100010", "11110000", "11110100" };


void initialize() {
    cout << "@(negedge pclk);" << endl << "\t href = 0;" << endl; //href low, active high
    cout << "\t vsync = 0;" << endl; //vsync low, active high
    cout << "@(negedge pclk);" << endl << "\t hsync = 1;" << endl; //hsync high, active low
}

void printrow() {
    int local_count = 0;
    int i = 0;
    
    for (local_count; local_count < 640; local_count++) {

        cout << "@negedge (pclk);" << endl; //data transmission synchronous to pixel clock
        if (local_count == 0) cout << "\t href = 1" << endl; //on start of transmission assert href
        cout << "\t dout_camera <= 8'b" << test_bytes[i] << ";" << endl; 
        i++;
        if (i == 15) i = 0;
        else i = i;
        if(local_count == 639) cout << "@(negedge pclk);" << endl << "\t href = 0" << endl; //bring href low on last byte
    }
}

int main()
{
    initialize();
    for (frame = 0; frame < 2; frame++) { //generate two whole frames

        cout << "@(negedge pclk);" << endl << "\t vsync = 1;" << endl; //assert vsync 
        cout << "#" << 3*t_line << ";" << endl; //3 * tline = 3 * (784*40) = 31360
        cout << "\t vsync = 0;" << endl; //deassert vsync

        cout << "#" << 17*t_line - 19*t_pixel << ";" << endl; // 17 * tline - 19 * tpixel 

        cout << "\t hsync = 0;" << endl; //deassert hsync
        cout << "#" << 80*t_pixel << ";" << endl; //hold for 80 * tpixel = 3200 
        cout << "\t hsync = 1;" << endl; //assert hsync

        cout << "#" <<19 * t_pixel << ";" << endl; // 19 * tpixel until href will go high
        cout << "\t href = 1;" << endl; //assert href
 
        //href is high, send row data
        for (column = 0; column < 2; column++) { //generate 6 rows per frame (should be 480 irl)
            printrow(); //printrow sends one row of data
            cout << "#" << 19 * t_pixel << ";" << endl;
            cout << "\t hsync = 0;" << endl; //deassert hsync
            cout << "#" << 80 * t_pixel << ";" << endl; //hold for 80 tp
            cout << "\t hsync = 0;" << endl; //assert hsync
        }      
    }
}


