`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:37 11/18/2016 
// Design Name: 
// Module Name:    explode 
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
module explode(
    input clock,
    input reset,
    input explode_timer,
	 input explode_strike,
    output reg game_over
    );
always @(posedge clock) begin
	if(reset) game_over <= 0;
	if (explode_timer || explode_strike) game_over <= 1;
end

endmodule
