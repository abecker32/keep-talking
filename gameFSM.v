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
    input clock, //game clock 65mhz
    input reset, //game reset
	input start_game, //when the user wants to play
    input setup_complete, //from user input
    input game_won, //from bomb-logic
    input game_lost, //from explode module
	input [3*8-1:0] ascii_timer, //ascii 
    output reg begin_timer, //to countdown timer module
    output reg begin_setup, //to bomb-logic module
    output reg [2:0] state = 0, //for debugging and to visuals block!
	output reg [16*8-1:0] string_data, //string data
	output reg enable //to enable the modules
    );

//states
parameter WAITING = 		3'b000;
parameter START_GAME = 		3'b001;
parameter PLAYING_GAME = 	3'b100; //bit 3 is for the "visuals" cue
parameter GAME_WON = 	 	3'b010;
parameter GAME_LOST = 		3'b011;

reg [3:0] button_check;

always @ (posedge clock) begin
	button_check <= {start_game, setup_complete, game_won, game_lost};
	if (reset) begin
		state <= WAITING;
		begin_timer <= 0; //dont start countdown timer
		begin_setup <= 0; //dont start setup yet
		enable <= 0;
	end
	case (state)
		WAITING:begin //display "want to play?"
			enable <= 0;
			begin_timer <= 0;
			begin_setup <= 0;
			string_data <= {"  Want to play?  "};
			if (button_check == 4'b1000) begin
				state <= START_GAME;
				begin_setup <= 1; //to cue bomb_logic module
			end
		end
		
		START_GAME:begin //display "set up bomb" it will always require same 
			enable <= 0;
			begin_timer <= 0;
			begin_setup <= 0;
			string_data <= {" set up the bomb"};
			if (button_check == 4'b0100) begin
				state <= PLAYING_GAME;
				begin_timer <= 1; //starts countdown timer
			end
		end
		
		PLAYING_GAME:begin
			enable <= 1;
			begin_timer <= 0;
			begin_setup <= 0;
			string_data <= {"T to defuse ",ascii_timer[23:16], ":", ascii_timer[15:0]};
			//use visuals directly from module
			if (button_check == 4'b0001) state <= GAME_LOST;
			else if (button_check == 4'b0010) state <= GAME_WON;
		end
		
		GAME_WON:begin //displays "game won, want to play again?"
			enable <= 0; //game is over, this should stop modules
			begin_timer <= 0;
			begin_setup <= 0;
			string_data <= {"  game won!! :) "};
			if (button_check == 4'b1000) begin
				state <= START_GAME;
				begin_setup <= 1; //to cue bomb_logic module
			end
		end
		
		GAME_LOST:begin //displays "game lost, want to play again?"
			enable <= 0; //game is over, this should stop modules
			begin_timer <= 0;
			begin_setup <= 0;
			string_data <= {"  game lost :(  "};
			if (button_check == 4'b1000) begin
				state <= START_GAME;
				begin_setup <= 1; //to cue bomb_logic module
			end
		end
		
		default: state <= WAITING;
	endcase
	
end


endmodule
