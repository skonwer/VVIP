
`timescale 1ns / 1ps

module tb_psum_manager;

    parameter ADDR_WIDTH = 8;
    parameter OP_ID_WIDTH = 8;

    // Inputs
    reg clk;
    reg reset;
    reg new_op_request;
    reg [ADDR_WIDTH-1:0] seq1;
    reg [15:0] seq2;
    reg [OP_ID_WIDTH-1:0] operation_id;

    // Outputs
    wire [2:0] selected_bank;
    wire assign_valid;
    wire [2:0] read_bank_index;
    wire [ADDR_WIDTH-1:0] read_address;
    wire [ADDR_WIDTH-1:0] write_address;
    wire stall;
    wire op_done;
    wire [OP_ID_WIDTH-1:0] op_done_id;

    // Instantiate the Unit Under Test (UUT)
    psum_manager uut (
        .clk(clk),
        .reset(reset),
        .new_op_request(new_op_request),
        .seq1(seq1),
        .seq2(seq2),
        .operation_id(operation_id),
        .selected_bank(selected_bank),
        .assign_valid(assign_valid),
        .read_bank_index(read_bank_index),
        .read_address(read_address),
        .write_address(write_address),
        .stall(stall),
        .op_done(op_done),
        .op_done_id(op_done_id)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Stimulus
    initial begin
        $display("Starting testbench...");
        // Initialize Inputs
        reset = 1;
        new_op_request = 0;
        seq1 = 0;
        seq2 = 0;
        operation_id = 0;

        // Wait 20ns and release reset
        #20;
        reset = 0;

        // Issue first operation request (should use small bank)
        #10;
        seq1 = 8;  // small
        seq2 = 3;
        operation_id = 8'h01;
        new_op_request = 1;
        #10;
        new_op_request = 0;

        // Wait for operation to complete
        wait(op_done);
        $display("Operation %d done", op_done_id);

        // Issue second operation request (should use big bank)
        #20;
        seq1 = 20;  // big
        seq2 = 2;
        operation_id = 8'h02;
        new_op_request = 1;
        #10;
        new_op_request = 0;

        wait(op_done);
        $display("Operation %d done", op_done_id);

        // Test multiple overlapping operations
        #20;
        seq1 = 8;
        seq2 = 2;
        operation_id = 8'h03;
        new_op_request = 1;
        #10;
        new_op_request = 0;

        #40;
        seq1 = 20;
        seq2 = 2;
        operation_id = 8'h04;
        new_op_request = 1;
        #10;
        new_op_request = 0;

        wait(op_done);
        $display("Operation %d done", op_done_id);

        wait(op_done);
        $display("Operation %d done", op_done_id);

        #50;
        $finish;
    end

endmodule
