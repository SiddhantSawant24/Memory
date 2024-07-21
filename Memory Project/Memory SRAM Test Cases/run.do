vlib work
vlog tb.v
vsim tb   +testcase=fd_write_fd_read
#add wave -position insertpoint sim:/tb/dut/*
do wave.do
run -all

