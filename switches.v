`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:37 11/15/2016 
// Design Name: 
// Module Name:    switches 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: bomb module will interface with the switches on the labkit
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module switches(
	 input clock, //keeps everything clocked at 27MHz
	 input reset, //global reset input
	 input enable, //enable bit
	 input [3:0] rng_output, //the random input
    input [5:0] switches, //inputs 6 switches
    output reg strike, //high when the module is messed up to strike module
	 output reg module_defused, //high when the module is defused
	 output reg [1:0] version, //module version A-D for visuals
	 output reg [2:0] state, //internal state machine
	 output reg rng_enable //when the module is getting set up
    );
//version (2 bit) 
parameter VERSION_A = 2'b00;
parameter VERSION_B = 2'b01;
parameter VERSION_C = 2'b10;
parameter VERSION_D = 2'b11;

//states
parameter WAITING = 3'b000;
parameter ONE_DONE = 3'b001;
parameter TWO_DONE = 3'b010;
parameter THREE_DONE = 3'b011;
parameter DEFUSED = 3'b100;

//variables
//reg [2:0] state;
reg [5:0] condition_one;
reg [5:0] condition_two;
reg [5:0] condition_three;
reg [5:0] condition_four;

//based on the version picked, assume version A for now
//setup
initial begin
	version = 0; //hard code version A
	condition_one = 		6'b001000; //hard code situations for A to become defused
	condition_two = 		6'b010010; //hard code situations for A to become defused
	condition_three = 	6'b100000; //hard code situations for A to become defused
	condition_four = 		6'b101011; //hard code situations for A to become defused
	strike = 0;
	state = WAITING;
	module_defused = 0;
end
//assume always enabled
always@(posedge clock) begin
	if (reset) begin
		strike <= 0;
		module_defused <= 0;
		state <= WAITING;
	end
	if (enable) begin
		case (state) //strike is never given
			WAITING: begin
				if (switches == condition_one) begin //correct first combination
					state <= ONE_DONE;
				end
			end
			ONE_DONE: begin
				if (switches == condition_two) begin //correct second combination
					state <= TWO_DONE;
				end
			end
			TWO_DONE: begin
				if (switches == condition_three) begin //correct third combination
					state <= THREE_DONE;
				end
			end
			THREE_DONE: begin
				if (switches == condition_four) begin //correct fourth combination
					state <= DEFUSED;
				end
			end
			DEFUSED: begin
				module_defused <= 1; //module is defused
			end
			default: state <= WAITING;
		endcase
	end
end

endmodule
