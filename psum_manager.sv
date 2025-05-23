module psum_manager #(
    parameter SMALL_BANK_COUNT  = 3,
    parameter BIG_BANK_COUNT    = 3,
    parameter TOTAL_BANK_COUNT  = SMALL_BANK_COUNT + BIG_BANK_COUNT,
    parameter BANK_INDEX_WIDTH  = $clog2(TOTAL_BANK_COUNT),
    parameter SMALL_THRESHOLD   = 16,
    parameter ADDR_WIDTH        = 8,        // depth of Big memory: 8 --> 256 depth
    parameter GPR_WIDTH         = 6         // Same as the OP_ID_WIDTH
)(
    input                                       clk,
    input                                       reset,

    input                                       new_stage,          // High when a new stage request is active
    output  reg                                 new_stage_ack,      // Ack signal indicating that new stage has been acknowledge & values have been registered 
    input   [ADDR_WIDTH-1:0]                    seq1_length,        // Input sequence length
    input   [GPR_WIDTH-1:0]                     seq2_length,        // Reduction rank

    input   [GPR_WIDTH-1:0]                     operation_id,       // Operation ID for a particular stage
    output                                      operation_done,     // Done with the current stage STATUS signal
    output  reg                                 bank_available,

    output  [BANK_INDEX_WIDTH-1:0]              write_bank_index,   // Bank index for writing from ARRAY
    output  [ADDR_WIDTH-1:0]                    write_address,
    input                                       write_enable,       // Also used to increment read address during reduction

    output  [ADDR_WIDTH-1:0]                    read_address,
    output  [BANK_INDEX_WIDTH-1:0]              read_bank_index,    // Bank index to be read for reduction operation
    output                                      read_bank_valid,    // Valid for read to be used in reuction operation
    output                                      busy,               // Signal indicating that FSM is busy and asks to stall the next stage
    output                                      stall,               // indicating the controller to halt

    // Interfacing with Psum Read Controller
    output  [GPR_WIDTH*TOTAL_BANK_COUNT-1:0]    bank_op_id_flat,    // Outputs the operation tag of memories
    output  [TOTAL_BANK_COUNT-1:0]              bank_valid_out,     // Outputs the valid input content in memories
    input   [TOTAL_BANK_COUNT-1:0]              bank_clear_in       // Read Controller Clears the valid bit after: Default value {all 1's}. RC will drive one bit to 0 for 1 cycle indicating that Psum bank has been read and can be used to store new values  



//    output                           
);


//FSM STATES
localparam [2:0] IDLE               = 3'b000;       // Utter Joblessness
localparam [2:0] REG_SETUP          = 3'b001;       // Captures Operation values 
localparam [2:0] BANK_SETUP         = 3'b010;       // Selects Banks for dumping PSUM
localparam [2:0] OPERATION1         = 3'b011;       // Normal operation
localparam [2:0] OPERATION2         = 3'b100;       // Reduction operation
localparam [2:0] REDUCTION_CHECK    = 3'b101;       // Reduction need checker
localparam [2:0] REDUCTION_SETUP    = 3'b110;       // Bank setup for Reduction operation
localparam [2:0] OP_DONE            = 3'b111;       

// regs
reg [2:0] state;

// o/p regs
reg                             operation_done_q;  
reg   [BANK_INDEX_WIDTH-1:0]    write_bank_index_q;
reg   [ADDR_WIDTH-1:0]          write_address_q;
reg   [ADDR_WIDTH-1:0]          read_address_q;
reg   [BANK_INDEX_WIDTH-1:0]    read_bank_index_q; 
reg                             read_bank_valid_q; 
reg                             stall_q, busy_q;     

// bank status regs
reg   [TOTAL_BANK_COUNT-1:0]    bank_valid;                         // 1 = in use (contains valid data), 0 = free
reg   [GPR_WIDTH-1:0]           bank_op_id [0:TOTAL_BANK_COUNT-1];  // Track which operation ID each bank is serving (for reference/optional)
reg   [BANK_INDEX_WIDTH-1:0]    free_bank_index;                    // points to the free bank

// stage status regs
reg                             counter1_load, counter1_load_q;
reg                             counter2_load, counter2_load_q, counter2_dec;
reg   [ADDR_WIDTH-1:0]          counter_seq1;
reg   [GPR_WIDTH-1:0]           counter_seq2;
reg   [ADDR_WIDTH-1:0]          seq1_length_q;
reg   [GPR_WIDTH-1:0]           seq2_length_q;
reg   [GPR_WIDTH-1:0]           curr_op_id;

//wire
wire                            need_small_bank;

// assignments
assign need_small_bank  = (seq1_length_q < SMALL_THRESHOLD)? 1 : 0; 
assign operation_done   = operation_done_q;

assign write_address    = write_address_q;
assign write_bank_index = write_bank_index_q;

