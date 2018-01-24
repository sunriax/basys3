-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: HCSR04setup.vhd
-- Ver.: 1.0 Release
-- Type: Structure
-- Text: Connecting the HCSR04 data to
--       an SPI bus master
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HCSR04setup is
	-- Parameter
	Generic	(
					constant CLOCK		: integer := 100 * 10**6;				-- System speed (100 MHz)
					constant DATASIZE	: integer range 8 to 16 := 16		-- Datawidthof hcsr04DATA
					);
	-- I/O signals
	Port(
			clk					:	 in std_logic,
			EN					:	 in std_logic;
			
			spiCLK			:	 in std_logic;
			spiMOSI			:	 in std_logic;
			spiSS				:	 in std_logic;
			spiMISO			:	out std_logic;
			
			hcsr04IRQ		:	 in std_logic;
			hcsr04DATA	:  in std_logic_vector((DATASIZE - 1) downto 0)
			);
end HCSR04setup;

architecture Structure of HCSR04setup is

begin


end Structure;
