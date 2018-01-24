## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

##Pmod Header JXADC
##Sch name = XA1_P
#set_property PACKAGE_PIN J3 [get_ports {XADC[0]}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {XADC[0]}]
###Sch name = XA2_P
#set_property PACKAGE_PIN L3 [get_ports {XADC[1]}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {XADC[1]}]
###Sch name = XA3_P
#set_property PACKAGE_PIN M2 [get_ports {XADC[2]}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {XADC[2]}]
###Sch name = XA4_P
#set_property PACKAGE_PIN N2 [get_ports {XADC[3]}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {XADC[3]}]
###Sch name = XA1_N
#set_property PACKAGE_PIN K3 [get_ports {XADC[4]}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {XADC[4]}]
###Sch name = XA2_N
#set_property PACKAGE_PIN M3 [get_ports {XADC[5]}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {XADC[5]}]
###Sch name = XA3_N
#set_property PACKAGE_PIN M1 [get_ports {XADC[6]}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {XADC[6]}]
###Sch name = XA4_N
#set_property PACKAGE_PIN N1 [get_ports {XADC[7]}]				
#	set_property IOSTANDARD LVCMOS33 [get_ports {XADC[7]}]