assign read_bank_index  = read_bank_index_q;
assign read_bank_valid  = read_bank_valid_q;
assign read_address     = read_address_q;

assign stall            = stall_q;
assign busy             = busy_q;

// Logic for selecting bank
integer i;

always @(*) begin
        free_bank_index = 3'b111;   // default "none" (out of range index)
        bank_available  = 1'b0;
        if (need_small_bank) begin
            // Search small bank 0..2 for a free one
            if (!bank_valid[0]) begin
                free_bank_index = 3'd0;
                bank_available  = 1'b1;
            end else if (!bank_valid[1]) begin
                free_bank_index = 3'd1;
                bank_available  = 1'b1;
            end else if (!bank_valid[2]) begin
                free_bank_index = 3'd2;
                bank_available  = 1'b1;
            end else begin
                // no small bank free
                bank_available  = 1'b0;
            end
        end else begin
            // Search big bank 3..5 for a free one
            if (!bank_valid[3]) begin
                free_bank_index = 3'd3;
                bank_available  = 1'b1;
            end else if (!bank_valid[4]) begin
                free_bank_index = 3'd4;
                bank_available  = 1'b1;
            end else if (!bank_valid[5]) begin
                free_bank_index = 3'd5;
                bank_available  = 1'b1;
            end else begin
                // no big bank free
                bank_available  = 1'b0;
            end
        end
    end

