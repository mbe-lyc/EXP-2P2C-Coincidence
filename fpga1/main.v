`timescale 1ns / 1ps

module main(
	input rst,
	input SYSCLK_N,
	input SYSCLK_P,
	input sppm,

	output led,
	output set200n_syn,
	output merge
    );

wire clk200M;
IBUFDS #( .DIFF_TERM("FALSE"), .IBUF_LOW_PWR("TRUE"), .IOSTANDARD("DEFAULT") )
    IBUFDS_inst( .O(clk200M), .I(SYSCLK_P), .IB(SYSCLK_N) );


wire inter;

divider #(8,200) div1( .clk(clk200M), .o_clk(inter) );

wire inter_pwm;
pwm pwm1( .clk(clk200M), .in(inter), .out(inter_pwm) );

wire clk400M;
clk_wiz_0 cw0
(
// Clock out ports
.clk_out1(clk400M),     // output clk_out1
// Clock in ports
.clk_in1(clk200M));      // input clk_in1

wire set200n;
set_min_200n sm200n( .clk(clk400M), .in(sppm), .out(set200n) );

reg sppm_sync, sppm_de, sppm_mono;
always @(posedge clk400M) begin
	sppm_sync <= set200n;
	sppm_de <= sppm_sync;
	sppm_mono <= ((sppm_sync==1'd1)&(sppm_de==1'd0));
end

reg [19:0] cnt1;
always @(posedge clk400M or posedge rst) begin
	if(rst == 1'd1) begin
		cnt1 <= 1'd0;
	end
	else begin
		cnt1 <= cnt1=='d399999 ? 'd0 : cnt1+1'd1;
	end
end

reg [16:0] sppm_1ms;
always @(posedge clk400M or posedge rst) begin
	if(rst == 1'd1) begin
		sppm_1ms <= 'd0;
	end
	else begin
		sppm_1ms <= cnt1 == 'd399999 ? 'd0 : sppm_1ms+sppm_mono;
	end
end

reg [8:0] w1;
always @(posedge clk400M or posedge rst) begin
	if(rst == 1'd1) begin
		 w1 <= 1'd0;
	end
	else if(cnt1 == 'd399999) begin
		if(sppm_1ms > 'd808) begin
			w1 <= w1=='d0 ? 'd0 : w1-'d1;
		end
		else if(sppm_1ms < 'd792) begin
			w1 <= w1=='d400 ? w1 : w1+'d1;
		end
	end
end

duty_cycle_out dcout1( .clk(clk400M), .rst(rst), .w(w1), .out(led));

wire set200n_ex;
extend1T ex1( .clk(clk400M), .in(set200n), .out(set200n_ex));

assign set200n_syn = ~set200n_ex;
//assign merge = ~(inter_pwm|set200n_ex);
assign merge = ~set200n_ex;
//assign merge = ~inter_pwm;

endmodule
