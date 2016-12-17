`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:21:27 12/05/2016 
// Design Name: 
// Module Name:    button 
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
module button(
	input clock_65mhz, //keeps everything clocked at 65MHz
	input reset, //global reset input
	input enable, //enable bit
	input button_blue,
	input [15:0] bcd,
	input [3:0] rng_output, //the random input
    output reg strike, //high when the module is messed up to strike module
	output reg module_defused, //high when the module is defused
	output reg [1:0] version, //module version A-D for visuals
	output reg rng_enable, //when the module is getting set up
	output reg hold_strike
    );
		 
	//version (2 bit)
	parameter VERSION_A = 2'b00;
	parameter VERSION_B = 2'b01;
	parameter VERSION_C = 2'b10;
	parameter VERSION_D = 2'b11;

	//states
	parameter IDLE = 2'b00;
	parameter PRESSED = 2'b01;
	parameter DONE = 2'b11;

	//variables
	reg [2:0] state;
	reg [3:0] condition_one;
	//reg [5:0] condition_two;
	//reg [5:0] condition_three;
	//reg [5:0] condition_four;

	//based on the version picked, assume version A for now
	//setup
	initial begin
		version = 0; //hard code version A
		condition_one = 4'b0101; // time must contain a 5
		strike = 0;
		state = IDLE;
		module_defused = 0;
	end
	//assume always enabled
	always@(posedge clock_65mhz) begin
		if (reset) begin
			hold_strike <= 0;
			strike <= 0;
			module_defused <= 0;
			state <= IDLE;
		end
		if (enable) begin
			case (state) //strike is enabled in this module
				IDLE: begin
					strike <= 0;
					if (button_blue == PRESSED) begin // see if button_blue is pressed (enabled == 1)
						state <= PRESSED;
					end
				end
				PRESSED: begin
					if (button_blue != PRESSED) begin // see if button_blue is unpressed (enable != 1)
						if ((bcd[15:12] == condition_one) | (bcd[11:8] == condition_one) |
							(bcd[7:4] == condition_one) | (bcd[3:0] == condition_one) ) begin 
							strike <= 0;
							state <= DONE;
						end
						else begin
							hold_strike <= 1;
							strike <= 1;
							state <= IDLE;
						end
					end
				end
				DONE: begin
					strike <= 0;
					module_defused <= 1; //module is defused
				end
				default: begin
					strike <= 0;
					state <= IDLE;
				end
			endcase
		end
	end
endmodule
