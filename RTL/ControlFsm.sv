`include "constants.vh"

module ControlFsm (
    input  logic                    clk,
    input  logic                    rst,

    input  logic                    start,

    output logic [`STATE_WIDTH-1:0] state_out,

    output logic                    in_reg_en,
    output logic                    en_sb,
    output logic                    en_mc,

    output logic                    sb_valid,
    output logic                    done,
    output logic                    busy
);

    logic [`STATE_WIDTH-1:0] next_state_w;
    logic [`STATE_WIDTH-1:0] state_q;

    logic accept_w;

    logic sb_valid_q;
    logic done_q;

    // Accept start only in IDLE
    assign accept_w = (state_q == `STATE_IDLE) && start;

    // Next-state logic
    always_comb begin
        next_state_w = state_q;

        unique case (state_q)
            `STATE_RESET: next_state_w = `STATE_IDLE;

            `STATE_IDLE:  if (start) next_state_w = `STATE_SB;

            `STATE_SB:    next_state_w = `STATE_MC;

            `STATE_MC:    next_state_w = `STATE_IDLE;

            default:      next_state_w = `STATE_RESET;
        endcase
    end

    // State register
    Register #(
        .WIDTH(`STATE_WIDTH),
        .RESET_VAL(`STATE_RESET)
    ) u_state_reg (
        .clk      (clk),
        .rst      (rst),
        .en       (1'b1),
        .data_in  (next_state_w),
        .data_out (state_q)
    );

    // Control outputs
    assign state_out = state_q;

    assign in_reg_en = accept_w;

    assign en_sb     = (state_q == `STATE_SB);
    assign en_mc     = (state_q == `STATE_MC);

    // Valid/Done pulses are 1-cycle delayed versions of enables:
    // - sb_valid pulses during MC cycle (SB result is already registered)
    // - done pulses during IDLE cycle after MC (MC result is already registered)
    Register #(.WIDTH(1), .RESET_VAL(1'b0)) u_sb_valid_dly (
        .clk(clk), .rst(rst), .en(1'b1), .data_in(en_sb), .data_out(sb_valid_q)
    );

    Register #(.WIDTH(1), .RESET_VAL(1'b0)) u_done_dly (
        .clk(clk), .rst(rst), .en(1'b1), .data_in(en_mc), .data_out(done_q)
    );

    assign sb_valid = sb_valid_q;
    assign done     = done_q;

    // Busy only while SB/MC states
    assign busy = (state_q == `STATE_SB) || (state_q == `STATE_MC);

endmodule
