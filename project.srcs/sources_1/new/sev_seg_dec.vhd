LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sev_seg_dec IS
    PORT ( nbl : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
           hex : OUT STD_LOGIC_VECTOR(0 TO 6));
END sev_seg_dec;

ARCHITECTURE behavioural OF sev_seg_dec IS
BEGIN
    PROCESS (nbl)
    BEGIN
        CASE nbl IS --             abcdefg         
	       WHEN "0000" => hex <= "0000001";
	       WHEN "0001" => hex <= "1001111";
	       WHEN "0010" => hex <= "0010010";
	       WHEN "0011" => hex <= "0000110";
	       WHEN "0100" => hex <= "1001100";
	       WHEN "0101" => hex <= "0100100";
	       WHEN "0110" => hex <= "0100000";
	       WHEN "0111" => hex <= "0001111";
	       WHEN "1000" => hex <= "0000000";
	       WHEN "1001" => hex <= "0001100";
	       WHEN "1010" => hex <= "0001000";
	       WHEN "1011" => hex <= "1100000";
	       WHEN "1100" => hex <= "0110001";
	       WHEN "1101" => hex <= "1000010";
	       WHEN "1110" => hex <= "0110000";
	       WHEN OTHERS => hex <= "0111000";
	   END CASE;
    END PROCESS;

END behavioural;
