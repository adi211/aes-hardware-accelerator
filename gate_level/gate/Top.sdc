###################################################################

# Created by write_sdc on Mon Jan  5 21:02:05 2026

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
create_clock [get_ports clk]  -period 2.4  -waveform {0 1.2}
set_clock_uncertainty 0.1  [get_clocks clk]
set_clock_gating_check -rise -setup 0 [get_cells -hsc @                        \
clk_gate_u_mix_columns/u_output_reg/data_out_reg@main_gate]
set_clock_gating_check -fall -setup 0 [get_cells -hsc @                        \
clk_gate_u_mix_columns/u_output_reg/data_out_reg@main_gate]
set_clock_gating_check -rise -hold 0 [get_cells -hsc @                         \
clk_gate_u_mix_columns/u_output_reg/data_out_reg@main_gate]
set_clock_gating_check -fall -hold 0 [get_cells -hsc @                         \
clk_gate_u_mix_columns/u_output_reg/data_out_reg@main_gate]
set_clock_gating_check -rise -setup 0 [get_cells -hsc @                        \
clk_gate_u_sub_bytes/u_output_reg/data_out_reg@main_gate]
set_clock_gating_check -fall -setup 0 [get_cells -hsc @                        \
clk_gate_u_sub_bytes/u_output_reg/data_out_reg@main_gate]
set_clock_gating_check -rise -hold 0 [get_cells -hsc @                         \
clk_gate_u_sub_bytes/u_output_reg/data_out_reg@main_gate]
set_clock_gating_check -fall -hold 0 [get_cells -hsc @                         \
clk_gate_u_sub_bytes/u_output_reg/data_out_reg@main_gate]
set_clock_gating_check -rise -setup 0 [get_cells -hsc @                        \
clk_gate_u_input_reg/data_out_reg@main_gate]
set_clock_gating_check -fall -setup 0 [get_cells -hsc @                        \
clk_gate_u_input_reg/data_out_reg@main_gate]
set_clock_gating_check -rise -hold 0 [get_cells -hsc @                         \
clk_gate_u_input_reg/data_out_reg@main_gate]
set_clock_gating_check -fall -hold 0 [get_cells -hsc @                         \
clk_gate_u_input_reg/data_out_reg@main_gate]
set_clock_gating_check -rise -setup 0 [get_cells -hsc @                        \
clk_gate_u_control_fsm/u_state_reg/data_out_reg@main_gate]
set_clock_gating_check -fall -setup 0 [get_cells -hsc @                        \
clk_gate_u_control_fsm/u_state_reg/data_out_reg@main_gate]
set_clock_gating_check -rise -hold 0 [get_cells -hsc @                         \
clk_gate_u_control_fsm/u_state_reg/data_out_reg@main_gate]
set_clock_gating_check -fall -hold 0 [get_cells -hsc @                         \
clk_gate_u_control_fsm/u_state_reg/data_out_reg@main_gate]
