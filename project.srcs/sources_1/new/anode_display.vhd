library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity anode_display is
  Port ( clk : in std_logic;
         data : in std_logic_vector(7 downto 0);
         an : out std_logic_vector(3 downto 0);
         display_data : out std_logic_vector(7 downto 0));
end anode_display;

architecture Behavioral of anode_display is
    signal clk_divider : std_logic_vector(15 downto 0);
    signal result : integer range 0 to 1024;
begin
    result <= to_integer(unsigned(data));
    process(clk)
    begin
        if rising_edge(clk) then
            clk_divider <= clk_divider + 1;
        case clk_divider(15 downto 14) is
            when "00" => 
                an <= "1110"; 
                display_data <= std_logic_vector(to_unsigned(result mod  10, 8));
            when "01" => 
                an <= "1101"; 
                display_data <= std_logic_vector(to_unsigned(result / 10 mod 10, 8));
            when "10" => 
                an <= "1011"; 
                display_data <= std_logic_vector(to_unsigned(result / 100, 8));
            when others => 
                an <= "0111"; 
                display_data <= (others => '0');
            end case;
        end if;
    end process;
end Behavioral;
