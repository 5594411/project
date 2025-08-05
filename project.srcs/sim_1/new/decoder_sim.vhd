library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_sim is
end decoder_sim;

architecture Behavioral of decoder_sim is
    signal btnR : std_logic;
    signal clk : std_logic;
    signal record_in : std_logic_vector(31 downto 0);
    signal tag_out : std_logic_vector(7 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    record_in(31 downto 16) <= (others => '0');
    UUT : entity work.decoder_core
    port map( clk => clk,
              decoder_key => "1110100001011001",
              record_in => record_in,
              tag_out => tag_out);

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;
    
    stimulus: process begin
        btnR <= '1';
        record_in(15 downto 0) <= "0100001110011000";
        wait;
    end process stimulus;
end Behavioral;