// address incrementor

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter_seq1        <=  {ADDR_WIDTH{1'b1}};
        counter_seq2        <=  {GPR_WIDTH{1'b1}};
        counter1_load_q     <=  1'b0;
        counter2_load_q     <=  1'b0;
    end else begin
        counter1_load_q     <= counter1_load; 
        counter2_load_q     <= counter2_load; 
        counter_seq1        <= (counter1_load & ~counter1_load_q)?  seq1_length_q : (stall_q ? counter_seq1 : counter_seq1 - write_enable);
        counter_seq2        <= (counter2_load & ~counter2_load_q)?  seq2_length_q : counter_seq2 - counter2_dec;
    end

end


// PSum controller FSM

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state               <=  IDLE;
        seq1_length_q       <=  0;
        seq2_length_q       <=  0;
        stall_q             <=  1'b0;
        busy_q              <=  1'b0;
        read_bank_valid_q   <=  1'b0;
        operation_done_q    <=  1'b0;
        write_bank_index_q  <=  {BANK_INDEX_WIDTH{1'b0}};
        read_bank_index_q   <=  {BANK_INDEX_WIDTH{1'b0}};
        write_address_q     <=  {ADDR_WIDTH{1'b0}};
        read_address_q      <=  {ADDR_WIDTH{1'b0}};
        new_stage_ack       <=  1'b0;
        for (i = 0; i < TOTAL_BANK_COUNT; i = i + 1) begin
            bank_op_id[i] <= {GPR_WIDTH{1'b0}};
        end
        //bank_op_id          <=  {(TOTAL_BANK_COUNT*GPR_WIDTH){1'b0}};
        bank_valid          <=  {TOTAL_BANK_COUNT{1'b0}};
        counter1_load       <=  1'b0;
        counter2_load       <=  1'b0;
        counter2_dec        <=  1'b0;
    end

    else begin
    
        case(state)
            IDLE: begin
                stall_q             <=  1'b0;
                busy_q              <=  1'b0;
                read_bank_valid_q   <=  1'b0;
                operation_done_q    <=  1'b0;
                write_bank_index_q  <=  {BANK_INDEX_WIDTH{1'b0}};
                read_bank_index_q   <=  {BANK_INDEX_WIDTH{1'b0}};
                write_address_q     <=  {ADDR_WIDTH{1'b0}};
                read_address_q      <=  {ADDR_WIDTH{1'b0}};
                bank_valid          <=  bank_valid & bank_clear_in;
                counter1_load       <=  1'b0;
                counter2_load       <=  1'b0;
                counter2_dec        <=  1'b0;

                if (new_stage) begin
                    state           <= REG_SETUP;
                end else begin
                    state           <= IDLE;
                end
            end

            REG_SETUP: begin
                busy_q              <=  1'b1;
                seq1_length_q       <=  seq1_length;
                seq2_length_q       <=  seq2_length;
                curr_op_id          <=  operation_id;
                stall_q             <=  write_enable;
                new_stage_ack       <=  new_stage;
                write_address_q     <=  0;
                bank_valid          <=  bank_valid & bank_clear_in;

                if (new_stage)  begin
                    state           <=  BANK_SETUP;
                end else begin
                    state           <= IDLE;
                end
            end

            BANK_SETUP: begin
                // status
                busy_q                      <= 1'b1;
                stall_q                     <= write_enable;
                write_address_q             <= 0;
                new_stage_ack               <= 1'b0;

                // bank indexing
                //bank_valid[free_bank_index] <= 1'b1;
                bank_valid                  <= (bank_valid & bank_clear_in) | (1'b1 << free_bank_index);
                bank_op_id[free_bank_index] <= curr_op_id; 
                write_bank_index_q          <= free_bank_index;
                state                       <= OPERATION1;

            end

            OPERATION1: begin
                // status
                busy_q              <=  1'b1;
                counter1_load       <=  1'b1;
                counter2_load       <=  1'b1;
                stall_q             <=  1'b0;
                bank_valid          <=  bank_valid & bank_clear_in;

                //operation
                write_address_q     <=  stall_q ? write_address_q : write_address_q + write_enable;

                if (counter_seq1 <= 2) begin
                    counter2_dec    <=  1'b1;
                    counter2_load   <=  1'b0;
                    counter1_load   <=  1'b0;                
                    stall_q         <=  1'b1;
                    state           <=  REDUCTION_CHECK;
                end else begin
                    state           <=  OPERATION1;
                end

            end

            REDUCTION_CHECK: begin
                busy_q              <=  1'b1;
                stall_q             <=  1'b1;
                counter2_dec        <=  1'b0;
                read_bank_valid_q   <=  1'b0;
                bank_valid          <=  bank_valid & bank_clear_in;
                if (counter_seq2 > 1) begin
                    read_address_q  <=  0;
                    write_address_q <=  0;
                    state           <=  REDUCTION_SETUP;

                end else begin
                    state                       <= IDLE;
                    operation_done_q            <= 1'b1;
                end
            end

            REDUCTION_SETUP: begin
                busy_q                      <=  1'b1;
                stall_q                     <=  1'b1;
                read_bank_valid_q           <=  1'b1;
                counter1_load               <=  1'b1;
                read_address_q              <=  0;
                write_address_q             <=  0;
                counter2_dec                <=  1'b0;
                state                       <=  OPERATION2;

                // bank selection
                //bank_valid[free_bank_index] <=  1'b1;
                bank_valid                  <= (bank_valid & bank_clear_in) | (1'b1 << free_bank_index);
                bank_op_id[free_bank_index] <=  curr_op_id;
                write_bank_index_q          <=  free_bank_index; 
                read_bank_index_q           <=  write_bank_index;

            end

            OPERATION2: begin
                busy_q              <=  1'b1;
                stall_q             <=  1'b0;
                read_bank_valid_q   <=  1'b1;
                write_address_q     <=  stall_q ? write_address_q : write_address_q + write_enable;
                read_address_q      <=  stall_q ? read_address_q  : read_address_q  + write_enable;
                if (counter_seq1 == 2) begin
                    counter2_dec                    <= 1'b1;
                    counter2_load                   <= 1'b0;
                    counter1_load                   <= 1'b0;                
                    stall_q                         <= 1'b1;
                    //bank_valid[read_bank_index_q]   <= 1'b0;
                    bank_valid                      <= (bank_valid & bank_clear_in) & ~(1'b1 << read_bank_index_q); // invalidting psum memory which has been read
                    state                           <= (counter_seq2==1)? IDLE : REDUCTION_SETUP;
                    operation_done_q                <= (counter_seq2==1)? 1'b1 : operation_done_q;

                end else begin
                    state                           <= OPERATION2;
                end

            end
        endcase
    end
end


// Interfacing with Psum Read Controller

genvar j;
generate
    for (j = 0; j < TOTAL_BANK_COUNT; j = j + 1) begin : flatten
        assign bank_op_id_flat[j*GPR_WIDTH +: GPR_WIDTH] = bank_op_id[j];
    end
endgenerate

assign bank_valid_out      =    bank_valid;


endmodule




//reg [BANK_INDEX_WIDTH-1:0] idx;  // Index register to hold current bank index (avoids slicing issues)
//
//always @(*) begin
//    // Default: no available bank found
//    free_bank_index = {BANK_INDEX_WIDTH{1'b1}};  // all 1's = invalid index sentinel
//    bank_available  = 1'b0;
//    idx             = {BANK_INDEX_WIDTH{1'b0}}; 
//
//    if (need_small_bank) begin
//        // indices 0 to SMALL_BANK_COUNT-1
//        for (i = 0; i < SMALL_BANK_COUNT; i = i + 1) begin
//            idx = i; 
//            if (!bank_valid[idx] && !bank_available) begin
//                free_bank_index = idx;
//                bank_available  = 1'b1;
//            end
//        end
//    end else begin
//        // indices SMALL_BANK_COUNT to TOTAL_BANK_COUNT-1
//        for (i = SMALL_BANK_COUNT; i < TOTAL_BANK_COUNT; i = i + 1) begin
//            idx = i;
//            if (!bank_valid[idx] && !bank_available) begin
//                free_bank_index = idx;
//                bank_available  = 1'b1;
//            end
//        end
//    end
//end

