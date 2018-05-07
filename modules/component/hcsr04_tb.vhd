-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: hcsr04_tb.vhd
-- Ver.: 1.0 Release
-- Type: Testbench
-- Text: Simulate the execution of a
--       HCSR04 measurement
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity hcsr04_tb is
--  Port ( );
end hcsr04_tb;

architecture Simulation of hcsr04_tb is

	-- Simulation constants
	constant clk_period	: time		:= 10 ns;	-- Simulation clock period (100 MHz)
	constant DATAWIDTH	: integer	:= 16;		-- Length of data output

	-- Simulations Unit I/O signals
	signal clk		: std_logic := '0';
	signal EN		: std_logic := '0';
	signal trigger	: std_logic := '0';
	signal echo		: std_logic := '0';
	signal valid	: std_logic := '0';
	signal data		: std_logic_vector((DATAWIDTH - 1) downto 0) := (others => '0');

	-- Declaration of component
	component hcsr04 is
		Generic	(
				constant DATAWIDTH	: integer
				);
			Port(
				EN		:	 in std_logic;
				clk		:	 in std_logic;
				trigger	:	out std_logic;
				echo	:	 in std_logic;
				valid	:	out std_logic;
				data	:	out std_logic_vector((DATAWIDTH - 1) downto 0)
				);
	end component hcsr04;

begin

-- Unit under test description
UUT:	hcsr04  generic map (
							-- All other parameters will be standard
							DATAWIDTH 	=>	DATAWIDTH
							)
					port map(
							EN		=>	EN,
							clk		=>	clk,
							trigger	=>	trigger,
							echo	=>	echo,
							valid	=>	valid,
							data	=>	data
							);

-- Generate clock signal
procCLK:	process
				begin
					clk <= '0';	wait for clk_period/2;
					clk <= '1';	wait for clk_period/2;
			end process procCLK;

-- Stimuli Process
procSIM:	process
			begin
				-- Initialization
				EN <= '0';	echo <= '0';	wait for clk_period * 2;
				
				-- Starting conversion
				EN <= '1';	echo <= '0';	wait for clk_period * 10000;
				EN <= '1';	echo <= '1';	wait for clk_period * 100;
				EN <= '1';	echo <= '0';	wait for clk_period * 20000;
				EN <= '1';	echo <= '1';	wait for clk_period * 100;
				EN <= '1';	echo <= '0';	wait for clk_period * 30000;
				EN <= '1';	echo <= '1';	wait for clk_period * 100;
				EN <= '1';	echo <= '0';	wait for clk_period * 40000;
				EN <= '1';	echo <= '1';	wait for clk_period * 100;
				EN <= '1';	echo <= '0';
				
				wait;
			end process procSIM;
			
end Simulation;
