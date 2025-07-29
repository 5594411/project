library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity swap_sim is
--  Port ( );
end swap_sim;

architecture Behavioral of swap_sim is
    component swap is
    port ( clk : in std_logic;
           enable : in std_logic;
           block_x         : in  std_logic_vector(7 downto 0);
           block_y         : in  std_logic_vector(7 downto 0);
           px         : in  std_logic_vector(3 downto 0);
           py         : in  std_logic_vector(3 downto 0);
           s          : in  std_logic_vector(3 downto 0);
           bx_swapped : out std_logic_vector(7 downto 0);
           by_swapped : out std_logic_vector(7 downto 0));
    end component;

    signal sig_block_x, sig_block_y, sig_swaped_block_x, sig_swaped_block_y : std_logic_vector(7 downto 0);
    signal px, py, s : std_logic_vector(3 downto 0);
    signal clk, enable : std_logic;
    constant ClockPeriod : TIME := 20 ns;
begin
    UUT : swap
 port map( clk => clk,
              enable => enable,
              block_x => sig_block_x,
              block_y => sig_block_y,
              px => px,
              py => py,
              s => s,
              bx_swapped => sig_swaped_block_x,
              by_swapped => sig_swaped_block_y);

    clck: process begin
        clk <= '0';
        loop
            wait for (ClockPeriod / 2);
            clk <= not clk;
        end loop;
    end process clck;

    stimulus: process begin
        enable <= '1';
        sig_block_x <= "01010101";
        sig_block_y <= "00001111";
        px <= "0000";
        py <= "0011";
        s <= "0011";
        wait for 20 ns;
            enable <= '0';
        wait;
    end process stimulus;
end Behavioral;
