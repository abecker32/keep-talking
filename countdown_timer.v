`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:40:46 12/01/2016 
// Design Name: 
// Module Name:    countdown_timer 
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
module countdown_timer(
    input clock, 
    input reset,
    input [15:0] time_count,
    input one_hz_enable,
    input accum_done,
    input begin_timer,
	input stop_timer,
    output reg explode,
    output [15:0] bcd
    );

reg [3:0] min_ten, min_one, sec_ten, sec_one;

reg timer_started; //is it counting

always @ (posedge clock) begin
	if (reset) begin
		{min_ten,min_one,sec_ten,sec_one} <= time_count;
		timer_started <= 0;
		explode <= 0;
	end
	
	if (begin_timer && accum_done) begin //reset
		if (time_count == 0) explode <= 1;
		else begin
			{min_ten,min_one,sec_ten,sec_one} <= time_count;
			timer_started <= 1;
			explode <= 0;
		end
	end
		
	if (timer_started && one_hz_enable && !stop_timer) begin //every second when the timer is started
		if (min_ten==0 && min_one==0 && sec_ten==0 && sec_one==0) begin
			explode <= 1;
			timer_started <= 0;
		end
		
		else begin //decrement
			sec_one <= sec_one - 1;
			if(sec_one == 0) begin //carry from 00:10 to 00:09
				sec_ten <= sec_ten - 1;
					if(sec_ten == 0) begin //carry from 01:00 to 00:59
						min_one <= min_one - 1;
							if (min_one == 0) begin //carry from 10:00 to 9:59
								min_ten <= min_ten - 1;
							end
						sec_ten <= 4'b0101; //5
					end
				sec_one <= 4'b1001;//9
			end
		end	
		
	end
	
end

assign bcd = {min_ten, min_one, sec_ten, sec_one};
endmodule