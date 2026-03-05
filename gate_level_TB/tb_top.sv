`timescale 1ns/1ps
`include "../RTL/constants.vh"
import tb_types_pkg::*;
import aes_ref_pkg::*;
import aes_bfm_pkg::*;
import scoreboard_pkg::*;
import stimuli_pkg::*;

module tb_top;

  logic clk = 1'b0;
  always #5 clk = ~clk;

  dut_if intf(clk);

  Top dut (
    .clk      (clk),
    .rst      (intf.rst),

    .start    (intf.start),
    .data_in  (intf.data_in),

    .data_out (intf.data_out),
    .done     (intf.done),
    .busy     (intf.busy),

    .sb_out   (intf.sb_out),
    .sb_valid (intf.sb_valid),

    .fsm_state(intf.fsm_state)
  );


  exp_mbox_t exp_mb = new();
  evt_mbox_t evt_mb = new();

  aes_bfm     bfm;
  scoreboard  sb;
  stimuli     stim;

  initial begin
    int unsigned n_txns = 300;
    int unsigned seed   = 32'hc0ffee12;

    bfm = new(intf.DRIVER, intf.MONITOR);
    sb  = new(exp_mb, evt_mb);

    void'($value$plusargs("N_TXNS=%d", n_txns));
    void'($value$plusargs("SEED=%d", seed));

    stim = new(bfm, exp_mb, n_txns, seed);

    // Reset first (do not let monitor/scoreboard see the initial reset)
    bfm.reset_dut(3);

    fork
      bfm.run_monitor(evt_mb);
      sb.run();
    join_none

    stim.run();

    #300;
    $display("TB COMPLETE | txns=%0d pass=%0d fail=%0d", sb.txn_cnt, sb.pass_cnt, sb.fail_cnt);
    $stop;
  end


endmodule
