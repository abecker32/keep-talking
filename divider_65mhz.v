`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:14:26 12/01/2016 
// Design Name: 
// Module Name:    divider_65mhz 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module divider_65mhz(
    input clock, //gets 65MHz clock
    input reset,
    input begin_timer,
    output one_hz_enable,
	output four_hz_enable //4 times per second
    );
    
reg [25:0] counter = 0; //26 bits counts to 65,000,000
    
always @ (posedge clock) begin
    if (reset) counter <= 0;
    if (begin_timer) counter <= 0;
    if (counter == 26'd65_000_000) counter <= 0;
    else counter <= counter + 1;
end

assign one_hz_enable = (counter == 26'd65_000_000);
assign four_hz_enable = ((counter == 26'd65_000_000) || (counter == 26'd48_750_000) ||
	(counter == 26'd32_500_000) || (counter == 26'd16_250_000));

endmodule