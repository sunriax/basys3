-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: bridge.vhd
-- Ver.: 1.0 Release
-- Type: Structure
-- Text: 
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.all;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity bridge is
		Port(
				EN			: in  std_logic;	-- Enable Signal
				hostRXD		: out std_logic;	-- RXD Pin des Host
				hostTXD		: in  std_logic;	-- TXD Pin des Host
				modulTXD	: in  std_logic;	-- TXD Pin des Moduls
				modulRXD	: out std_logic		-- RXD Pin des Moduls
				);
end bridge;

architecture Behavioral of bridge is

begin

	hostRXD <= modulTXD WHEN EN = '1' ELSE '1';
	modulRXD <= hostTXD WHEN EN = '1' ELSE '1';

end Behavioral;
