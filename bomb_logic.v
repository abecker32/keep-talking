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
	 input [3:0] module_defused, //from each module
	 input [10:0] hcount,
	 input [9:0] vcount,
	 input hsync,
	 input vsync,
	 input blank,
	 output reg game_won, //to game FSM
	 output reg [3:0] enable, //bus one for each module
	 output reg accum_enable,
	 output phsync,
	 output pvsync,
	 output pblank,
	 output [23:0] pixel
	 );
	 

	always @ (posedge clock) begin
		if (reset)begin
			game_won <= 0; //game has not been won
			//visuals = 30'b0; //all default (version "A", state 0--usually waiting)
			enable <= 4'b0; //nothing enabled
			accum_enable <= 0; //dont start the accumulator
		end
		if (begin_setup) begin
			//make this random later
			enable <= 4'b1; //all modules are on
			accum_enable <= 1; //start the accumulator
		end
		else if (module_defused[0] && module_defused[1] && module_defused[2] && module_defused[3])
			game_won <= 1;
	end
	
	assign phsync = hsync;
	assign pvsync = vsync;
	assign pblank = blank;
	wire [23:0] center_pixel;
	wire [23:0] one_pixel;
	wire [23:0] tiger_pixel;
	wire [23:0] blank_pixel;
	wire [23:0] tiger_pixel_two;
	blob #(.WIDTH(225), .HEIGHT(225), .COLOR(24'hFF_00_00))
		center(.x(447), .hcount(hcount), .y(319), .vcount(vcount), .pixel(center_pixel));
	tiger_head tiger(.pixel_clk(clock),.x(100),.hcount(hcount),.y(100),.vcount(vcount),.pixel(tiger_pixel));
	blank_bomb blankbomb(.pixel_clk(clock),.x(600),.hcount(hcount),.y(100),.vcount(vcount),.pixel(blank_pixel));
	tiger_head tiger2(.pixel_clk(clock),.x(100),.hcount(hcount),.y(420),.vcount(vcount),.pixel(tiger_pixel_two));
	one_image oi(.pixel_clk(clock),.x(600),.hcount(hcount),.y(100),.vcount(vcount),.pixel(one_pixel));
	assign pixel = tiger_pixel_two|tiger_pixel;

endmodule
