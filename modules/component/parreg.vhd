
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity parreg is
    Port (	E	: in STD_LOGIC;
    		D	: in STD_LOGIC;
    		Q	: out STD_LOGIC;
    		nQ	: out STD_LOGIC);
end parreg;

architecture Behavioral of parreg is
begin
process(E, D)
	begin
		if (E = '1' and D = '0') then
			Q <= '0';
			nQ <= '1';
		elsif (E = '1' and D = '1') then
			Q <= '1';
			nQ <= '0';
		end if;
end process;
end Behavioral;
