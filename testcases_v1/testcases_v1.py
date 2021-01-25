#fh = open('testbenchcode.txt','w')
import sys


# testcase data
testcases = [ "8'b00001111", "8'b11110000", "8'b11100010", "8'b11110100", "8'b00110110", "8'b10101010", "8'b00000001", "8'b00001001", "8'b10000100", "8'b01101110", "8'b10000000", "8'b00001111", "8'b11100010", "8'b11110000", "8'b11110100", "8'b10101011"]

print('Enter the number of frames to generate.')
frames = input()
frames = int(frames)
print('Enter the desired vertical resolution in rows of pixels.')
rows = input()
rows = int(rows)
print('Generating code for 640 x',rows,'resolution. Output can be found in testbenchcode.txt.')

sys.stdout=open("testbenchcode.txt", "w")

print('// This testbench models VGA timing from OV7670 for',frames,'frames of 640 x',rows)

print("initial begin") # initial stuff 
print("\t clk = 0;")
print("\t href = 0;")
print("\t dout_camera = 8'b0;")
print("\t reset_n = 1;") 
print("#100;") # Xilinx recommends only applying stimulus 100ns after simulation time zero
print("\t reset_n = 0;")
print("#120;") # reset is held for two clocks
print("\t reset_n = 1;") 
print("#360;")
print("\t vsync = 0;")
print("\t hsync = 1;")



print("@(negedge pclk);", "\n" , "\t href = 0;" ) # href low, active high
print("\t", "vsync = 0;") # vsync low, active high
print("@(negedge pclk)", "\n", "\t hsync = 1;") # hsync high, active low

for frame_count in range(frames):

    print("@(negedge pclk);", "\n" , "\t vsync = 1 ;") # assert vsync
    print("#31360;") # hold it
    print("\t vsync = 0;") # deassert vsync
    print("#532360;")

    print("\t hsync = 0;") # deassert hsync 
    print("#3200;") # hold it
    print("\t hsync = 1;") # assert hsync

    print("#760;") 

    for row_count in range (rows): 
        
        for byte_count in range (79): # send a row of data
            # each row is always 640 pixels, or 1280 bytes. 1280 / 16 potential cases = 80

            if(byte_count == 0): # bring href high at start of data transmission
                print("\t",'href = 1;')

            for data_count in range (15): #send all data
                 print("@(negedge pclk);")
                 print("\t", "dout_camera <= ",testcases[data_count],";")

            if(row_count == (rows-1)): # bring href low again at the end
                print("\t",'href = 0;')
            
        print("#760;") 
        print("\t hsync = 0;")
        print("#3200;")
        print("\t hsync =  1;")    

print("end")
print("endmodule")
sys.stdout.close()

#

#fh.write('hello world!')

#fh.close()