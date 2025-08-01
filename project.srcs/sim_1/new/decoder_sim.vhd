library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_sim is
end decoder_sim;

architecture Behavioral of decoder_sim is
    signal btnR : std_logic;
    signal clk : std_logic;
    signal sw : std_logic_vector(15 downto 0);
    signal led : std_logic_vector(15 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    UUT : entity work.decoder_core
    port map( clk => clk,
              btnR => btnR,
              sw => sw,
              led => led);

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;
    
    stimulus: process begin
        btnR <= '1';
        sw <= "0000111100001111";
        
        wait for 50 ns;
        btnR <= '1';
        sw <= "0000000011111111";
        wait;
    end process stimulus;
end Behavioral;
