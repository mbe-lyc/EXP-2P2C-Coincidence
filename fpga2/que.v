`timescale 1ns / 1ps


module que(
	input clk,
	input syn,
	input in,

	output out
    );

reg store[0:205];
reg q[0:205];
reg em[0:205];


genvar i;

generate
	for(i = 0; i <= 100; i=i+1) begin: _store
		always @(posedge clk) begin
			if(syn == 1'd1) begin
				if(i<2) store[i] <= 1'd0;
				else store[i] <= ((!q[i-1])&(q[i]));
			end
			else begin
				if(i == 100) store[i] <= 1'd0;
				else store[i] <= store[i+1];
			end
		end
	end
endgenerate

generate
	for(i = 0; i <= 100; i=i+1) begin : _em
		always @(posedge clk) begin
			if(syn == 1'd1) begin
				if(i == 0) em[i] <= 1'd0;
				else em[i] <= 1'd1;
			end
			else begin
				if(i == 0) em[i] <= 1'd0;
				else em[i] <= em[i-1];
			end
		end
	end
endgenerate

generate
	for(i = 0; i <= 100; i=i+1) begin : _q
		always @(posedge clk) begin
			if(syn == 1'd1) begin
				q[i] <= 1'd0;
			end
			else begin
				q[i] <= ((em[i]==1'd1)?in:q[i]);
			end
		end
	end
endgenerate


assign out = store[0] | store[1] | store[2];

endmodule