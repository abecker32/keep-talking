`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:21:58 11/11/2016 
// Design Name: 
// Module Name:    bomb_logic 
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
module bomb_logic(
    input clock, //27mhz clock
	 input reset, //overall reset
	 input begin_setup, //from game FSM
	 input module_visuals, //from each module, which version
	 input module_defused, //from each module
	 output game_won, //to game FSM
	 output set_up_complete, //to game FSM
	 output [32:0] visuals, //6 modules x module version x module state
	 output enable, //bus one for each module
	 output accum_enable
	 );


endmodule
