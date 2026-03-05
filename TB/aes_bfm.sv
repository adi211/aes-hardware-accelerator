`timescale 1ns/1ps
`include "../RTL/constants.vh"

package aes_bfm_pkg;
  import tb_types_pkg::*;

  class aes_bfm;
    virtual dut_if.DRIVER  vif_drv;
    virtual dut_if.MONITOR vif_mon;

    bit prev_rst;

    function new(virtual dut_if.DRIVER vif_drv,
                 virtual dut_if.MONITOR vif_mon);
      this.vif_drv = vif_drv;
      this.vif_mon = vif_mon;
      prev_rst     = 1'b0;
    endfunction

    // Wait until DUT is truly ready to accept a new transaction
	task wait_ready();
	  do @(vif_mon.cb_mon);
	  while (vif_mon.cb_mon.rst  ||
			 vif_mon.cb_mon.busy ||
			 vif_mon.cb_mon.done ||
			 (vif_mon.cb_mon.fsm_state != `STATE_IDLE));
	endtask


    task reset_dut(int unsigned cycles = 3);
      vif_drv.cb_drv.rst     <= 1'b1;
      vif_drv.cb_drv.start   <= 1'b0;
      vif_drv.cb_drv.data_in <= '0;

      repeat (cycles) @(vif_drv.cb_drv);

      vif_drv.cb_drv.rst <= 1'b0;
      @(vif_drv.cb_drv);

      wait_ready();
    endtask

    task reset_pulse(int unsigned cycles = 2);
      vif_drv.cb_drv.start <= 1'b0;
      vif_drv.cb_drv.rst   <= 1'b1;

      repeat (cycles) @(vif_drv.cb_drv);

      vif_drv.cb_drv.rst <= 1'b0;
      @(vif_drv.cb_drv);

      wait_ready();
    endtask

    task wait_busy_high();
      do @(vif_drv.cb_drv);
      while (!vif_drv.cb_drv.busy);
    endtask

    task send_tx(input logic [127:0] vec, input int unsigned idle_gap_cycles = 0);
      wait_ready();
      repeat (idle_gap_cycles) @(vif_drv.cb_drv);

      @(vif_drv.cb_drv);
      vif_drv.cb_drv.data_in <= vec;
      vif_drv.cb_drv.start   <= 1'b1;

      @(vif_drv.cb_drv);
      vif_drv.cb_drv.start   <= 1'b0;
    endtask

	task run_monitor(evt_mbox_t evt_mb);
	  mon_evt_t e;

	  // Prime prev_rst to avoid reporting the initial reset as an event
	  @(vif_mon.cb_mon);
	  prev_rst = vif_mon.cb_mon.rst;

	  forever begin
		@(vif_mon.cb_mon);
		e = '{default:'0};

		if (vif_mon.cb_mon.rst && !prev_rst) begin
		  e.has_rst = 1'b1;
		end
		prev_rst = vif_mon.cb_mon.rst;

		if (vif_mon.cb_mon.sb_valid) begin
		  e.has_sb = 1'b1;
		  e.sb     = vif_mon.cb_mon.sb_out;
		end

		if (vif_mon.cb_mon.done) begin
		  e.has_done = 1'b1;
		  e.dout     = vif_mon.cb_mon.data_out;
		end

		if (e.has_rst || e.has_sb || e.has_done)
		  evt_mb.put(e);
	  end
	endtask


  endclass

endpackage


