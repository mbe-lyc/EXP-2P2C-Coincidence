`timescale 1ns / 1ps


module pwm(
    input clk,
    input in,
    output out
    );

reg de;
always @(posedge clk)begin
    de <= in;
end    

assign out = in & (~de);
    
endmodule
