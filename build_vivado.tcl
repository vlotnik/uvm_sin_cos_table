set project_name "sin_cos_uvm"

set project_found [llength [get_projects $project_name] ]
if {$project_found > 0} close_project

# set the reference directory to where the script is
set origin_dir [file dirname [info script]]
cd [file dirname [info script]]

# create project
create_project $project_name "$project_name" -force

# add sources
add_files -norecurse sin_cos_table.vhd
add_files -norecurse sincos_package.sv
add_files -norecurse tb_top.sv
add_files -norecurse sincos_test_default.svh
add_files -norecurse sincos_seqi.svh
add_files -norecurse sincos_seqc_default.svh
add_files -norecurse sincos_scrb.svh
add_files -norecurse sincos_if.sv
add_files -norecurse sincos_mont.svh
add_files -norecurse sincos_drvr.svh
add_files -norecurse sincos_agnt.svh

# uvm
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]

# lunch simulation
set_property top tb_top [get_filesets sim_1]
launch_simulation