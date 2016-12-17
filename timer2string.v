`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:14:38 12/05/2016 
// Design Name: 
// Module Name:    timer2string 
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
module timer2string(
    input [3:0] bcd, //4 bit number bcd
	 output reg [7:0] ascii //4 8 bit ascii characters
	 );

always @ (bcd) begin
	case (bcd)
		0: ascii = 8'h30;
		1: ascii = 8'h31;
		2: ascii = 8'h32;
		3: ascii = 8'h33;
		4: ascii = 8'h34;
		5: ascii = 8'h35;
		6: ascii = 8'h36;
		7: ascii = 8'h37;
		8: ascii = 8'h38;
		9: ascii = 8'h39;
	endcase
end

endmodule

