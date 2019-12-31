`timescale 1ns / 1ps


module coincidence(
	input clk,
	input sppm,
	input spad,

	output spad_co
    );

wire sppm_s;
cdc_2ff cdc1( .clk(clk), .in(sppm), .out(sppm_s));

wire sppm_pwm;
pwm pwm1( .clk(clk), .in(sppm_s), .out(sppm_pwm));



wire out;
que q1(.clk(clk), .syn(sppm_pwm), .in(spad), .out(out));

self_trigger st1( .spad(spad), .pass(out), .coincidence(spad_co));

endmodule
