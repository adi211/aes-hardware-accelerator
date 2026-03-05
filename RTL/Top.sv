`include "constants.vh"

module Top #(
    parameter int DATA_WIDTH = `DATA_WIDTH
)(
    input  logic                  clk,
    input  logic                  rst,

    // Handshake / Inputs
    input  logic                  start,
    input  logic [DATA_WIDTH-1:0] data_in,

    // Transaction Output
    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  done,
    output logic                  busy,

    // Optional stage tap (keep if you still want SB visibility)
    output logic [DATA_WIDTH-1:0] sb_out,
    output logic                  sb_valid,

    output logic [`STATE_WIDTH-1:0] fsm_state
);

    logic in_reg_en;
    logic en_sb;
    logic en_mc;

    logic [DATA_WIDTH-1:0] data_in_reg;
    logic [DATA_WIDTH-1:0] mc_out_int;

    // Control FSM
    ControlFsm u_control_fsm (
        .clk       (clk),
        .rst       (rst),

        .start     (start),

        .state_out (fsm_state),

        .in_reg_en (in_reg_en),
        .en_sb     (en_sb),
        .en_mc     (en_mc),

        .sb_valid  (sb_valid),
        .done      (done),
        .busy      (busy)
    );

    // Input register
    Register #(
        .WIDTH(DATA_WIDTH),
        .RESET_VAL({DATA_WIDTH{1'b0}})
    ) u_input_reg (
        .clk      (clk),
        .rst      (rst),
        .en       (in_reg_en),
        .data_in  (data_in),
        .data_out (data_in_reg)
    );

    // Stage 1: SubBytes (registered output)
    subBytes u_sub_bytes (
        .clk (clk),
        .rst (rst),
        .en  (en_sb),
        .in  (data_in_reg),
        .out (sb_out)
    );

    // Stage 2: MixColumns (registered output)
    MixColumns #(.DATA_WIDTH(DATA_WIDTH)) u_mix_columns (
        .clk      (clk),
        .rst      (rst),
        .en       (en_mc),
        .data_in  (sb_out),
        .data_out (mc_out_int)
    );

	// Drive zero during computation cycles; expose stable result while idle
	assign data_out = busy ? '0 : mc_out_int;


endmodule
