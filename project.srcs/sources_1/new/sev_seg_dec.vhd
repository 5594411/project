LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sev_seg_dec IS
    PORT ( display_data : in std_logic_vector(7 downto 0);
           seg : OUT STD_LOGIC_VECTOR(0 TO 6));
END sev_seg_dec;

ARCHITECTURE behavioural OF sev_seg_dec IS
BEGIN
    process(display_data)
    begin
        case display_data is
            when "00000000" => seg <= "1000000";
            when "00000001" => seg <= "1111001";
            when "00000010" => seg <= "0100100";
            when "00000011" => seg <= "0110000";
            when "00000100" => seg <= "0011001";
            when "00000101" => seg <= "0010010";
            when "00000110" => seg <= "0000010";
            when "00000111" => seg <= "1111000";
            when "00001000" => seg <= "0000000";
            when "00001001" => seg <= "0010000";
            when others => seg <= "1111111";  -- Blank
        end case;
    end process;
END behavioural;
