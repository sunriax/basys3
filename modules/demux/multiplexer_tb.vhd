--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: master_tb.vhd
--	Version: v1.0
--	------------------------------------
--	Testbench zur master IP mit
--	Standardparametern.
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity multiplexer_tb is
--  Port ( );
end multiplexer_tb;

architecture Simulation of multiplexer_tb is

	-- Simulationskonstanten
	constant CLK_period : time := 10 ns;    -- Systemtakt 100 MHz
	constant EXPONENT	: integer := 3;		-- Exponent für Multiplexer

	-- Simulations I/O Signale
	signal simEN		: STD_LOGIC;
	signal simADDR		: STD_LOGIC_VECTOR(EXPONENT - 1 downto 0);
	signal siminDATA	: STD_LOGIC_VECTOR((2**EXPONENT) - 1 downto 0);
	signal simoutDATA	: STD_LOGIC;

	-- Komponentendeklaration
	component multiplexer is
		Port(
			EN			:  in STD_LOGIC;									-- Enable Signal
			ADDR		:  in STD_LOGIC_VECTOR(EXPONENT - 1 downto 0);		-- Kanalwahl Signal
			inDATA		:  in STD_LOGIC_VECTOR((2**EXPONENT) - 1 downto 0);	-- Eingabedaten
			outDATA		: out STD_LOGIC := '0'								-- Ausgabedaten
			);
	end component multiplexer;

begin

-- Unit under Test
UUT: multiplexer port map(
					EN		=> simEN,
					ADDR	=> simADDR,
					inDATA	=> siminDATA,
					outDATA	=> simoutDATA
					);

-- Testbench Input Signale
process
	begin
		simEN <= '0';	simADDR <= (others => '0');	siminDATA <= (others => '0');	wait for CLK_period * 2;
		simEN <= '1';	simADDR <= "000";			siminDATA <= b"00000001";		wait for CLK_period * 2;
						simADDR <= "000";			siminDATA <= b"11111110";		wait for CLK_period * 2;
						simADDR <= "001";			siminDATA <= b"00000010";		wait for CLK_period * 2;
						simADDR <= "001";			siminDATA <= b"11111101";		wait for CLK_period * 2;
						simADDR <= "010";			siminDATA <= b"00000100";		wait for CLK_period * 2;
						simADDR <= "010";			siminDATA <= b"11111011";		wait for CLK_period * 2;
						simADDR <= "011";			siminDATA <= b"00001000";		wait for CLK_period * 2;
						simADDR <= "011";			siminDATA <= b"11110111";		wait for CLK_period * 2;
						simADDR <= "100";			siminDATA <= b"00010000";		wait for CLK_period * 2;
						simADDR <= "100";			siminDATA <= b"11101111";		wait for CLK_period * 2;
						simADDR <= "101";			siminDATA <= b"00100000";		wait for CLK_period * 2;
						simADDR <= "101";			siminDATA <= b"11011111";		wait for CLK_period * 2;
						simADDR <= "110";			siminDATA <= b"01000000";		wait for CLK_period * 2;
						simADDR <= "110";			siminDATA <= b"10111111";		wait for CLK_period * 2;
						simADDR <= "111";			siminDATA <= b"10000000";		wait for CLK_period * 2;
						simADDR <= "111";			siminDATA <= b"01111111";		wait for CLK_period * 2;
		simEN <= '0';	simADDR <= (others => '0');	siminDATA <= (others => '0');	wait;
end process;

end Simulation;
