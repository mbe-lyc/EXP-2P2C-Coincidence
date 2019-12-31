`timescale 1ns / 1ps


module self_trigger(
	input spad,
	input pass,
	output reg coincidence
);

wire spadb;
assign spadb = ~spad;

always@(posedge spad or posedge spadb)
begin
    if (spadb) begin
        coincidence <= 1'd0;
    end
    else begin
        coincidence <= pass;
    end
end
endmodule
