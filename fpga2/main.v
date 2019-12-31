`timescale 1ns / 1ps

module main(
	input SYSCLK_N,
	input SYSCLK_P,
	input sppm,
	input spad,

	output laser_syn,
	output spad_co

    );
    

wire clk500M, clk200M, clk100M;

clk_wiz_0 clk_1(
       // Clock out ports
       .clk_out1(clk500M),     // output clk_out1    
      // Clock in ports
       .clk_in1(clk200M));      // input clk_in1

IBUFDS #( .DIFF_TERM("FALSE"), .IBUF_LOW_PWR("TRUE"), .IOSTANDARD("DEFAULT") )
	IBUFDS_inst( .O(clk200M), .I(SYSCLK_P), .IB(SYSCLK_N) );


assign laser_syn = ~sppm;

coincidence co1( .clk(clk500M), .sppm(sppm), .spad(spad), .spad_co(spad_co) );


endmodule
