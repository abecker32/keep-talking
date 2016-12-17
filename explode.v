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
	input explode_timer,	// explosion from timer module
	input explode_strike,	//explosion from strikes module
	output reg game_lost = 0 //if the game is lost
	);
	
	always @(posedge clock) begin
		if(reset) game_lost <= 0;
		if (explode_timer || explode_strike) game_lost <= 1;
	end

endmodule
