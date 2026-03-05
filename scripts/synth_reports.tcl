# synth_reports.tcl  (time10)
# Run:
#   design_vision -f /users_home/adishl/time10/synth_reports.tcl |& tee /users_home/adishl/time10/synth_run.log
# or:
#   dc_shell -f /users_home/adishl/time10/synth_reports.tcl |& tee /users_home/adishl/time10/synth_run.log

# -----------------------------
# USER SETTINGS
# -----------------------------
set TOP        "Top"
set CLK_PORT   "clk"
set RST_PORT   "rst"
set CLK_PERIOD 2.4

# RTL + include
set RTL_FILES [list \
  "/users_home/adishl/RTL/constants.vh" \
  "/users_home/adishl/RTL/ControlFsm.sv" \
  "/users_home/adishl/RTL/MixColumns.sv" \
  "/users_home/adishl/RTL/Register.sv" \
  "/users_home/adishl/RTL/sbox.v" \
  "/users_home/adishl/RTL/subBytes.v" \
  "/users_home/adishl/RTL/Top.sv" \
]

set LIB_DB "/users_home/adishl/LibraryFiles/db/slow.db"
set DW_LIB  "/opt/synopsys/syn/W-2024.09/libraries/syn/dw_foundation.sldb"

# Root for this run
set BASE_DIR "/users_home/adishl/time10"
set RPT_ROOT "${BASE_DIR}/reports"
set OUT_ROOT "${BASE_DIR}/outputs"
set WORK_DIR "${BASE_DIR}/WORK"

# -----------------------------
# COMMON SETUP
# -----------------------------
file mkdir $BASE_DIR
file mkdir $RPT_ROOT
file mkdir $OUT_ROOT
file mkdir $WORK_DIR

set_app_var search_path    [list . "/users_home/adishl/RTL" "/users_home/adishl"]
set_app_var target_library $LIB_DB
set_app_var link_library   "* $LIB_DB $DW_LIB"

proc clean_work {} {
  global WORK_DIR
  catch { remove_design -all }
  catch { file delete -force $WORK_DIR }
  file mkdir $WORK_DIR
  catch { define_design_lib WORK -path $WORK_DIR }
}

proc write_reports {rpt_dir do_gating} {
  redirect -file "${rpt_dir}/report_qor.txt"   { report_qor }
  redirect -file "${rpt_dir}/report_area.txt"  { report_area -hierarchy }
  redirect -file "${rpt_dir}/report_power.txt" { report_power -analysis_effort low }

  redirect -file "${rpt_dir}/report_timing.txt" {
    puts "============================="
    puts "TIMING REPORT - MAX (SETUP)"
    puts "============================="
    report_timing -delay_type max -path full -max_paths 10 -nworst 1
  }
  redirect -append -file "${rpt_dir}/report_timing.txt" {
    puts "\n\n============================="
    puts "TIMING REPORT - MIN (HOLD)"
    puts "============================="
    report_timing -delay_type min -path full -max_paths 10 -nworst 1
  }

  redirect -file "${rpt_dir}/check_design.txt" { check_design }
  redirect -file "${rpt_dir}/references.txt"   { report_reference -hierarchy }

  if {$do_gating} {
    redirect -file "${rpt_dir}/report_clock_gating.txt" { report_clock_gating }
  }
}

proc write_outputs {out_dir top} {
  write -format ddc     -hierarchy -output "${out_dir}/${top}.ddc"
  write -format verilog -hierarchy -output "${out_dir}/${top}_netlist.v"
  write_sdf -version 2.1 -context verilog "${out_dir}/${top}.sdf"
  write_sdc "${out_dir}/${top}.sdc"
}

proc run_one {tag do_gating} {
  global TOP CLK_PORT RST_PORT CLK_PERIOD RTL_FILES RPT_ROOT OUT_ROOT

  puts "\n=================================================="
  puts " RUN: $tag (clock_gating=$do_gating)  PERIOD=${CLK_PERIOD}ns"
  puts "==================================================\n"

  clean_work

  set rpt_dir "${RPT_ROOT}/${tag}"
  set out_dir "${OUT_ROOT}/${tag}"
  file mkdir $rpt_dir
  file mkdir $out_dir

  # Read + Elaborate
  analyze   -format sverilog -library WORK $RTL_FILES
  elaborate $TOP -library WORK
  current_design $TOP
  link

  # -----------------------------
  # Constraints (SAFE)
  # -----------------------------
  create_clock -name $CLK_PORT -period $CLK_PERIOD [get_ports $CLK_PORT]

  # תן מרווח גדול כדי להבטיח Slack חיובי בפועל
  set CLK_OBJ [get_clocks $CLK_PORT]
catch { set_clock_uncertainty 0.50 $CLK_OBJ }


  # IO delays כדי שהדיזיין לא "יחשוב" שהכל אידיאלי
  set in_ports [all_inputs]
  set in_ports [remove_from_collection $in_ports [get_ports $CLK_PORT]]
  catch { set in_ports [remove_from_collection $in_ports [get_ports $RST_PORT]] }

  catch { set_input_delay  1.00 -clock $CLK_PORT $in_ports }
  catch { set_output_delay 1.00 -clock $CLK_PORT [all_outputs] }

  # לרוב לא מודדים reset
  catch { set_false_path -from [get_ports $RST_PORT] }

  catch { set_fix_multiple_port_nets -all -buffer_constants }

  # -----------------------------
  # Compile
  # -----------------------------
  if {$do_gating} {
    catch { set_clock_gating_style -sequential_cell latch -control_point before -minimum_bitwidth 1 }
    compile_ultra -gate_clock -retime
  } else {
    compile_ultra -retime
  }

  # Reports + outputs
  write_reports $rpt_dir $do_gating
  write_outputs $out_dir $TOP

  puts "\n==== DONE: $tag ====\n"
}

# -----------------------------
# TWO RUNS
# -----------------------------
run_one "nogate" 0
run_one "gate"   1

puts "\nALL DONE."
puts "Reports  : ${RPT_ROOT}/nogate  ,  ${RPT_ROOT}/gate"
puts "Outputs  : ${OUT_ROOT}/nogate  ,  ${OUT_ROOT}/gate"
