
`timescale 1ns / 1ps

module tb_psum_manager;

    parameter SMALL_BANK_COUNT = 3;
    parameter BIG_BANK_COUNT = 3;
    parameter TOTAL_BANK_COUNT = SMALL_BANK_COUNT + BIG_BANK_COUNT;
    parameter BANK_INDEX_WIDTH = $clog2(TOTAL_BANK_COUNT);
    parameter SMALL_THRESHOLD = 16;
    parameter ADDR_WIDTH = 8;
    parameter GPR_WIDTH = 6;

    // Inputs
    reg clk;
    reg reset;
    reg new_stage;
    reg [ADDR_WIDTH-1:0] seq1_length;
    reg [GPR_WIDTH-1:0] seq2_length;
    reg [GPR_WIDTH-1:0] operation_id;
    reg write_enable;

    // Outputs
    wire operation_done;
    wire [BANK_INDEX_WIDTH-1:0] write_bank_index;
    wire [ADDR_WIDTH-1:0] write_address;
    wire [ADDR_WIDTH-1:0] read_address;
    wire [BANK_INDEX_WIDTH-1:0] read_bank_index;
    wire read_bank_valid;
    wire busy;
    wire stall;

    // Instantiate the module under test
    psum_manager #(
        .SMALL_BANK_COUNT(SMALL_BANK_COUNT),
        .BIG_BANK_COUNT(BIG_BANK_COUNT),
        .TOTAL_BANK_COUNT(TOTAL_BANK_COUNT),
        .BANK_INDEX_WIDTH(BANK_INDEX_WIDTH),
        .SMALL_THRESHOLD(SMALL_THRESHOLD),
        .ADDR_WIDTH(ADDR_WIDTH),
        .GPR_WIDTH(GPR_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .new_stage(new_stage),
        .seq1_length(seq1_length),
        .seq2_length(seq2_length),
        .operation_id(operation_id),
        .operation_done(operation_done),
        .write_bank_index(write_bank_index),
        .write_address(write_address),
        .write_enable(write_enable),
        .read_address(read_address),
        .read_bank_index(read_bank_index),
        .read_bank_valid(read_bank_valid),
        .busy(busy),
        .stall(stall)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Stimulus
    initial begin
        // Initial values
        reset = 1;
        new_stage = 0;
        seq1_length = 0;
        seq2_length = 0;
        operation_id = 0;
        write_enable = 0;

        // Release reset
        #20;
        reset = 0;

        // Start new operation: small bank
        #10;
        seq1_length = 8;
        seq2_length = 3;
        operation_id = 6'd1;
        new_stage = 1;
        #10;
        new_stage = 0;

        // Simulate write_enable
        repeat (24) begin
            #10;
            write_enable = 1;
            #10;
            write_enable = 0;
        end

        // Wait for operation done
        wait(operation_done == 1);
        $display("Operation %d done", operation_id);

        // Another operation: big bank
        #50;
        seq1_length = 20;
        seq2_length = 2;
        operation_id = 6'd2;
        new_stage = 1;
        #10;
        new_stage = 0;

        repeat (40) begin
            #10;
            write_enable = 1;
            #10;
            write_enable = 0;
        end

        wait(operation_done == 1);
        $display("Operation %d done", operation_id);

        #100;
        $finish;
    end

endmodule
