`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:35 11/30/2016 
// Design Name: 
// Module Name:    countdown_accumulator 
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
module countdown_accumulator(
    input clock,
	 input reset,
	 input accum_enable, //start
    input [3:0] enable, //which modules are enabled
    output reg[15:0] time_count = 0, //bcd
    output reg accum_done
    );
//each module time parameters
parameter TIME = 16'b0000_0110_0000_0000; //6 minute timer
parameter M1TIME = 100;
parameter M2TIME = 100;
parameter M3TIME = 100;
parameter M4TIME = 100;

always @ (posedge clock) begin
	if (reset) begin
		time_count = 0; //no time
		accum_done = 0; //accumulator is not done
	end
	if (accum_enable) begin
		time_count = TIME;
		/*time_count = (enable[0] ? (time_count + M1TIME) : time_count);
		time_count = (enable[1] ? (time_count + M2TIME) : time_count);
		time_count = (enable[2] ? (time_count + M3TIME) : time_count);
		time_count = (enable[3] ? (time_count + M4TIME) : time_count);*/
		accum_done = 1;
	end
end

endmodule
