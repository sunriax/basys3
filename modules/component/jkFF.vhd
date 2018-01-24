
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity jkFF is
	Port (	CLK	: in STD_LOGIC;
			J	: in STD_LOGIC;
			K	: in STD_LOGIC;
			Q	: out STD_LOGIC;
			nQ	: out STD_LOGIC);
end jkFF;

architecture Behavioral of jkFF is
	begin
		process(CLK)
				variable TMP: std_logic;
			begin
			if rising_edge(CLK) then
				if(J='0' and K='0')then
					TMP := TMP;
				elsif(J='1' and K='1')then
					TMP := not TMP;
				elsif(J='0' and K='1')then
					TMP := '0';
				else
					TMP := '1';
				end if;
			end if;

			Q <= TMP;
			nQ <= not TMP;

		end PROCESS;
end Behavioral;
