// System has 32 General Purpose Regs
// each reg is 6 bit 
// 1 write 2 simultaneous read
//------------------------------------------

module gpr #(
    parameter BW=6,
    parameter COUNT=32,
    parameter ADDR=$clog2(COUNT)
) (
    input               clk,
    input               reset,
    input               we_n,           // 0-enable; 1-disable
    input [ADDR-1:0]    w_addr,
    input [ADDR-1:0]    r1_addr,
    input [ADDR-1:0]    r2_addr,
    input [BW-1:0]      w_data,
    output[BW-1:0]      r1_data,
    output[BW-1:0]      r2_data,
);

reg [BW-1:0] GPR [COUNT-1:0];

// First few registers contains the default RANK values as POR
always @(posedge clk or posedge reset) begin
    if (reset) begin
        GPR[0]      <= 6'd12;
        GPR[1]      <= 6'd8;
        GPR[2]      <= 6'd8;
        GPR[3]      <= 6'd8;
        GPR[4]      <= 6'd8;
        GPR[5]      <= 6'd12;
        GPR[6]      <= 6'd12;
        GPR[7]      <= 6'd30;
        GPR[8]      <= 6'd30;
        GPR[9]      <= 6'd30;
        GPR[10]     <= 6'd12;
        GPR[11]     <= 6'd10;
        integer i;
        
        for (i = 12; i < COUNT; i = i+1)
            GPR[i]  <= 6'd0;
    end
    else if (!we_n) begin
        GPR[w_addr] <= w_data;
    end
end

assign  r1_data = GPR[r1_addr];
assign  r2_data = GPR[r2_addr];


endmodule
