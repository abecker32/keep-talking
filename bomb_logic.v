`timescale 1ns / 1ps
module bomb_logic(
    input vclock, //65mhz clock
	input reset, //overall reset
	input begin_setup, //from game FSM
	input [3:0] module_defused, //from each module
	input [10:0] hcount,	//from XVGA for visuals
	input [9:0] vcount,		//from XVGA for visuals
	input hsync,			//from XVGA for visuals
	input vsync,			//from XVGA for visuals
	input blank,			//from XVGA for visuals
	output reg game_won, //to game FSM
	output reg [3:0] enable, //unused, enable for each  
	output reg accum_enable,
	output phsync,
	output pvsync,
	output pblank,
	output [23:0] pixel
	);
	 
	reg [23:0] pixelreg;
	wire [23:0] meter_pixel;
	wire [23:0] orange_pixel;
	wire [23:0] soone_pixel, sotwo_pixel, sothree_pixel, sofour_pixel, sofive_pixel, sosix_pixel, soseven_pixel, soeight_pixel;
	wire [23:0] sofone_pixel, softwo_pixel, softhree_pixel, soffour_pixel, soffive_pixel, sofsix_pixel,
					sofseven_pixel, sofeight_pixel, sofnine_pixel, soften_pixel, sofeleven_pixel, softwel_pixel,
					softhirt_pixel, soffourt_pixel, soffift_pixel, sofsixt_pixel;
	always @ (posedge vclock) begin
		pixelreg <= meter_pixel | orange_pixel | 
						soone_pixel | sotwo_pixel | sothree_pixel | sofour_pixel | sofive_pixel | sosix_pixel | soseven_pixel | soeight_pixel |
						sofone_pixel | softwo_pixel | softhree_pixel | soffour_pixel | soffive_pixel | sofsix_pixel |
					sofseven_pixel | sofeight_pixel | sofnine_pixel | soften_pixel | sofeleven_pixel | softwel_pixel |
					softhirt_pixel | soffourt_pixel | soffift_pixel | sofsixt_pixel ;
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
	orange_square square(.pixel_clk(vclock),.x(604),.hcount(hcount),.y(396),.vcount(vcount),.pixel(orange_pixel));
	
	switch_off sofone(.pixel_clk(vclock),.x(219),.hcount(hcount),.y(209),.vcount(vcount),.pixel(sofone_pixel));
	switch_off softwo(.pixel_clk(vclock),.x(251),.hcount(hcount),.y(209),.vcount(vcount),.pixel(softwo_pixel));
	switch_on soone(.pixel_clk(vclock),.x(283),.hcount(hcount),.y(209),.vcount(vcount),.pixel(soone_pixel));
	switch_off softhree(.pixel_clk(vclock),.x(315),.hcount(hcount),.y(209),.vcount(vcount),.pixel(softhree_pixel));
	switch_off soffour(.pixel_clk(vclock),.x(347),.hcount(hcount),.y(209),.vcount(vcount),.pixel(soffour_pixel));
	switch_off soffive(.pixel_clk(vclock),.x(379),.hcount(hcount),.y(209),.vcount(vcount),.pixel(soffive_pixel));
	
	switch_off sofsix(.pixel_clk(vclock),.x(219),.hcount(hcount),.y(256),.vcount(vcount),.pixel(sofsix_pixel));
	switch_on sotwo(.pixel_clk(vclock),.x(251),.hcount(hcount),.y(256),.vcount(vcount),.pixel(sotwo_pixel));
	switch_off sofseven(.pixel_clk(vclock),.x(283),.hcount(hcount),.y(256),.vcount(vcount),.pixel(sofseven_pixel));
	switch_off sofeight(.pixel_clk(vclock),.x(315),.hcount(hcount),.y(256),.vcount(vcount),.pixel(sofeight_pixel));
	switch_on sothree(.pixel_clk(vclock),.x(347),.hcount(hcount),.y(256),.vcount(vcount),.pixel(sothree_pixel));
	switch_off sofnine(.pixel_clk(vclock),.x(379),.hcount(hcount),.y(256),.vcount(vcount),.pixel(sofnine_pixel));
	
	switch_on sofour(.pixel_clk(vclock),.x(219),.hcount(hcount),.y(303),.vcount(vcount),.pixel(sofour_pixel));
	switch_off soften(.pixel_clk(vclock),.x(251),.hcount(hcount),.y(303),.vcount(vcount),.pixel(soften_pixel));
	switch_off sofeleven(.pixel_clk(vclock),.x(283),.hcount(hcount),.y(303),.vcount(vcount),.pixel(sofeleven_pixel));
	switch_off softwel(.pixel_clk(vclock),.x(315),.hcount(hcount),.y(303),.vcount(vcount),.pixel(softwel_pixel));
	switch_off softhirt(.pixel_clk(vclock),.x(347),.hcount(hcount),.y(303),.vcount(vcount),.pixel(softhirt_pixel));
	switch_off soffourt(.pixel_clk(vclock),.x(379),.hcount(hcount),.y(303),.vcount(vcount),.pixel(soffourt_pixel));
	
	switch_on sofive(.pixel_clk(vclock),.x(219),.hcount(hcount),.y(350),.vcount(vcount),.pixel(sofive_pixel));
	switch_off soffift(.pixel_clk(vclock),.x(251),.hcount(hcount),.y(350),.vcount(vcount),.pixel(soffift_pixel));
	switch_on sosix(.pixel_clk(vclock),.x(283),.hcount(hcount),.y(350),.vcount(vcount),.pixel(sosix_pixel));
	switch_off sofsixt(.pixel_clk(vclock),.x(315),.hcount(hcount),.y(350),.vcount(vcount),.pixel(sofsixt_pixel));
	switch_on soseven(.pixel_clk(vclock),.x(347),.hcount(hcount),.y(350),.vcount(vcount),.pixel(soseven_pixel));
	switch_on soeight(.pixel_clk(vclock),.x(379),.hcount(hcount),.y(350),.vcount(vcount),.pixel(soeight_pixel));
	
	meter_image meter(.pixel_clk(vclock),.x(612),.hcount(hcount),.y(209),.vcount(vcount),.pixel(meter_pixel));
	assign pixel = pixelreg;

endmodule
