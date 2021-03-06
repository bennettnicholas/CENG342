# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param tcl.collectionResultDisplayLimit 0
set_param chipscope.maxJobs 4
set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/Dev/CENG342/Lab_12/Lab_12.cache/wt [current_project]
set_property parent.project_path D:/Dev/CENG342/Lab_12/Lab_12.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:nexys-a7-100t:part0:1.0 [current_project]
set_property ip_output_repo d:/Dev/CENG342/Lab_12/Lab_12.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library work {
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/new/BTU.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/generic_register.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/CCR.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/new/my_package.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/new/Instruction_decoder.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/new/sequencer.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/MCR.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/MDR.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/MAR.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/Generic_ALU.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/PC.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/decoder.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/register_file.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/imports/new/LPU.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/sim_1/new/CPU.vhd
  D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/Computer_package/Computer.vhdl
}
read_ip -quiet D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all d:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all d:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

read_edif D:/Dev/CENG342/Lab_12/Lab_12.srcs/sources_1/imports/Computer_package/Memory_NO_DDR.edf
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/Dev/CENG342/Lab_12/Lab_12.srcs/constrs_1/imports/Computer_package/DDR2.xdc
set_property used_in_implementation false [get_files D:/Dev/CENG342/Lab_12/Lab_12.srcs/constrs_1/imports/Computer_package/DDR2.xdc]

read_xdc D:/Dev/CENG342/Lab_12/Lab_12.srcs/constrs_1/imports/Computer_package/Nexys-A7-100T-Master.xdc
set_property used_in_implementation false [get_files D:/Dev/CENG342/Lab_12/Lab_12.srcs/constrs_1/imports/Computer_package/Nexys-A7-100T-Master.xdc]

read_xdc D:/Dev/CENG342/Lab_12/Lab_12.srcs/constrs_1/imports/Computer_package/bitstream_settings.xdc
set_property used_in_implementation false [get_files D:/Dev/CENG342/Lab_12/Lab_12.srcs/constrs_1/imports/Computer_package/bitstream_settings.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top Computer -part xc7a100tcsg324-1 -fanout_limit 400 -directive PerformanceOptimized -fsm_extraction one_hot -keep_equivalent_registers -resource_sharing off -no_lc -shreg_min_size 5


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Computer.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Computer_utilization_synth.rpt -pb Computer_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
