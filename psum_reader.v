module psum_reader #(
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
    
    // start and halt signals
    input                                       start_read,
    input                                       stall,

    // fsm setup
    input   [GPR_WIDTH-1:0]                     read_operation_id,
    input   [ADDR_WIDTH-1:0]                    read_seq_length,

    // psum status
    input   [TOTAL_BANK_COUNT*GPR_WIDTH-1:0]    bank_op_id_flat,
    input   [TOTAL_BANK_COUNT-1:0]              bank_valid,

    // status output
    output                                      busy,
    output                                      no_match,
    output                                      req_rejected,
    output                                      req_accepted,

    // psum out
    output                                      read_valid,
    output  [ADDR_WIDTH-1:0]                    psum_read_address,
    output  [BANK_INDEX_WIDTH-1:0]              psum_bank_index,   // read_bank_index
    output  [TOTAL_BANK_COUNT-1:0]              bank_clear_out


);

// FSM states
localparam  [1:0]   IDLE    = 2'b00;
localparam  [1:0]   SETUP   = 2'b01;
localparam  [1:0]   READ    = 2'b10;
//localparam  [1:0]   CLEAR   = 2'b11;

integer i;

// regs
reg                         no_match_q;
reg                         busy_q;
reg                         req_rejected_q;
reg                         req_accepted_q;
reg [BANK_INDEX_WIDTH-1:0]  bank_clear_out_q;
reg [BANK_INDEX_WIDTH-1:0]  psum_bank_index_q;  
reg [ADDR_WIDTH-1:0]        psum_read_address_q;
reg                         read_valid_q;

reg                         match_found;
reg [ADDR_WIDTH-1:0]        length_counter;
reg [BANK_INDEX_WIDTH-1:0]  temp_index;
reg [1:0]                   state;

// assignments
assign  no_match            =   no_match_q;
assign  busy                =   busy_q;
assign  req_rejected        =   req_rejected_q;
assign  req_accepted        =   req_accepted_q;
assign  bank_clear_out      =   bank_clear_out_q;
assign  psum_bank_index     =   psum_bank_index_q;  
assign  psum_read_address   =   psum_read_address_q;
assign  read_valid          =   read_valid_q;

// wire
wire [GPR_WIDTH-1:0] bank_op_id [0:TOTAL_BANK_COUNT-1];

// unflattening of bank op id
genvar k;
generate
    for (k = 0; k < TOTAL_BANK_COUNT; k = k + 1) begin : UNPACK_IDS
        assign bank_op_id[k] = bank_op_id_flat[(k+1)*GPR_WIDTH-1 : k*GPR_WIDTH];
    end
endgenerate


// search logic
always @(*) begin
    match_found = 1'b0;
    temp_index  = {BANK_INDEX_WIDTH{1'b0}};
    for (i = 0; i < TOTAL_BANK_COUNT; i = i + 1) begin
        if (!match_found && bank_valid[i] && (bank_op_id[i] == read_operation_id)) begin
            match_found = 1'b1;
            temp_index  = i; 
        end
    end
end

// FSM

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state               <=  IDLE;
        busy_q              <=  1'b0;
        no_match_q          <=  1'b0;
        read_valid_q        <=  1'b0;
        req_rejected_q      <=  1'b0;
        req_accepted_q      <=  1'b0;
        bank_clear_out_q    <=  {TOTAL_BANK_COUNT{1'b0}};
        psum_read_address_q <=  {ADDR_WIDTH{1'b0}};
        psum_bank_index_q   <=  {BANK_INDEX_WIDTH{1'b0}};
        length_counter      <=  {ADDR_WIDTH{1'b0}};
    end
    else begin
        no_match_q          <=  1'b0;
        req_rejected_q      <=  1'b0;
        bank_clear_out_q    <=  {TOTAL_BANK_COUNT{1'b0}};

        case(state)
            IDLE: begin
                busy_q              <=  1'b0;
                no_match_q          <=  1'b0;
                read_valid_q        <=  1'b0;
                req_rejected_q      <=  1'b0;
                req_accepted_q      <=  1'b0;
                bank_clear_out_q    <=  {TOTAL_BANK_COUNT{1'b0}};
                psum_read_address_q <=  {ADDR_WIDTH{1'b0}};
                psum_bank_index_q   <=  {BANK_INDEX_WIDTH{1'b0}};
                length_counter      <=  {ADDR_WIDTH{1'b0}};

                if (start_read) begin
                    state           <=  SETUP;
                end else begin
                    state           <=  IDLE;
                end
            end
            
            SETUP: begin
                busy_q                  <=  1'b1;
                read_valid_q            <=  1'b0;
                if (match_found) begin
                    psum_bank_index_q   <=  temp_index;
                    length_counter      <=  read_seq_length;
                    psum_read_address_q <=  0;
                    state               <=  READ;
                    req_accepted_q      <=  1'b1;
                    no_match_q          <=  1'b0;
                end
                else begin
                    no_match_q          <=  1'b1;
                    state               <=  IDLE;
                end
            end

            READ: begin
                busy_q                  <=  1'b1;
                req_accepted_q          <=  1'b0;
                req_rejected_q          <=  start_read ? 1'b1 : 1'b0;
                read_valid_q            <=  (!stall && !(psum_read_address_q == length_counter - 1)) ? 1'b1 : 1'b0;

                if (!stall) begin
                    if (psum_read_address_q == length_counter - 1) begin
                        bank_clear_out_q    <= (1'b1 << psum_bank_index_q);  // one-hot clear pulse for this bank
                        state               <= IDLE;
                    end else begin
                        psum_read_address_q <= psum_read_address_q + 1'b1;  
                        state               <= READ;
                    end
                end
            end

        endcase
    end



end


endmodule
