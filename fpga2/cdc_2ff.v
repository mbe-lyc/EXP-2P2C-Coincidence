`timescale 1ns / 1ps


module cdc_2ff(
    input clk,
    input in,
    output out
    );

reg a, b;

always @(posedge clk) begin
    a <= in;
end 

always @(posedge clk) begin
    b <= a;
end 

assign out = b;

endmodule
