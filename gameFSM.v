`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:19 11/18/2016 
// Design Name: 
// Module Name:    gameFSM 
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
module gameFSM(
    input clock, //game clock 27mhz
    input reset, //game reset
    output begin_timer, //to countdown timer module
    output begin_setup, //to bomb-logic module
    output [0:0] visuals, //to visuals block!
    input setup_complete, //from bomb logic?
    input game_won, //from bomb-logic
    input game_lost //from explode module
    );

//states
parameter WAITING = 			3'b000;
parameter START_GAME = 		3'b001;
parameter PLAYING_GAME = 	3'b010;
parameter GAME_WON = 	 	3'b011;
parameter GAME_LOST = 		3'b100;


always @ (posedge clock) begin
end

endmodule
