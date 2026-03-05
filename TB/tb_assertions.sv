`timescale 1ns/1ps
`include "../RTL/constants.vh"

module tb_assertions(dut_if intf);

  // Reset behavior: keep it simple and non-controversial
  // Assumes fsm_state resets to STATE_RESET and status flags reset low.
  assert property (@(posedge intf.clk)
    intf.rst |-> (intf.fsm_state == `STATE_RESET && !intf.busy && !intf.done && !intf.sb_valid)
  );

  // After reset deassertion, FSM should reach IDLE on the next cycle
  assert property (@(posedge intf.clk)
    $fell(intf.rst) |=> (intf.fsm_state == `STATE_IDLE && !intf.busy)
  );

  // Busy definition for the 4-state FSM
  assert property (@(posedge intf.clk)
    disable iff (intf.rst)
    intf.busy <-> ((intf.fsm_state == `STATE_SB) || (intf.fsm_state == `STATE_MC))
  );

  // sb_valid is expected only during MC cycle (one-cycle pulse)
  assert property (@(posedge intf.clk)
    disable iff (intf.rst)
    intf.sb_valid |-> (intf.fsm_state == `STATE_MC && intf.busy)
  );

  // done is expected only during IDLE (one-cycle pulse after MC)
  assert property (@(posedge intf.clk)
    disable iff (intf.rst)
    intf.done |-> (intf.fsm_state == `STATE_IDLE && !intf.busy)
  );

  // Pulse widths: one cycle
  assert property (@(posedge intf.clk)
    disable iff (intf.rst)
    intf.sb_valid |=> !intf.sb_valid
  );

  assert property (@(posedge intf.clk)
    disable iff (intf.rst)
    intf.done |=> !intf.done
  );

  // No unknowns when flags assert
  assert property (@(posedge intf.clk)
    disable iff (intf.rst)
    intf.sb_valid |-> !$isunknown(intf.sb_out)
  );

  assert property (@(posedge intf.clk)
    disable iff (intf.rst)
    intf.done |-> !$isunknown(intf.data_out)
  );



endmodule
