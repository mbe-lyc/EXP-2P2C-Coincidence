module duty_cycle_out(
    input rst,
    input clk,
    input [8:0] w,
    
    output reg out
    
    );

reg [8:0] cnt;

always @(posedge clk or posedge rst) begin
    if( rst == 1'd1 ) begin
        cnt <= 1'd0;
    end
    else begin
        cnt <= cnt == 'd399 ? 1'd0 : cnt+1'd1;
        out <= (w>cnt);
    end 
end    

    
endmodule
