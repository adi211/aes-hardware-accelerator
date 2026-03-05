`timescale 1ns/1ps

package scoreboard_pkg;
  import tb_types_pkg::*;

  class scoreboard;
    exp_mbox_t exp_mb;
    evt_mbox_t evt_mb;

    exp_txn_t cur;
    bit have_cur;
    bit seen_sb;

    int pass_cnt;
    int fail_cnt;
    int txn_cnt;

    function new(exp_mbox_t exp_mb, evt_mbox_t evt_mb);
      this.exp_mb = exp_mb;
      this.evt_mb = evt_mb;
      have_cur = 0;
      seen_sb  = 0;
      pass_cnt = 0;
      fail_cnt = 0;
      txn_cnt  = 0;
    endfunction

    task run();
      mon_evt_t e;

      forever begin
        if (!have_cur) begin
          exp_mb.get(cur);
          have_cur = 1;
          seen_sb  = 0;
        end

        evt_mb.get(e);

        if (e.has_rst) begin
          have_cur = 0;
          seen_sb  = 0;
          continue;
        end

        if (e.has_sb) begin
          seen_sb = 1;
          if (e.sb !== cur.exp_sb) begin
            fail_cnt++;
            $error("SB MISMATCH exp=%h got=%h", cur.exp_sb, e.sb);
          end else begin
            pass_cnt++;
          end
        end

        if (e.has_done) begin
          if (!seen_sb) begin
            fail_cnt++;
            $error("DONE before SB_VALID");
          end

          if (e.dout !== cur.exp_out) begin
            fail_cnt++;
            $error("DOUT MISMATCH exp=%h got=%h", cur.exp_out, e.dout);
          end else begin
            pass_cnt++;
          end

          txn_cnt++;
          have_cur = 0;
        end
      end
    endtask

  endclass

endpackage
