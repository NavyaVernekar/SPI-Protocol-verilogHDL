`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2023 10:24:28
// Design Name: 
// Module Name: spi_state
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


module spi(
input clk,rst,
input [15:0] datain,
output spi_cs_1,spi_sclk,
output MOSI,
output [4:0] counter,
output [15:0] dataout,
output MISO,
output [15:0] mem
);

reg  data;
reg [4:0] count;
reg [4:0] count1;
reg cs_1;
reg sclk;
reg [2:0] state;

reg [15:0] mem;

spi_slave s1 (spi_cs_1,spi_sclk,MOSI,MISO,dataout);

always @(posedge spi_sclk or spi_cs_1) begin
if(spi_cs_1)
   begin mem <= 16'b0;
         count1 <= 16'd0; end
else begin
    mem[count] = MISO;
    count1 = count1 +1;
    end
end
    
always @(posedge clk or rst) 
if(rst) begin
    data <= 1'b0;
    count <= 5'd16;
    cs_1 <= 1'b1;
    sclk <= 1'b0;
  end
else begin
    case(state)
    0: begin
    sclk <= 1'b0;
    cs_1 <= 1'b1;
    state <=1;
    end
    
    1: begin
    sclk <=1'b0;
    cs_1 <= 1'b0;
    data <= datain[count-1];
    count <= count-1;
    state <= 2;
    end
    
    2: begin
    sclk <= 1'b1;
    if(count>0)
        state <=1;
    else begin
        count <= 16;
        state <= 0;
       end
    end
    
    default: state <= 0;
    
    endcase
   end
assign spi_cs_1 = cs_1;
assign spi_sclk = sclk;
assign MOSI = data;
assign counter = count; 
endmodule

module spi_slave(spi_cs_1,spi_sclk,MOSI,MISO,dataout);
input spi_cs_1,spi_sclk,MOSI;
output [15:0] dataout;
output MISO;
reg [15:0] mem;
reg [15:0] mem1;
reg [3:0] count;
reg [3:0] count1;
reg data;

always @(posedge spi_sclk or spi_cs_1) begin
if(spi_cs_1)
   begin mem <= 16'b0;
         count <= 16'd16; 
         end
else begin
    mem[count] = MOSI;
    count = count -1;
    if(count ==16'd0)
        mem1=mem;
    end
    
end
always @(posedge spi_sclk or spi_cs_1) begin
if(spi_cs_1)
   begin mem1 <= 16'b0;
         count1 <= 16'd0; end

else  begin
    data=mem1[count1];
    count1 = count1 +1;
    end
end
assign dataout=mem;
assign MISO=data;
endmodule