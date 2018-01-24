-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: _structure.vhd
-- Ver.: 1.0 Release
-- Type: Behavioural
-- Text: Template
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity name is
	-- Komponentenparameter
	Generic	(
					-- Komponentenkonstanten
					constant const_logic		: std_logic := '0';
					constant const_bool			: boolean := true;
					constant const_vector		: std_logic_vector(7 downto 0) := x"11";
					constant const_unsigned	: unsigned(7 downto 0) := x"11";
					constant const_int			: integer range 0 to 10 := 2
					
					-- Komponentenparameter
					var_logic				: std_logic := '0';
					var_bool				: boolean := true;
					var_vector			: std_logic_vector(7 downto 0) := x"11";
					var_unsigned		: unsigned(7 downto 0) := x"11";
					var_int					: integer range 0 to 10 := 2
					);
		-- I/O Signale
			Port(
					LOGIC_i			: in std_logic;
					VECTOR_i		: in std_logic_vector(7 downto 0);
					LOGIC_o			: out std_logic;
					VECTOR_o		: out std_logic_vector(7 downto 0);
					LOGIC_io		: inout std_logic;
					VECTOR_io		: inout std_logic_vector(7 downto 0)
					);
end name;

architecture Behavioural of name is

			-- Standad Signale
			signal _bool			: boolean := false;
			signal _logic			:	std_logic := '0';
			signal _vector		: std_logic_vector(1 downto 0) := (others => '0');
			signal _unsigned	:	unsigned(1 downto 0) := (others => '0');
			signal _integer 	: integer range 0 to 10 := 0;

			-- Array
			type mem is array(0 to 7) of std_logic_vector(7 downto 0);
			signal mem_array_zero 	: mem := (others => (others => '0'));
			signal mem_array_nozero	:	mem :=	(
																				x"00",
																				x"01",
																				x"02",
																				x"03",
																				x"04",
																				x"05",
																				x"06",
																				x"07"
																				);

begin

-- Process xyz
procNAME:	process(LOGIC_i)
						variable _bool			: boolean := false;
						variable _logic			:	std_logic := '0';
						variable _vector		: std_logic_vector(1 downto 0) := (others => '0');
						variable _unsigned	:	unsigned(1 downto 0) := (others => '0');
						variable _integer 	: integer range 0 to 10 := 0;
					begin
						
						
						
					end process procNAME;

end Behavioural;
