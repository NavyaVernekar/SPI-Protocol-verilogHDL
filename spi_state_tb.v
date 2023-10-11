`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2023 10:37:56
// Design Name: 
// Module Name: spi_state_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi_tb();
reg clk,rst;
reg [15:0] datain;
reg MISO;
wire spi_cs,spi_sclk;
wire  MOSI;
wire [4:0] counter;
wire [15:0] dataout_mosi;
wire [15:0] dataout_miso;
reg  [15:0] data;




spi_master dut (clk,rst,datain,MISO,MOSI,spi_cs,spi_sclk,counter,dataout_mosi,dataout_miso);

initial begin
    clk = 0;
    rst = 1;
    datain = 0;
    end
    
always #5 clk=~clk;

initial begin
#10 rst=1'b0;
#10 datain=16'hA569; 
#335 datain=16'h2563;
#335 datain=16'h6A61;
#335 datain=16'h7635;
#335 datain=16'hB614;
#500 $stop;
end

initial begin
data = 16'hA569;
#15 repeat (16) begin
    #20 MISO = data[0];
    data = data >>1;
    end
 #15 
data = 16'h2563;
   repeat (16) begin
        #20 MISO = data[0];
        data = data >>1;
        end

data = 16'h6A61;
      repeat (16) begin
            #20 MISO = data[0];
            data = data >>1;
            end
  #15 
data = 16'h7635;
          repeat (16) begin
                #20 MISO = data[0];
                data = data >>1;
                end
  #15 ;
end

endmodule
