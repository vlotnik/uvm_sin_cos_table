create_libs:
	vlib work
	vlib work/test

map_libs:
	vmap test work/test

comp_vhd:
	vcom -64 -93 -work test sin_cos_table.vhd

comp_sv:
	vlog -64 \
	-work def_lib \
	-L test \
	-work def_lib -work def_lib sincos_if.sv \
	-work def_lib -work def_lib sincos_package.sv \
	-work def_lib tb_top.sv

run_sim:
	vsim -64 -voptargs="+acc" \
	-L test \
	-L def_lib -lib def_lib def_lib.tb_top \
	-do "run -all" \

all: \
	create_libs \
	map_libs \
	comp_vhd \
	comp_sv \
	run_sim \