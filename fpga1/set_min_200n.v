module set_min_200n(

	input clk,
	input in,

	output out
    );

reg cnt[0:500];
reg act;

wire in_buf;
dff in_buffer( .clk(clk), .in(in), .out(in_buf) );

genvar i;
generate 
for ( i = 0; i <= 78; i=i+1) begin : _set_cnt
    always @(posedge clk) begin
        if( (in_buf & act) == 1'd1) begin
            if(i==78) cnt[i] <= 1'd1;
            else cnt[i] <= 1'd0;
        end
        else begin
            if(i==78) cnt[i] <= 1'd1;
            else cnt[i] <= cnt[i+1];
        end
    end
end

endgenerate



always @(posedge clk) begin
    if( (in_buf & act) == 1'd1) begin
        act <= 1'd0;
        
    end
    else if(cnt[0] == 1'd0) begin
        act <= 1'd0;
    end
    else if(in == 1'd0 && cnt[0] == 1'd1)  begin
            act <= 1'd1;
    end
end

assign out = in & act;

endmodule
