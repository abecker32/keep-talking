`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:20:10 11/18/2016 
// Design Name: 
// Module Name:    pulse_posedge 
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
module pulse_posedge(
    input clock,
    input hold,
    output reg pulse
    );
	 
reg last_held;
	 
always @ (posedge clock) begin
	last_held <= hold;
	if (hold && !last_held) pulse <= 1;
	else pulse <= 0;
end

endmodule
