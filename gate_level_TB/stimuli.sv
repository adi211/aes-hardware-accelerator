// TB/stimuli.sv
`timescale 1ns/1ps

package stimuli_pkg;
  import tb_types_pkg::*;
  import aes_ref_pkg::*;
  import aes_bfm_pkg::*;

  class stimuli;
    aes_bfm     bfm;
    exp_mbox_t  exp_mb;

    int unsigned n_txns;
    int unsigned seed;

    function new(aes_bfm bfm,
                 exp_mbox_t exp_mb,
                 int unsigned n_txns = 300,
                 int unsigned seed   = 32'hc0ffee12);
      this.bfm    = bfm;
      this.exp_mb = exp_mb;
      this.n_txns = n_txns;
      this.seed   = seed;
    endfunction

    task run();
      exp_txn_t     t;
      aes_ref_res_t r;

      void'($urandom(seed));

      // Directed #1: known vector
      t.in_vec = 128'h6bc1bee22e409f96e93d7e117393172a;
      r = aes_ref_compute(t.in_vec);
      t.exp_sb  = r.sb;
      t.exp_out = r.out;
      exp_mb.put(t);
      bfm.send_tx(t.in_vec, 0);

      // Directed #2: all-zeros
      t.in_vec = 128'h0;
      r = aes_ref_compute(t.in_vec);
      t.exp_sb  = r.sb;
      t.exp_out = r.out;
      exp_mb.put(t);
      bfm.send_tx(t.in_vec, 1);

      // Directed #3: all-ones
      t.in_vec = {128{1'b1}};
      r = aes_ref_compute(t.in_vec);
      t.exp_sb  = r.sb;
      t.exp_out = r.out;
      exp_mb.put(t);
      bfm.send_tx(t.in_vec, 0);

      // Mid-run reset test (scoreboard flushes current txn on reset event)
      t.in_vec = 128'h0123_4567_89ab_cdef_0011_2233_4455_6677;
      r = aes_ref_compute(t.in_vec);
      t.exp_sb  = r.sb;
      t.exp_out = r.out;
      exp_mb.put(t);
      bfm.send_tx(t.in_vec, 0);

      bfm.wait_busy_high();
      bfm.reset_pulse(2);
	  
	  // Code coverage sweep: exercise sbox case items (0x00..0xFF)
      // Drives all 16 bytes to the same value, so each sweep hits 16 sboxes.
      for (int unsigned i = 0; i < 256; i++) begin
        logic [7:0] b;
        b = i[7:0];

        t.in_vec = {16{b}};  // 128-bit: {b,b,...} x16
        r = aes_ref_compute(t.in_vec);
        t.exp_sb  = r.sb;
        t.exp_out = r.out;
        exp_mb.put(t);

        bfm.send_tx(t.in_vec, 0);
      end


      // Random transactions
      for (int unsigned k = 0; k < n_txns; k++) begin
        t.in_vec = {$urandom(), $urandom(), $urandom(), $urandom()};
        r = aes_ref_compute(t.in_vec);
        t.exp_sb  = r.sb;
        t.exp_out = r.out;
        exp_mb.put(t);

        bfm.send_tx(t.in_vec, $urandom_range(0, 3));
      end
    endtask

  endclass

endpackage
