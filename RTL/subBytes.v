module subBytes(clk, rst, en, in, out);

    input wire clk;
    input wire rst;
    input wire en;
    input wire [127:0] in;
    output wire [127:0] out;

    // --- Internal Signals ---
    wire [127:0] sbox_res_w; // Combinational result from S-Box
    wire [127:0] out_reg;    // Internal register signal

    genvar i;
    generate 
        for(i=0; i<128; i=i+8) begin : sub_Bytes 
            // S-Box logic drives the combinational wire
            sbox s(in[i +:8], sbox_res_w[i +:8]);
        end
    endgenerate

    // =========================================================================
    // Output Register Instance
    // =========================================================================
    Register #(.WIDTH(128)) u_output_reg (
        .clk      (clk),
        .rst      (rst),
        .en       (en),
        .data_in  (sbox_res_w), // Input from logic
        .data_out (out_reg)     // Output to internal _reg signal
    );

    // =========================================================================
    // Output Assignment
    // =========================================================================
    assign out = out_reg;

endmodule