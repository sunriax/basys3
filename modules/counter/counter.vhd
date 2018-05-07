-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: counter.vhd
-- Ver.: 1.0 Release
-- Type: Behavioural
-- Text: Module for counting clock
--       cycles. With variable bit
--       length and direction
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
	-- System parameters
	 Generic(
			constant DATAWIDTH	: integer range 1 to 64 := 8	-- Datawidth of counter
			);
	-- I/O signals
		Port(
			-- Enable und Takteingang
			EN		: in std_logic;
			clk		: in std_logic;
			
			-- Counter Direction
			DIR		: in std_logic;
			
			-- Startwert Initialisieren
			INIT	: in std_logic_vector(DATAWIDTH - 1 downto 0);

			-- Zählerausgang
			COUNT	: out std_logic_vector(DATAWIDTH - 1 downto 0)
			);
end counter;

architecture Behavioural of counter is
	signal intCOUNT : unsigned(DATAWIDTH - 1 downto 0) := (others => '0');	-- Interne Zählvariable
begin

-- Counter process
counter:	process(EN, clk, INIT)
			begin
				
				-- Asynchronous logic system
				if(EN <= '0') then
					
					-- Reset all output to initialsation
					COUNT <= INIT;
					intCOUNT <= unsigned(INIT);
					
				-- Synchronous logic system
				elsif(rising_edge(CLK)) then
				
					-- Forward counting direction
					if(DIR = '0') then
					
						intCOUNT <= intCOUNT + 1;
						COUNT <= std_logic_vector(intCOUNT);	-- Increment counter
					
					-- Backward counting direction
					else
					
						intCOUNT <= intCOUNT - 1;
						COUNT <= std_logic_vector(intCOUNT);	-- Decrement counter
						
					end if;
				end if;
			end process counter;

end Behavioural;
