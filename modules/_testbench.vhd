-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: _testbench.vhd
-- Ver.: 1.0 Release
-- Type: Template
-- Text: Testbench
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity name_tb is
--  Port ( );
end name_tb;

architecture Simulation of name is

	-- Clock definition
	constant	clk_period	: time := 10 ns;				-- Simulation clock period (100 MHz)
	signal 		clk					:	std_logic := '0';	-- Simulation clock signal

	-- Simulation constants
	constant const_logic		: std_logic := '0';
	constant const_bool			: boolean := true;
	constant const_vector		: std_logic_vector(7 downto 0) := x"11";
	constant const_unsigned	: unsigned(7 downto 0) := x"11";
	constant const_int			: integer range 0 to 10 := 2;

	-- Simulations signals
	signal _bool			: boolean := false;
	signal _logic			:	std_logic := '0';
	signal _vector		: std_logic_vector(1 downto 0) := (others => '0');
	signal _unsigned	:	unsigned(1 downto 0) := (others => '0');
	signal _integer 	: integer range 0 to 10 := 0;

	-- Component declaration
	component name is
		-- I/O signals
		Port(
				LOGIC_i			: in std_logic;
				VECTOR_i		: in std_logic_vector(7 downto 0);
				LOGIC_o			: out std_logic;
				VECTOR_o		: out std_logic_vector(7 downto 0);
				LOGIC_io		: inout std_logic;
				VECTOR_io		: inout std_logic_vector(7 downto 0)
				);
	end component fifo;

begin

-- Instantiate unit under test
UUT:	name	port map(
										EN		=>	EN,
										clk		=>	clk
										);

-- Generate a clock signal
procCLK:	process
						begin
							clk <= '0';	wait for clk_period/2;
							clk <= '1';	wait for clk_period/2;
					end process procCLK;

-- Simulation process
procSIM:	process
						begin
							-- Initialization
							EN <= '0';	wait for clk_period;

							-- Simulation Loop
							for I in 0 to 5 loop
								EN <= '0';	wait for clk_period;
							end loop;
							
							--FLUSH complete FIFO
							EN <= '1';	wait for clk_period * 2;

					-- Stop simulation
					wait;
					end process procSIM;

end Simulation;
-- End of simulation process