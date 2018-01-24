
-- VHDL syncrhonous process with an asynchron reset
-- This is very important for the synthesis tool.

process(EN, clk)
	begin
		-- Asynchron Reset
		if(EN = '0') then
		
		-- Synchron Process 
		elsif(rising_edge(CLK)) then
			
		end if;
end process;