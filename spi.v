module spi_state(
input wire clk,  //System clock
input wire reset, //Asynchronous system reset
input wire [15:0] datain,  //Binary input vector
output wire spi_cs_L, //SPI Active-Low chip select
output wire spi_sclk, //SPI bus clock
output wire spi_data, //SPI bus data
output [4:0]counter
);
//reg dclk
reg [15:0] MOSI;
reg [4:0] count;
reg cs_L;
reg sclk;
reg [2:0] state;

always @(posedge clk or posedge reset)
if (reset)
begin 
MOSI <= 16'b0;
count <= 5'd16;
cs_L <= 1'b1;
sclk <= 1'b0;
end

else begin
case (state)
0:begin
sclk <= 1'b0;
cs_L <= 1'b1;
state <= 1;
end

1:begin
sclk <= 1'b0;
cs_L <= 1'b0;
MOSI <= datain[count-1];
count <= count-1;
state <= 2;
end

2:begin
sclk <= 1'b1;
if(count>0)
state <= 1;
else begin
count <= 16;
state <= 0;
end
end

default:state<=0;

endcase
end
assign spi_cs_L = cs_L;
assign spi_sclk = sclk;
assign spi_data = MOSI;
assign counter = count;
endmodule
