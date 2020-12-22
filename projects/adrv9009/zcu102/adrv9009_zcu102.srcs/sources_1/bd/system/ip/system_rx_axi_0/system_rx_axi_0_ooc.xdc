
# This XDC is used only for OOC mode of synthesis, implementation.
# These are default values for timing driven synthesis during OOC flow.
# These values will be overwritten during implementation with information
# from top level.

create_clock -name s_axi_aclk -period 10  [get_ports s_axi_aclk]
create_clock -name core_clk   -period 2.5 [get_ports core_clk]

################################################################################

