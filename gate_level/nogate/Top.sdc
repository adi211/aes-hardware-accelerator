###################################################################

# Created by write_sdc on Mon Jan  5 20:59:26 2026

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
create_clock [get_ports clk]  -period 2.4  -waveform {0 1.2}
set_clock_uncertainty 0.1  [get_clocks clk]
