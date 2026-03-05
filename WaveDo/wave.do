onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TB -radix hexadecimal /tb_top/clk
add wave -noupdate -group TB -radix hexadecimal /tb_top/#ublk#128478048#44/n_txns
add wave -noupdate -group TB -radix hexadecimal /tb_top/#ublk#128478048#44/seed
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/clk
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/rst
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/start
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/data_in
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/data_out
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/done
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/busy
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/sb_out
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/sb_valid
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/fsm_state
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/data_out
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/done
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/busy
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/sb_out
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/sb_valid
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/fsm_state
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/rst
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/start
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/data_in
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_drv/cb_drv_event
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/data_out
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/done
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/busy
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/sb_out
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/sb_valid
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/fsm_state
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/rst
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/start
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/data_in
add wave -noupdate -group TB -radix hexadecimal /tb_top/intf/cb_mon/cb_mon_event
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::put/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::try_put/try_put
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::try_put/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::get/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::try_get/try_get
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::try_get/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::peek/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::try_peek/try_peek
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__1::try_peek/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::put/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::try_put/try_put
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::try_put/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::get/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::try_get/try_get
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::try_get/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::peek/message
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::try_peek/try_peek
add wave -noupdate -group TB -radix hexadecimal /std::mailbox::mailbox__2::try_peek/message
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/clk
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/rst
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/start
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/data_in
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/data_out
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/done
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/busy
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/sb_out
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/sb_valid
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/fsm_state
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/in_reg_en
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/en_sb
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/en_mc
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/data_in_reg
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/mc_out_int
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/u_input_reg/clk
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/u_input_reg/rst
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/u_input_reg/en
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/u_input_reg/data_in
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_top/dut/u_input_reg/data_out
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/clk
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/rst
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/start
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/state_out
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/in_reg_en
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/en_sb
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/en_mc
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/sb_valid
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/done
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/busy
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/next_state_w
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/state_q
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/accept_w
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/sb_valid_q
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/done_q
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_state_reg/clk
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_state_reg/rst
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_state_reg/en
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_state_reg/data_in
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_state_reg/data_out
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_sb_valid_dly/clk
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_sb_valid_dly/rst
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_sb_valid_dly/en
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_sb_valid_dly/data_in
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_sb_valid_dly/data_out
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_done_dly/clk
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_done_dly/rst
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_done_dly/en
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_done_dly/data_in
add wave -noupdate -group CONTROL -radix hexadecimal /tb_top/dut/u_control_fsm/u_done_dly/data_out
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/clk
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/rst
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/en
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/in
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/out
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/sbox_res_w
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/out_reg
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[120]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[120]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[112]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[112]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[104]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[104]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[96]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[96]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[88]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[88]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[80]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[80]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[72]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[72]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[64]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[64]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[56]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[56]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[48]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[48]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[40]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[40]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[32]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[32]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[24]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[24]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[16]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[16]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[8]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[8]/s/c}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[0]/s/a}
add wave -noupdate -group SB -radix hexadecimal {/tb_top/dut/u_sub_bytes/sub_Bytes[0]/s/c}
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/u_output_reg/clk
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/u_output_reg/rst
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/u_output_reg/en
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/u_output_reg/data_in
add wave -noupdate -group SB -radix hexadecimal /tb_top/dut/u_sub_bytes/u_output_reg/data_out
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/clk
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/rst
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/en
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/data_in
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/data_out
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/mixcols_comb_w
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/data_out_reg
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/u_output_reg/clk
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/u_output_reg/rst
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/u_output_reg/en
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/u_output_reg/data_in
add wave -noupdate -group MC -radix hexadecimal /tb_top/dut/u_mix_columns/u_output_reg/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20118284 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 251
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {18414503 ps} {20806912 ps}
