library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_sim is
end decoder_sim;

architecture Behavioral of decoder_sim is
    signal clk : std_logic;
    signal record_in : std_logic_vector(31 downto 0);
    signal expect_tag : std_logic_vector(7 downto 0);
    constant ClockPeriod : TIME := 20 ns;
begin
    record_in(31 downto 16) <= (others => '0');
    UUT : entity work.decoder_core
    generic map ( TAG_SIZE=> 4,
              RECORD_SIZE => 16 )
    port map( clk => clk,
              decoder_key => "1110100001011001",
              record_in => record_in,
              expect_tag => expect_tag);

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;
    
    stimulus: process begin
        record_in(15 downto 0) <= "0100001110011000";
        expect_tag <= "00001001";
        wait for 50 ns;
        record_in(15 downto 0) <= "1110000100011011";
        expect_tag <= "00001001";
        wait for 50 ns;
        record_in(15 downto 0) <= "0011010101101100";
        expect_tag <= "00001001";
        wait for 50 ns;
        -- invalid
        record_in(15 downto 0) <= "0011010101101111";
        expect_tag <= "00001001";
        wait for 50 ns;
        record_in(15 downto 0) <= "1111101110101000";
        expect_tag <= "00001001";
        wait for 50 ns;
        record_in(15 downto 0) <= "0101111100101000";
        expect_tag <= "00001001";
        wait;
    end process stimulus;
end Behavioral;
