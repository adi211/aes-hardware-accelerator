// TB/tb_cov.sv
`timescale 1ns/1ps
`include "../RTL/constants.vh"

module tb_cov(dut_if intf);

  // Track previous-cycle values for corner coverage
  logic rst_q;
  logic busy_q;

  always_ff @(posedge intf.clk) begin
    rst_q  <= intf.rst;
    busy_q <= intf.busy;
  end

  // Reset asserted while DUT was busy in the previous cycle
  wire reset_while_busy = (intf.rst && !rst_q && busy_q);

  // Transaction acceptance condition
  wire start_accept = (!intf.rst) &&
                      (intf.fsm_state == `STATE_IDLE) &&
                      (intf.start == 1'b1);

  covergroup cg_main @(posedge intf.clk);
    option.per_instance = 1;

    // FSM state coverage + main legal flow
    cp_state : coverpoint intf.fsm_state {
      bins reset = {`STATE_RESET};
      bins idle  = {`STATE_IDLE};
      bins sb    = {`STATE_SB};
      bins mc    = {`STATE_MC};
      bins flow_idle_sb_mc_idle = (`STATE_IDLE => `STATE_SB => `STATE_MC => `STATE_IDLE);
    }

    // Handshake/event coverage
    cp_start_in_idle : coverpoint start_accept {
      bins seen = {1'b1};
    }

    cp_sbvalid_in_mc : coverpoint (intf.sb_valid && (intf.fsm_state == `STATE_MC))
      iff (!intf.rst) {
        bins seen = {1'b1};
      }

    cp_done_in_idle : coverpoint (intf.done && (intf.fsm_state == `STATE_IDLE))
      iff (!intf.rst) {
        bins seen = {1'b1};
      }

    // Reset mid-run coverage
    cp_reset_while_busy : coverpoint reset_while_busy {
      bins seen = {1'b1};
    }

    // Input distribution buckets (sample only on accepted transactions)
    cp_input_bucket : coverpoint intf.data_in[3:0] iff (start_accept) {
      bins bucket[16] = {[0:15]};
    }

  endgroup

  cg_main cg = new();

endmodule
