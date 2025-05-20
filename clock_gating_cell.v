module cgc (
    input  wire clk,       
    input  wire en,       
    output wire gclk     
);

    reg en_latched;

    // Latch: transparent when clk is low
    always @ (clk or en) begin
        if (!clk)
            en_latched <= en;
    end

    // AND gate: generates gated clock
    assign gclk = clk & en_latched;

endmodule
