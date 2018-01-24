## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports UART_RXD]						
	set_property IOSTANDARD LVCMOS33 [get_ports UART_RXD]
set_property PACKAGE_PIN A18 [get_ports UART_TXD]						
	set_property IOSTANDARD LVCMOS33 [get_ports UART_TXD]

##USB HID (PS/2)
#set_property PACKAGE_PIN C17 [get_ports PS2Clk]						
	#set_property IOSTANDARD LVCMOS33 [get_ports PS2Clk]
	#set_property PULLUP true [get_ports PS2Clk]
#set_property PACKAGE_PIN B17 [get_ports PS2Data]					
	#set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]	
	#set_property PULLUP true [get_ports PS2Data]