`timescale 1ns/1ps
`include "../RTL/constants.vh"

interface dut_if (input logic clk);

  // Inputs
  logic rst;
  logic start;
  logic [`DATA_WIDTH-1:0] data_in;

  // Outputs
  logic [`DATA_WIDTH-1:0] data_out;
  logic done;
  logic busy;

  // Stage tap
  logic [`DATA_WIDTH-1:0] sb_out;
  logic sb_valid;

  // FSM visibility
  logic [`STATE_WIDTH-1:0] fsm_state;

// Drive on negedge, sample after posedge
clocking cb_drv @(negedge clk);
  default input #1ps output #50ps;   // דרייב 50ps אחרי negedge
  output rst, start, data_in;
  input  data_out, done, busy, sb_out, sb_valid, fsm_state;
endclocking

clocking cb_mon @(posedge clk);
  default input #800ps;              // דגימה 0.8ns אחרי posedge (לשעון 10ns זה סופר בטוח)
  input rst, start, data_in;
  input data_out, done, busy, sb_out, sb_valid, fsm_state;
endclocking


  modport DRIVER  (clocking cb_drv);
  modport MONITOR (clocking cb_mon);

endinterface
