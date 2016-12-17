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
	input four_hz_enable, //for "exploding"
	input timer_explode, //when to flash the LEDs if time elapses
    output reg explode, //high when all 3 strikes are used
    output reg [2:0] strike_led //displays to 3 led's
    );

//states
parameter NO_STRIKES = 3'b000;
parameter ONE_STRIKE = 3'b001;
parameter TWO_STRIKES = 3'b010;
parameter EXPLODE = 3'b011;
parameter EXPLODING = 3'b111;

reg on_off;
//variables
reg [2:0] state = 0;

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
			if (timer_explode) state <= EXPLODE;
			else if (strike) state <= ONE_STRIKE;
		end
		
		ONE_STRIKE: begin
			//outputs
			explode <= 0;			//no explosion
			strike_led <= 3'b001;	//one led lit
			//state transition
			if (timer_explode) state <= EXPLODE;
			else if (strike) state <= TWO_STRIKES;
		end

		TWO_STRIKES: begin
			//outputs
			explode <= 0;			//no explosion
			strike_led <= 3'b011;	//two leds lit
			//state transition
			if (timer_explode) state <= EXPLODE;
			else if (strike) state <= EXPLODE;
		end

		EXPLODE: begin
			//outputs
			explode <= 1;			//explosion
			strike_led <= 3'b111;	//three leds lit
			state <= EXPLODING;
		end
		
		EXPLODING: begin //blinking
			explode <= 1;
			if (four_hz_enable) begin
				on_off <= on_off + 1; //toggles 4 times each second
				if (on_off) strike_led <= 3'b111;
				else strike_led <= 3'b000;
			end
		end
		
		default: begin
			explode <= 0;
			strike_led <= 3'b000;
		end
	endcase
end

endmodule
