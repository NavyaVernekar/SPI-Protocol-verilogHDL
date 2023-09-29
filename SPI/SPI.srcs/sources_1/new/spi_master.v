`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2023 22:02:21
// Design Name: 
// Module Name: spi_master
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


module spi_master(clk,rst,input_data,MISO,MOSI,spi_cs,spi_sclk,counter,data_out_mosi,data_out_miso);
input clk,rst,MISO;
input [15:0] input_data;
output spi_cs,spi_sclk,MOSI;
output [15:0] data_out_mosi;
output [4:0] counter;
output [15:0] data_out_miso;

reg mosi;
reg [4:0] count;
reg [4:0] count1;
reg cs;
reg sclk;
reg [2:0] state;
reg [15:0] mem;
reg [15:0] mem1;

always @(posedge spi_sclk or spi_cs) begin
if(spi_cs)
   begin mem <= 16'b0;
         mem1 <= 16'b0;
         count1 <= 16'd16; 
         end
else begin
    mem[count1] = MOSI;
    mem1[16 - count1] = MISO;
    count1 = count1 -1;
    
    end
end
always @(posedge clk or posedge rst)
if(rst) begin
    mosi <= 0;
    count <= 5'd16;
    cs <= 1'b1;
    sclk <= 1'b0;
  end
else begin
    case(state)
    0: begin
        sclk <= 1'b0;
        cs <= 1'b1;
        state <= 1;
       end
    1: begin
        sclk <= 1'b0;
        cs <= 1'b0;
        mosi <= input_data[count -1 ];
        count <= count -1;
        state <= 2;
       end
   2: begin
        sclk <= 1'b1;
        if(count > 0)
            state <=1 ;
        else begin
            count <= 16;
            state <= 0;
            end
      end
   default: state <=0;
   endcase
end

assign spi_cs = cs;
assign spi_sclk = sclk;
assign MOSI = mosi;
assign counter = count;
assign data_out_mosi = mem;
assign data_out_miso = mem1;

 

endmodule
