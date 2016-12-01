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
	 input start_game, //when the user wants to play
    input setup_complete, //from user input
    input game_won, //from bomb-logic
    input game_lost, //from explode module
    output reg begin_timer, //to countdown timer module
    output reg begin_setup, //to bomb-logic module
    output reg [2:0] state //for debugging and to visuals block!
    );

//states
parameter WAITING = 			3'b000;
parameter START_GAME = 		3'b001;
parameter PLAYING_GAME = 	3'b100; //bit 3 is for the "visuals" cue
parameter GAME_WON = 	 	3'b010;
parameter GAME_LOST = 		3'b011;


always @ (posedge clock) begin
	if (reset) begin
		state = WAITING;
		begin_timer = 0; //dont start countdown timer
		begin_setup = 0; //dont start setup yet
	end
	case (state)
		WAITING:begin //display "want to play?"
			begin_timer <= 0;
			begin_setup <= 0;
			if (start_game) begin
				state <= START_GAME;
				begin_setup <= 1; //to cue bomb_logic module
			end
		end
		
		START_GAME:begin //display "set up bomb" it will always require same 
			begin_timer <= 0;
			begin_setup <= 0;
			if (setup_complete) begin
				state <= PLAYING_GAME;
				begin_timer <= 1; //starts countdown timer
			end
		end
		
		PLAYING_GAME:begin
			begin_timer <= 0;
			begin_setup <= 0;
			//use visuals directly from module
			if (game_lost) state <= GAME_LOST;
			if (game_won) state <= GAME_WON;
		end
		
		GAME_WON:begin //displays "game won, want to play again?"
			begin_timer <= 0;
			begin_setup <= 0;
			if (start_game) begin
				state <= START_GAME;
				begin_setup <= 1; //to cue bomb_logic module
			end
		end
		
		GAME_LOST:begin //displays "game lost, want to play again?"
			begin_timer <= 0;
			begin_setup <= 0;
			if (start_game) begin
				state <= START_GAME;
				begin_setup <= 1; //to cue bomb_logic module
			end
		end
		
		default: state <= WAITING;
	endcase
	
	
	
	
end

endmodule
