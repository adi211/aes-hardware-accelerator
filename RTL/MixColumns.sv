`include "constants.vh"

module MixColumns #(
    parameter DATA_WIDTH = 128 
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  en, 
    input  logic [DATA_WIDTH-1:0] data_in,  
    output logic [DATA_WIDTH-1:0] data_out  
);

    // --- Internal Signals ---
    logic [DATA_WIDTH-1:0] mixcols_comb_w; // Combinational calculation result
    logic [DATA_WIDTH-1:0] data_out_reg;   // Internal register signal

    // =========================================================================
    // Internal Functions (GF Multiplication)
    // =========================================================================
    function automatic logic [7:0] gmul2(input logic [7:0] b);
        begin
            gmul2 = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
        end
    endfunction

    function automatic logic [7:0] gmul3(input logic [7:0] b);
        begin
            gmul3 = gmul2(b) ^ b;
        end
    endfunction

    function automatic logic [31:0] mix_single_column(input logic [31:0] col);
        logic [7:0] s0, s1, s2, s3; 
        logic [7:0] r0, r1, r2, r3; 
        begin
            s0 = col[31:24]; s1 = col[23:16]; s2 = col[15:8]; s3 = col[7:0];
            
            r0 = gmul2(s0) ^ gmul3(s1) ^       s2  ^       s3;
            r1 =       s0  ^ gmul2(s1) ^ gmul3(s2) ^       s3;
            r2 =       s0  ^       s1  ^ gmul2(s2) ^ gmul3(s3);
            r3 = gmul3(s0) ^       s1  ^       s2  ^ gmul2(s3);
            
            mix_single_column = {r0, r1, r2, r3};
        end
    endfunction

    // =========================================================================
    // Main Logic: Generate Loop
    // =========================================================================
    genvar i;
    generate
        for (i = 0; i < (DATA_WIDTH / 32); i++) begin : column_processing
            assign mixcols_comb_w[(i*32) +: 32] = mix_single_column(data_in[(i*32) +: 32]);
        end
    endgenerate

    // =========================================================================
    // Output Register Instance
    // =========================================================================
    Register #(.WIDTH(DATA_WIDTH)) u_output_reg (
        .clk      (clk),
        .rst      (rst),
        .en       (en),
        .data_in  (mixcols_comb_w), // Input from logic
        .data_out (data_out_reg)    // Output to internal _reg signal
    );

    // =========================================================================
    // Output Assignment
    // =========================================================================
    assign data_out = data_out_reg;

endmodule