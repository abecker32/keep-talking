`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
//
//  1  2  3  (2)             1 = (3) & (2)  ||  2 = (1) & (2)  ||  3 = (5) & (2)
//  4  5  6  (7)             4 = (3) & (7)  ||  5 = (1) & (7)  ||  6 = (5) & (7)
//  7  8  9  (6)             7 = (3) & (6)  ||  8 = (1) & (6)  ||  9 = (5) & (6)
//  *  0  #  (4)             * = (3) & (4)  ||  0 = (1) & (4)  ||  # = (5) & (4)
// (3)(1)(5)
//
//
//  The idea behind this module is to sequentially assert pins (1), (3), and (5).
//  As shown above, when a certain key is pressed, the two pins associated with 
//  it then have the same voltage. For example, when key 1 is pressed, pins (3) 
//  and (2) will now have the same voltage.
//
//  So, with this idea, we assert in an orderly fashion, pins (1), (3), and (5), 
//  and we proceed to check pins (2), (7), (6), and (4) to see whether or not
//  certain keys were pressed.
//
/////////////////////////////////////////////////////////////////////////////

module keypad(
	input clock_65mhz, //keeps everything clocked at 27MHz
	input reset, //global reset input
	input enable, //enable bit
    input [3:0] user_in, // 2,4,6,7
    output reg strike,
	output reg module_defused,
	output [2:0] user_out
    );

    // States for iterating through pins 1,3,5
    parameter PINONE = 3'b100;
    parameter PINTHREE = 3'b010;
    parameter PINFIVE = 3'b001;

    parameter START = 3'b000;
    parameter FIRST = 3'b001;
    parameter SECOND = 3'b010;
    parameter THIRD = 3'b011;
    parameter FOURTH = 3'b100;
    parameter FIFTH = 3'b101;
    parameter SIXTH = 3'b110;
    parameter DONE = 3'b111;

    reg [1:0] states_out;
    reg [11:0] keys;
    reg [2:0] keys_states;
    assign user_out = states_out;

    always @(posedge clock_65mhz) begin
    	if (reset) begin
    		strike <= 0;
    		module_defused <= 0;
    		states_out <= PINONE;
    		keys_states <= START;
    	end
    	else if (enable) begin
    		case (states_out)

    			PINONE: begin
    				keys[3:0] = {user_in[4],user_in[6],user_in[7],user_in[2]};
    				states_out <= PINTHREE;
    			end

    			PINTHREE: begin
    				keys[7:4] = {user_in[4],user_in[6],user_in[7],user_in[2]};
    				states_out <= PINFIVE;
    			end

    			PINFIVE: begin
    				keys[11:8] = {user_in[4],user_in[6],user_in[7],user_in[2]};
    				states_out <= PINONE;
    			end

    			default: begin
    				states_out <= PINONE;
    			end

    		endcase
    		case (keys_states)
    			START: begin
    				strike <= 0;
    				if (keys[11]) begin
    					keys_states <= FIRST;
					end
				end

    			FIRST: begin
    				if (keys[0]) keys_states <= SECOND;
    				else if (|keys) begin
    					keys_states <= START;
    					strike <= 1;
    				end
				end

    			SECOND: begin
    				if (keys[9]) keys_states <= THIRD;
    				else if (|keys) begin
    					keys_states <= START;
    					strike <= 1;
    				end
				end

    			THIRD: begin
    				if (keys[6]) keys_states <= FOURTH;
    				else if (|keys) begin
    					keys_states <= START;
    					strike <= 1;
    				end
				end

    			FOURTH: begin
    				if (keys[7]) keys_states <= FIFTH;
    				else if (|keys) begin
    					keys_states <= START;
    					strike <= 1;
    				end
				end

    			FIFTH: begin
    				if (keys[4]) keys_states <= SIXTH;
    				else if (|keys) begin
    					keys_states <= START;
    					strike <= 1;
    				end
    			end

    			SIXTH: begin
    				if (keys[3]) keys_states <= DONE;
    				else if (|keys) begin
    					keys_states <= START;
    					strike <= 1;
    				end
    			end

    			DONE: begin
    				module_defused <= 1;
    				keys_states <= DONE;
    			end

    			default: begin
    				strike <= 0;
    				keys_states <= START;
    			end

    		endcase
    	end
    end

endmodule
