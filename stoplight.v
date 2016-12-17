`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:26 12/06/2016 
// Design Name: 
// Module Name:    stoplight 
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
module stoplight(
	input clock_65mhz, 	// keeps everything clocked at 65mhz
	input reset,			// reset 
	input enable,			// enables the module to work
	input button_stop, 	// input to stop the light
	input [3:0] rng_output, // the random input
	input one_hz_enable,
	output reg strike,	// high when the module is messed up to strike module
	output reg module_defused, // high when the module is defused
	output reg [1:0] version, // module version A-D for visuals
	output reg rng_enable,
	output [10:1] user); // use ten of the user i/o
	
	parameter MINLIGHT = 4'b0000; // the first light is at index 0 of the bar graph
	parameter MAXLIGHT = 4'b1001; // the last light is at index 9 of the bar graph (10 lights total)
	parameter PRESSED = 1'b1;
	
	//version (2 bit)
//	parameter VERSION_A = 2'b00;
//	parameter VERSION_B = 2'b01;
//	parameter VERSION_C = 2'b10;
//	parameter VERSION_D = 2'b11;
	parameter VERSION_A = 4'b0101;
	parameter VERSION_B = 4'b1000;
	parameter VERSION_C = 4'b0011;
	parameter VERSION_D = 4'b0000;
	
	//states
	parameter MOVING = 2'b00;
	parameter STOPPED = 2'b01;
	parameter WRONG = 2'b10;
	parameter DONE = 2'b11;
	
	//variables
	reg [2:0] state;
	reg [3:0] index;
	reg direction;
	reg [3:0] condition_one;
	reg [1:0] counted;
	reg [9:0] temp;
	//reg [5:0] condition_two;
	//reg [5:0] condition_three;
	//reg [5:0] condition_four;

	//based on the version picked, assume version A for now
	//setup
	initial begin
		version = 0; //hard code version A
		condition_one = VERSION_A; // time must contain a 5
		strike = 0;
		state = MOVING;
		module_defused = 0;
	end
	//assume always enabled
	always @(posedge one_hz_enable) begin
		if (reset) begin
			index <= 5;
		end
		if (enable) begin
			case (state)
				MOVING: begin
					counted <= 0;
					if (direction) begin  // check if the light should be going right
						if (index == (MAXLIGHT - 1)) begin // If the light is right before the max index
							direction <= ~direction; // switch the direction of the light
						end
						index <= index + 1; 	// increment the light's position
					end
					else begin // else the light should be going left
						if (index == (MINLIGHT + 1)) begin // If the light is right before the min index
							direction <= ~direction; 
						end
						index <= index - 1;
					end
				end
				STOPPED: begin
					index <= index;
				end
				WRONG: begin
					counted <= counted + 1;
					index <= index;
				end
				DONE: begin
					index <= index;
				end
				default: begin
					index <= index;
				end
			endcase
		end		
	end
	always@(posedge clock_65mhz) begin
		if (reset) begin
			strike <= 0;
			module_defused <= 0;
			state <= MOVING;
		end
		if (enable) begin
			case (state) //strike is enabled in this module
				MOVING: begin
					strike <= 0;
					if (button_stop == PRESSED) begin // see if button_blue is pressed (enabled == 1)
						state <= STOPPED;
					end
				end
				STOPPED: begin
					if (button_stop != PRESSED) begin // see if button_blue is unpressed (enable != 1)
						if (index == condition_one) begin 
							strike <= 0;
							state <= DONE;
						end
						else begin
							strike <= 1;
							state <= WRONG;
						end
					end
				end
				WRONG: begin							// If we stopped incorrectly, we wait 2 seconds
					strike <= 0;
					if (counted == 2'b10) begin // check the register, which is incremented in the 1sec always block
						state <= MOVING;				
					end
				end
				DONE: begin
					strike <= 0;
					module_defused <= 1; //module is defused
				end
				default: begin
					strike <= 0;
					state <= MOVING;
				end
			endcase
		end
	end
	always @(posedge clock_65mhz) begin
		if (state == WRONG) begin
			temp <= 10'b1111111111;
		end
		else begin
			case (index) 
				4'b0000: temp <= 10'b1000000000;
				4'b0001: temp <= 10'b0100000000;
				4'b0010: temp <= 10'b0010000000;
				4'b0011: temp <= 10'b0001000000;
				4'b0100: temp <= 10'b0000100000;
				4'b0101: temp <= 10'b0000010000;
				4'b0110: temp <= 10'b0000001000;
				4'b0111: temp <= 10'b0000000100;
				4'b1000: temp <= 10'b0000000010;
				4'b1001: temp <= 10'b0000000001;
				default: temp <= temp;
			endcase
		end
	end
	assign user = {temp};
endmodule
