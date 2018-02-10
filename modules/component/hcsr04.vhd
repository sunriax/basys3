-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: hcsr04.vhd
-- Ver.: 1.0 Release
-- Type: Behavioural
-- Text: Get the distance of an object
--       with the hcsr04 module
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hcsr04 is

	Generic	(
					constant CLOCK			: integer := 100_000_000;
					constant DATAWIDTH	: integer := 16
					);

			Port(
					EN			:  in std_logic;
					clk			:	 in std_logic;
					trigger	:	out std_logic;
					echo		:	out std_logic;
					data		: out std_logic_vector((DATAWIDTH - 1) downto 0)
					);
end hcsr04;

architecture Behavioural of hcsr04 is



begin



end Behavioural;
