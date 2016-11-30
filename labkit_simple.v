`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:55:18 11/18/2016 
// Design Name: 
// Module Name:    labkit_simple 
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
module labkit_simple(
   input CLK100MHZ,
   input[15:0] SW, 
   input BTNC, BTNU, BTNL, BTNR, BTND,
   output[3:0] VGA_R, 
   output[3:0] VGA_B, 
   output[3:0] VGA_G,
   output[7:0] JA, 
   output VGA_HS, 
   output VGA_VS, 
   output LED16_B, LED16_G, LED16_R,
   output LED17_B, LED17_G, LED17_R,
   output[15:0] LED,
   output[7:0] SEG,  // segments A-G (0-6), DP (7)
   output[7:0] AN    // Display 0-7
   );
   
// create 25mhz system clock
    wire clock_25mhz;
    clock_quarter_divider clockgen(.clk100_mhz(CLK100MHZ), .clock_25mhz(clock_25mhz));

//  instantiate 7-segment display;  
    wire [31:0] data;
    wire [6:0] segments;
    display_8hex display(.clk(clock_25mhz),.data(data), .seg(segments), .strobe(AN));    
    assign SEG[6:0] = segments;
    assign SEG[7] = 1'b1;

//wire names
    wire reset;
    wire brake_db, hidden_db, ignition_db, driver_db, pass_db, reprogram_db; //debounced outputs
    wire power, status_led, siren, siren_sound, start_timer, one_hz_enable, expired;
    wire [1:0] time_param_sel, interval;
    wire [3:0] time_value, value, state, countdown;

//debounced or synchronized signals
    //synchronize reset_sync(.clk(clock), .in(SW[15]), .out(reset));
    assign reset = SW[15];
    assign time_param_sel = SW[5:4];
    assign time_value = SW[3:0];
    //synchronize time_param_sel_sync(.clk(clock), .in(SW[5:4]), .out(time_param_sel));
    //synchronize time_value_sync(.clk(clock), .in(SW[3:0]), .out(time_value));
                    
    debounce #(.DELAY(250000))   // .01 sec with a 25Mhz clock
        brake_dbr(.reset(reset), .clock(clock_25mhz), .noisy(BTND), .clean(brake_db));
    debounce #(.DELAY(250000))   // .01 sec with a 25Mhz clock
        hidden_dbr(.reset(reset), .clock(clock_25mhz), .noisy(BTNU), .clean(hidden_db));
    debounce #(.DELAY(250000))   // .01 sec with a 25Mhz clock
        ignition_dbr(.reset(reset), .clock(clock_25mhz), .noisy(SW[7]), .clean(ignition_db));
    debounce #(.DELAY(250000))   // .01 sec with a 25Mhz clock
        driver_dbr(.reset(reset), .clock(clock_25mhz), .noisy(BTNL), .clean(driver_db));
    debounce #(.DELAY(250000))   // .01 sec with a 25Mhz clock
        pass_dbr(.reset(reset), .clock(clock_25mhz), .noisy(BTNR), .clean(pass_db));
    debounce #(.DELAY(250000))   // .01 sec with a 25Mhz clock
        reprogram_dbr(.reset(reset), .clock(clock_25mhz), .noisy(BTNC), .clean(reprogram_db));

//setup
    divider one_hz_divider (.clock(clock_25mhz), .reset(reset), .start_timer(start_timer), .one_hz_enable(one_hz_enable));
    fuel_pump_logic pump_logic(.clock(clock_25mhz), .reset(reset), .brake(brake_db), .hidden(hidden_db), .ignition(ignition_db), .power(power));
    siren_generator siren_to_sound(.clock(clock_25mhz), .reset(reset), .siren(siren), .siren_sound(siren_sound));
    time_parameters t_param_mod(.clock(clock_25mhz), .reset(reset), .reprogram(reprogram_db), .interval(interval),
        .time_param_sel(time_param_sel), .time_value(time_value), .value(value));
    timer timer_mod(.clock(clock_25mhz), .reset(reset), .value(value), .one_hz_enable(one_hz_enable),
        .start_timer (start_timer), .expired(expired), .countdown(countdown));
    anti_theft_fsm fsm(.clock(clock_25mhz), .reset(reset), .ignition(ignition_db), .driver(driver_db), .pass(pass_db),
        .reprogram(reprogram_db), .expired(expired), .one_hz_enable(one_hz_enable), .state(state), .interval(interval),
        .start_timer(start_timer), .siren(siren), .led(status_led)); 

    assign data = {state, 24'h000000, countdown};   // display state 0 0 0 0 0 0 countdown
    assign LED[0] = status_led;
    assign LED[1] = power;
    assign JA[0] = siren_sound;

endmodule

module clock_quarter_divider(input clk100_mhz, output reg clock_25mhz = 0);
    reg counter = 0;
    always @(posedge clk100_mhz) begin
        counter <= counter + 1;
        if (counter == 0) begin
            clock_25mhz <= ~clock_25mhz;
        end
    end
endmodule

/* 
//////////////////////////////////////////////////////////////////////////////////
// sample Verilog to generate color bars
   
    wire [9:0] hcount;
    wire [9:0] vcount;
    wire hsync, vsync, at_display_area;
    vga vga1(.vga_clock(clock_25mhz),.hcount(hcount),.vcount(vcount),
          .hsync(hsync),.vsync(vsync),.at_display_area(at_display_area));
        
    assign VGA_R = at_display_area ? {4{hcount[7]}} : 0;
    assign VGA_G = at_display_area ? {4{hcount[6]}} : 0;
    assign VGA_B = at_display_area ? {4{hcount[5]}} : 0;
    assign VGA_HS = ~hsync;
    assign VGA_VS = ~vsync;


//////////////////////////////////////////////////////////////////////////////////
//
//  remove these lines and insert your lab here

    assign LED = SW;     
    assign JA[7:0] = 8'b0;
    assign data = {28'h0123456, SW[3:0]};   // display 0123456 + SW
    assign LED16_R = BTNL;                  // left button -> red led
    assign LED16_G = BTNC;                  // center button -> green led
    assign LED16_B = BTNR;                  // right button -> blue led
    assign LED17_R = BTNL;
    assign LED17_G = BTNC;
    assign LED17_B = BTNR; 

module vga(input vga_clock,
            output reg [9:0] hcount = 0,    // pixel number on current line
            output reg [9:0] vcount = 0,	 // line number
            output vsync, hsync, at_display_area);
    // Counters.
    always @(posedge vga_clock) begin
        if (hcount == 799) begin
            hcount <= 0;
        end
        else begin
            hcount <= hcount +  1;
        end
        if (vcount == 524) begin
            vcount <= 0;
        end
        else if(hcount == 799) begin
            vcount <= vcount + 1;
        end
    end
    
    assign hsync = (hcount < 96);
    assign vsync = (vcount < 2);
    assign at_display_area = (hcount >= 144 && hcount < 784 && vcount >= 35 && vcount < 515);
endmodule
*/