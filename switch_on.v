`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:33:35 12/01/2016 
// Design Name: 
// Module Name:    tiger_head 
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
module switch_on #(parameter WIDTH = 30, HEIGHT = 45)
	(input pixel_clk,
	input [10:0] x,hcount,
	input [9:0] y,vcount,
	output reg [23:0] pixel);
		
	wire [19:0] image_addr;	// num of bits for 128*256 ROM
	wire [7:0] image_bits, red_mapped, green_mapped, blue_mapped;
	reg [7:0] image_bits_reg;
	
	// note the one clock cycle delay in pixel!
	always @(posedge pixel_clk) begin
		image_bits_reg <= image_bits;
		if ((hcount-2 >= x && hcount-2 < (x+WIDTH)) && (vcount >= y && vcount < (y+HEIGHT))) begin
			pixel <= {red_mapped, green_mapped, blue_mapped};
		end
		else begin
			pixel <= 0;
		end
	end
	// calculate rom address and read the location
	assign image_addr = (hcount-x) + (vcount-y) * WIDTH;
	//tiger_image_rom rom1(image_addr, pixel_clk, image_bits);
	switch_on_rom sor(.clka(pixel_clk),.dina(0),.addra(image_addr),.wea(0),.douta(image_bits));
	
	// use color map to create 8bits R, 8bits G, 8bits B;
	red_son_table rsont (.clka(pixel_clk),.dina(0),.addra(image_bits_reg),.wea(0),.douta(red_mapped));//image_bits, pixel_clk, red_mapped);
	green_son_table gsont (.clka(pixel_clk),.dina(0),.addra(image_bits_reg),.wea(0),.douta(green_mapped));
	blue_son_table bsont (.clka(pixel_clk),.dina(0),.addra(image_bits_reg),.wea(0),.douta(blue_mapped));
	//green_lookup_table glt (image_bits, pixel_clk, green_mapped);
	//blue_lookup_table blt (image_bits, pixel_clk, blue_mapped);
endmodule
