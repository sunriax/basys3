## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

##VGA Connector
set_property PACKAGE_PIN G19 [get_ports {vgaR[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[0]}]
set_property PACKAGE_PIN H19 [get_ports {vgaR[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[1]}]
set_property PACKAGE_PIN J19 [get_ports {vgaR[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[2]}]
set_property PACKAGE_PIN N19 [get_ports {vgaR[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[3]}]
set_property PACKAGE_PIN N18 [get_ports {vgaB[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[0]}]
set_property PACKAGE_PIN L18 [get_ports {vgaB[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[1]}]
set_property PACKAGE_PIN K18 [get_ports {vgaB[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[2]}]
set_property PACKAGE_PIN J18 [get_ports {vgaB[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[3]}]
set_property PACKAGE_PIN J17 [get_ports {vgaG[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[0]}]
set_property PACKAGE_PIN H17 [get_ports {vgaG[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[1]}]
set_property PACKAGE_PIN G17 [get_ports {vgaG[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[2]}]
set_property PACKAGE_PIN D17 [get_ports {vgaG[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[3]}]
set_property PACKAGE_PIN P19 [get_ports h_SYNC]						
	set_property IOSTANDARD LVCMOS33 [get_ports h_SYNC]
set_property PACKAGE_PIN R19 [get_ports v_SYNC]						
	set_property IOSTANDARD LVCMOS33 [get_ports v_SYNC]