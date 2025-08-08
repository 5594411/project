---------------------------------------------------------------------------
-- register_file.vhd - Implementation of A Dual-Port, 16 x 16-bit
--                     Collection of Registers.
-- 
--
-- Copyright (C) 2006 by Lih Wen Koh (lwkoh@cse.unsw.edu.au)
-- All Rights Reserved. 
--
-- The single-cycle processor core is provided AS IS, with no warranty of 
-- any kind, express or implied. The user of the program accepts full 
-- responsibility for the application of the program and the use of any 
-- results. This work may be downloaded, compiled, executed, copied, and 
-- modified solely for nonprofit, educational, noncommercial research, and 
-- noncommercial scholarship purposes provided that this notice in its 
-- entirety accompanies all copies. Copies of the modified software can be 
-- delivered to persons who use it solely for nonprofit, educational, 
-- noncommercial research, and noncommercial scholarship purposes provided 
-- that this notice in its entirety accompanies all copies.
--
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity register_file is
   generic( tally_size    : integer :=8);
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           old_key         : out  std_logic_vector(15 downto 0);
           new_key         : in  std_logic_vector(15 downto 0);
           c0              : in std_logic_vector (tally_size-1 downto 0);
           c1              : in std_logic_vector (tally_size-1 downto 0);
           c2              : in std_logic_vector (tally_size-1 downto 0);
           c3              : in std_logic_vector (tally_size-1 downto 0);
           key_en           : in std_logic;
           write_enable        : in std_logic);
end register_file;

architecture behavioral of register_file is

type reg_file is array(0 to 3) of std_logic_vector(31 downto 0);
signal sig_regfile : reg_file; 

begin

    mem_process : process ( reset,
                            clk ) is

    variable var_regfile     : reg_file;
    variable var_write_addr  : integer;
    
    begin
    
        
        if (reset = '1') then
            -- initial values of the registers - reset to zeroes
            var_regfile := (others => X"00000000");

        elsif (rising_edge(clk) and write_enable = '1') then
            -- register write on the falling clock edge
            
            var_regfile(0)(tally_size-1 downto 0) := c0;
            var_regfile(1)(tally_size-1 downto 0) := c1;
            var_regfile(2)(tally_size-1 downto 0) := c2;
            var_regfile(3)(tally_size-1 downto 0) := c3;
            var_regfile(0)(31 downto tally_size) := (others => '0');
            var_regfile(1)(31 downto tally_size) := (others => '0');
            var_regfile(2)(31 downto tally_size) := (others => '0');
            var_regfile(3)(31 downto tally_size) := (others => '0');
        end if;
        if (rising_edge(clk) and key_en='1') then
            
                old_key<=new_key;
            end if; 



        -- the following are probe signals (for simulation purpose)
        sig_regfile <= var_regfile;

    end process; 
end behavioral;