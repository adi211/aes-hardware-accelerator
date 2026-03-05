package tb_types_pkg;

  typedef struct packed {
    logic [127:0] in_vec;
    logic [127:0] exp_sb;
    logic [127:0] exp_out;   // Final output (MixColumns(SubBytes(in)))
  } exp_txn_t;

  typedef struct packed {
    bit           has_rst;
    bit           has_sb;
    bit           has_done;
    logic [127:0] sb;
    logic [127:0] dout;
  } mon_evt_t;

  typedef mailbox #(exp_txn_t) exp_mbox_t;
  typedef mailbox #(mon_evt_t) evt_mbox_t;

endpackage
