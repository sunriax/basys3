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
			constant DATAWIDTH	: integer range 1 to 64 := 8		-- Datawidth of counter
			);
	-- I/O signals
		Port(
			EN		: in std_logic;									-- Enable
			clk		: in std_logic;									-- Counter/System clock
			DIR		: in std_logic;									-- Counter direction
			INIT	: in std_logic_vector(DATAWIDTH - 1 downto 0);	-- Initialize start parameter
			COUNT	: out std_logic_vector(DATAWIDTH - 1 downto 0)	-- Counter output
			);
end counter;

architecture Behavioural of counter is
	signal intCOUNT : unsigned(DATAWIDTH - 1 downto 0) := (others => '0');	-- Internal counter signal
begin

-- Counter process
counter:	process(EN, clk, INIT)
			begin
				
				-- Asynchronous logic system
				if(EN <= '0') then
					
					-- Reset all signals to initialsation
					COUNT <= INIT;
					intCOUNT <= unsigned(INIT);
					
				-- Synchronous logic system
				elsif(rising_edge(CLK)) then
				
					-- Incremental counting direction
					if(DIR = '0') then
					
						intCOUNT <= intCOUNT + 1;				-- Increment counter
						COUNT <= std_logic_vector(intCOUNT);	-- Write counter value to output
					
					-- Decremental counting direction
					else
					
						intCOUNT <= intCOUNT - 1;				-- Incremental counter
						COUNT <= std_logic_vector(intCOUNT);	-- Write counter value to output
						
					end if;
				end if;
			end process counter;

end Behavioural;
