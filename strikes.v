`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:37 11/15/2016 
// Design Name: 
// Module Name:    strikes 
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
module strikes(
	 input clock, //keeps everything clocked at 27MHz
	 input reset, //global reset input
    input strike, //or'd inputs from all of the strikes from modules
    output reg explode, //high when all 3 strikes are used
    output reg [2:0] strike_led //displays to 3 led's
    );

//states
parameter NO_STRIKES = 2'b00;
parameter ONE_STRIKE = 2'b01;
parameter TWO_STRIKES = 2'b10;
parameter EXPLODE = 2'b11;

//variables
reg [1:0] state = 0;

always @ (posedge clock) begin
	if (reset) begin
		state <= NO_STRIKES;
		explode <= 0;
		strike_led <= 3'b000;
	end
	case (state)
		NO_STRIKES: begin
			//outputs
			explode <= 0;			//no explosion
			strike_led <= 3'b000;	//no leds lit
			//state transition
			if (strike) state <= ONE_STRIKE;
		end
		
		ONE_STRIKE: begin
			//outputs
			explode <= 0;			//no explosion
			strike_led <= 3'b001;	//one led lit
			//state transition
			if (strike) state <= TWO_STRIKES;
		end

		TWO_STRIKES: begin
			//outputs
			explode <= 0;			//no explosion
			strike_led <= 3'b011;	//two leds lit
			//state transition
			if (strike) state <= EXPLODE;
		end

		EXPLODE: begin
			//outputs
			explode <= 1;			//explosion
			strike_led <= 3'b111;	//three leds lit
		end	
		default: begin
			explode <= 0;
			strike_led <= 3'b000;
		end
	endcase
end

endmodule
