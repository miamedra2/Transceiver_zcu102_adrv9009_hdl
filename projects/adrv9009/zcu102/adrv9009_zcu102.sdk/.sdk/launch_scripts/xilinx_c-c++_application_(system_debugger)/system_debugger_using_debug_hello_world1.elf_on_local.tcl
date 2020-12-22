connect -url tcp:127.0.0.1:3121
source C:/software/Xilinx/SDK/2018.3/scripts/sdk/util/zynqmp_utils.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-SMT2NC 210308A464F3"} -index 1
loadhw -hw C:/github/hdl/projects/adrv9009/zcu102/adrv9009_zcu102.sdk/system_top_hw_platform_0/system.hdf -mem-ranges [list {0x80000000 0xbfffffff} {0x400000000 0x5ffffffff} {0x1000000000 0x7fffffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-SMT2NC 210308A464F3"} -index 1
source C:/github/hdl/projects/adrv9009/zcu102/adrv9009_zcu102.sdk/system_top_hw_platform_0/psu_init.tcl
psu_init
after 1000
psu_ps_pl_isolation_removal
after 1000
psu_ps_pl_reset_config
catch {psu_protection}
targets -set -nocase -filter {name =~"*A53*0" && jtag_cable_name =~ "Digilent JTAG-SMT2NC 210308A464F3"} -index 1
rst -processor
dow C:/github/hdl/projects/adrv9009/zcu102/adrv9009_zcu102.sdk/Hello_World1/Debug/Hello_World1.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~"*A53*0" && jtag_cable_name =~ "Digilent JTAG-SMT2NC 210308A464F3"} -index 1
con
