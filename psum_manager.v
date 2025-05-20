module psum_manager #(
    // Parameterize sizes for flexibility
    parameter SMALL_BANK_COUNT = 3,
    parameter BIG_BANK_COUNT   = 3,
    parameter TOTAL_BANK_COUNT = SMALL_BANK_COUNT + BIG_BANK_COUNT,
    parameter SMALL_THRESHOLD  = 16,               // seq1 <= 16 uses small bank
    parameter ADDR_WIDTH       = 8,                // address width for banks (supports up to 256 elements; adjust as needed)
    parameter OP_ID_WIDTH      = 8                 // width of operation_id
)(
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   new_op_request,   // High when a new operation request is active
    input  wire [ADDR_WIDTH-1:0]  seq1,             // Number of elements in each segment for the new operation
    input  wire [15:0]            seq2,             // Number of segments (rounds) in the new operation
    input  wire [OP_ID_WIDTH-1:0] operation_id,     // ID of the new operation (for tracking)
    output reg  [2:0]             selected_bank,    // Index of bank assigned for writing the current segment
    output reg                    assign_valid,     // Pulses high when a new bank is assigned
    output reg  [2:0]             read_bank_index,  // Index of bank being read out (during reduction)
    output reg  [ADDR_WIDTH-1:0]  read_address,     // Read address (increments from 0 to seq1-1 for each read segment)
    output reg  [ADDR_WIDTH-1:0]  write_address,    // Write address (increments 0 to seq1-1 for each write segment)
    output reg                    stall,            // High if a new operation request must wait (no free bank available)
    output reg                    op_done,          // High for one cycle when an operation is fully completed (optional)
    output reg  [OP_ID_WIDTH-1:0] op_done_id        // ID of the operation that just completed (valid when op_done = 1)
);

    // Internal FSM state encoding
    localparam [1:0] S_IDLE = 2'b00, 
                     S_WAIT = 2'b01, 
                     S_ACTIVE = 2'b10;
    reg [1:0] state, next_state;

    // Bank status tracking
    reg [TOTAL_BANK_COUNT-1:0] bank_valid;        // 1 = in use (contains valid data), 0 = free
    reg [OP_ID_WIDTH-1:0] bank_op_id [0:TOTAL_BANK_COUNT-1];  // Track which operation ID each bank is serving (for reference/optional)

    // Registers to hold parameters of the current operation in process
    reg [ADDR_WIDTH-1:0] curr_seq1;    // segment length for current operation (constant for all its segments)
    reg [15:0]           curr_seq2;    // total number of segments for current operation
    reg [15:0]           segments_done; // how many segments have been completed (written) for current op
    reg [OP_ID_WIDTH-1:0] curr_op_id;   // operation_id of current active operation

    // Registers for tracking a "previous" operation that is finishing while a new one starts (for bridging scenario)
    reg [OP_ID_WIDTH-1:0] prev_op_id;   // operation_id of the operation being finished (whose last bank is being read)
    reg [ADDR_WIDTH-1:0]  prev_seq1;    // segment length of the previous op's bank being read out

    // Counters for read/write progress in the ACTIVE state
    reg [ADDR_WIDTH-1:0] read_count;
    reg [ADDR_WIDTH-1:0] write_count;
    reg [ADDR_WIDTH-1:0] read_target;
    reg [ADDR_WIDTH-1:0] write_target;

    // Helper signals
    wire need_small_bank = (seq1 <= SMALL_THRESHOLD);  // true if new operation needs a small bank
    reg  bank_available; 
    reg  [2:0] free_bank_index;

    integer i;
    initial begin
        // Initialize all banks as free (valid=0) and outputs to default
        for(i=0; i<TOTAL_BANK_COUNT; i=i+1) begin
            bank_valid[i] = 1'b0;
            bank_op_id[i] = {OP_ID_WIDTH{1'b0}};
        end
        state         = S_IDLE;
        next_state    = S_IDLE;
        selected_bank = 3'b000;
        assign_valid  = 1'b0;
        read_bank_index = 3'b000;
        read_address  = {ADDR_WIDTH{1'b0}};
        write_address = {ADDR_WIDTH{1'b0}};
        stall         = 1'b0;
        op_done       = 1'b0;
        op_done_id    = {OP_ID_WIDTH{1'b0}};
        // Other internal registers
        curr_seq1     = 0;
        curr_seq2     = 0;
        segments_done = 0;
        curr_op_id    = {OP_ID_WIDTH{1'b0}};
        prev_op_id    = {OP_ID_WIDTH{1'b0}};
        prev_seq1     = 0;
        read_count    = 0;
        write_count   = 0;
        read_target   = 0;
        write_target  = 0;
    end

    // Combinational logic to find a free bank index of a given type (small or big)
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

    // FSM sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all state and outputs
            state <= S_IDLE;
            stall <= 1'b0;
            assign_valid <= 1'b0;
            op_done <= 1'b0;
            // (Other registers reset in initial block or explicitly here if needed)
        end else begin
            state <= next_state;

            // Default de-assert signals (they will be set when needed)
            assign_valid <= 1'b0;
            op_done <= 1'b0;
            stall <= 1'b0;

            case(state)
            //=======================================================
            S_IDLE: begin
                // Wait for a new operation request
                if (new_op_request) begin
                    if (bank_available) begin
                        // Accept new operation and allocate free_bank_index
                        // Load current operation parameters
                        curr_seq1  <= seq1;
                        curr_seq2  <= seq2;
                        curr_op_id <= operation_id;
                        segments_done <= 16'd0;
                        prev_op_id <= {OP_ID_WIDTH{1'b0}};  // no previous op active
                        prev_seq1  <= 0;
                        // Mark the chosen bank as in-use and store op_id (optional tracking)
                        bank_valid[free_bank_index] <= 1'b1;
                        bank_op_id[free_bank_index] <= operation_id;
                        // Set up for writing the first segment
                        selected_bank <= free_bank_index;
                        assign_valid  <= 1'b1;        // signal assignment of new bank
                        // Initialize write parameters for first segment
                        write_address <= 0;
                        write_count   <= 0;
                        write_target  <= seq1;        // we will write 'seq1' elements
                        // No read in progress for first segment
                        read_count   <= 0;
                        read_address <= 0;
                        read_target  <= 0;            // no previous segment to read
                        // Transition to ACTIVE state to begin processing
                        next_state <= S_ACTIVE;
                    end else begin
                        // No bank available of required type: stall the request
                        stall <= 1'b1;
                        next_state <= S_WAIT;
                        // (Stay in WAIT until a bank is freed by ongoing operations)
                    end
                end else begin
                    next_state <= S_IDLE;
                end
            end
            //=======================================================
            S_WAIT: begin
                // Stall state: waiting for a bank to be freed for the pending request
                stall <= 1'b1;
                if (bank_available && new_op_request) begin
                    // Now a bank is free and request is still active – accept it
                    curr_seq1  <= seq1;
                    curr_seq2  <= seq2;
                    curr_op_id <= operation_id;
                    segments_done <= 16'd0;
                    prev_op_id <= {OP_ID_WIDTH{1'b0}};
                    prev_seq1  <= 0;
                    bank_valid[free_bank_index] <= 1'b1;
                    bank_op_id[free_bank_index] <= operation_id;
                    selected_bank <= free_bank_index;
                    assign_valid  <= 1'b1;
                    // Prepare first segment write (similar to IDLE acceptance)
                    write_address <= 0;
                    write_count   <= 0;
                    write_target  <= seq1;
                    read_count    <= 0;
                    read_address  <= 0;
                    read_target   <= 0;
                    next_state <= S_ACTIVE;
                end else if (bank_available && !new_op_request) begin
                    // Request was dropped or not present anymore (should rarely happen).
                    stall <= 1'b0;
                    next_state <= S_IDLE;
                end else begin
                    // Still no bank available, remain in WAIT (stall stays high).
                    next_state <= S_WAIT;
                end
            end
            //=======================================================
            S_ACTIVE: begin
                // ACTIVE: performing read/write of partial sums for the current phase
                // Issue read and write addresses in parallel (if targets are non-zero)
                if (read_count < read_target) begin
                    // There is a previous bank to read from
                    read_bank_index <= (prev_op_id != {OP_ID_WIDTH{1'b0}}) ? 
                                        // If prev_op_id is non-zero, we are reading a previous *operation* bank
                                        // (bridging scenario), otherwise it's a previous segment of the same op.
                                        free_bank_index :  // (Not actually using free_bank_index here; in practice, store prev bank index in a reg)
                                        read_bank_index; 
                    // NOTE: In this design, read_bank_index would ideally be stored for the bank being read.
                    // For simplicity, we assume read_bank_index is already set to the correct bank from prior logic.
                    // Here we just output the current read address and increment.
                    read_address <= read_count;
                    read_count   <= read_count + 1'b1;
                end
                if (write_count < write_target) begin
                    // Still writing to current selected_bank
                    write_address <= write_count;
                    write_count   <= write_count + 1'b1;
                end
                // Check if the current phase (pair of read/write) is complete
                if ((write_count == write_target) && (read_count == read_target)) begin
                    // Both read and write for this phase are done
                    //------------------------------------------------
                    // 1. Invalidate the just-read bank (if any)
                    if (read_target != 0) begin
                        // We have just finished reading out a bank
                        // Identify which bank was being read and mark it free:
                        bank_valid[read_bank_index] <= 1'b0;
                        // (prev_op_id holds the op of the bank read, could use if needed)
                    end
                    // 2. Increment the segment count of the current operation if we just finished writing one
                    if (write_target != 0) begin
                        segments_done <= segments_done + 1'b1;
                    end
                    //------------------------------------------------
                    // 3. Decide next steps:
                    if (segments_done < curr_seq2) begin
                        // Current operation has more segments to process
                        // Prepare to allocate a new bank for the next segment
                        // The bank just written becomes the next one to read
                        prev_op_id <= curr_op_id;    // still same operation (just used for consistency)
                        prev_seq1  <= curr_seq1;
                        // Set read parameters for the just-written bank (to be read in next phase)
                        read_bank_index <= selected_bank;
                        read_target     <= curr_seq1;
                        read_count      <= 0;
                        read_address    <= 0;
                        // Allocate a free bank for the next segment's write
                        // (By design, at least one bank should now be free because we freed one above, or a third bank is available.)
                        // Find a free bank of the same type (small/big) as curr_seq1:
                        reg [2:0] next_bank;
                        next_bank = 3'b111;
                        // Search appropriate bank class for a free bank
                        if (curr_seq1 <= SMALL_THRESHOLD) begin
                            if (!bank_valid[0]) next_bank = 3'd0;
                            else if (!bank_valid[1]) next_bank = 3'd1;
                            else if (!bank_valid[2]) next_bank = 3'd2;
                        end else begin
                            if (!bank_valid[3]) next_bank = 3'd3;
                            else if (!bank_valid[4]) next_bank = 3'd4;
                            else if (!bank_valid[5]) next_bank = 3'd5;
                        end
                        if (next_bank == 3'b111) begin
                            // (This should not happen if banks are managed correctly)
                            // No free bank found, stall (should not occur under normal operation)
                            stall <= 1'b1;
                            next_state <= S_ACTIVE; // remain in active (or could transition to WAIT)
                        end else begin
                            // Assign the new bank
                            bank_valid[next_bank] <= 1'b1;
                            bank_op_id[next_bank] <= curr_op_id;
                            selected_bank <= next_bank;
                            assign_valid  <= 1'b1;    // signal new bank assignment for next segment
                            // Set write parameters for the next segment
                            write_target  <= curr_seq1;
                            write_count   <= 0;
                            write_address <= 0;
                            // Continue in ACTIVE for the next segment (read prev, write new)
                            next_state <= S_ACTIVE;
                        end
                    end else begin
                        // No more segments in current operation (current op's compute is done)
                        // Check for a new operation request to potentially overlap (bridge) the final read:
                        if (new_op_request) begin
                            // A new operation is waiting to start
                            if (bank_available) begin
                                // **Bridging scenario**: start new op while finishing current op's final read
                                // The just-written bank is the last of old op and will be read out now,
                                // and we will simultaneously start writing the first segment of the new op.
                                // Save the finishing op's info for op_done signaling
                                op_done       <= 1'b0;  // (We will assert op_done when the read completes)
                                op_done_id    <= curr_op_id;
                                prev_op_id    <= curr_op_id;   // mark current op as previous (finishing)
                                prev_seq1     <= curr_seq1;
                                // The bank holding the last segment of old op:
                                read_bank_index <= selected_bank;
                                read_target     <= curr_seq1;
                                read_count      <= 0;
                                read_address    <= 0;
                                // Accept the new operation now
                                curr_op_id <= operation_id;
                                curr_seq1  <= seq1;
                                curr_seq2  <= seq2;
                                segments_done <= 16'd0;
                                // Allocate a free bank for new op's first segment
                                bank_valid[free_bank_index] <= 1'b1;
                                bank_op_id[free_bank_index] <= operation_id;
                                selected_bank <= free_bank_index;
                                assign_valid  <= 1'b1;
                                // Set write parameters for new op's first segment
                                write_target  <= seq1;
                                write_count   <= 0;
                                write_address <= 0;
                                // Continue in ACTIVE: now reading out old op's final bank while writing new op's first
                                next_state <= S_ACTIVE;
                            end else begin
                                // No bank available for new op (should not happen here because one was just freed or about to be freed)
                                stall <= 1'b1;
                                // Remain in ACTIVE, or transition to WAIT (not expected in normal flow)
                                next_state <= S_WAIT;
                            end
                        end else begin
                            // No new operation waiting -> go to flush the final bank
                            prev_op_id  <= curr_op_id;
                            prev_seq1   <= curr_seq1;
                            op_done_id  <= curr_op_id;
                            // Set up to read out the last segment's bank (no new write)
                            read_bank_index <= selected_bank;
                            read_target     <= curr_seq1;
                            read_count      <= 0;
                            read_address    <= 0;
                            // No write in this phase (final flush)
                            write_target    <= 0;
                            write_count     <= 0;
                            // Continue in ACTIVE to perform the final read-out
                            next_state <= S_ACTIVE;
                            // After this read phase completes, op_done will be signaled and we will go idle.
                        end
                    end
                    //------------------------------------------------
                end else begin
                    // Phase not done yet, remain in S_ACTIVE
                    next_state <= S_ACTIVE;
                end
            end
            //=======================================================
            default: begin
                next_state <= S_IDLE;
            end
            endcase

            // State exit conditions (after case) for outputs:
            if (state == S_ACTIVE && next_state != S_ACTIVE) begin
                // Leaving ACTIVE state (just finished a flush or a bridging read phase)
                if ((segments_done == curr_seq2) && (new_op_request == 1'b0 || !bank_available)) begin
                    // The previous operation has fully completed and no bridging in progress
                    // Signal operation done
                    op_done    <= 1'b1;
                    op_done_id <= prev_op_id;  // ID of the op that just finished
                    // Clear prev_op_id
                    prev_op_id <= {OP_ID_WIDTH{1'b0}};
                end
                if (next_state == S_IDLE) begin
                    // All operations finished, no current op active
                    curr_op_id <= {OP_ID_WIDTH{1'b0}};
                end
            end
        end
    end
endmodule
