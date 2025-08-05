-----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.08.2025 23:35:59
-- Design Name: 
-- Module Name: record_queue - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity record_queue is
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           push_en      : in  std_logic;
           record_in : in std_logic_vector(15 downto 0);
           btnC : in std_logic;
           record_out   : out std_logic_vector(31 downto 0);
           tag_out      : out std_logic_vector(7 downto 0));
end record_queue;

architecture behavioral of record_queue is

type queue_array is array(0 to 4) of std_logic_vector(39 downto 0);
signal sig_queue : queue_array :=(
0  => "0000000000000000000000000000000000000000",
1  => "0000000000000000000000000000000000000000",
2  => "0000000000000000000000000000000000000000",
3  => "0000000000000000000000000000000000000000",
4  => "0000000000000000000000000000000000000000");
begin
      queue_process: process (clk, push_en, btnC) is  
      variable var_1 : integer :=0;
      begin
      
      if (btnC = '1') then
        sig_queue(4)(23 downto 8) <= record_in;
        sig_queue(4)(7 downto 0) <= "00001001";
      end if;

      if(reset='1') then 
         record_out <= (others=>'0');
         tag_out <= (others=>'0');
         var_1:=1;
      else
        if (rising_edge(clk)) then
          if (var_1 = 1 and push_en = '1') then
                record_out <= sig_queue(4)(31 downto 0);
                tag_out <= sig_queue(4)(7 downto 0);
                
                sig_queue(4)  <= sig_queue(3);
                sig_queue(3)  <= sig_queue(2);
                sig_queue(2)  <= sig_queue(1);  
                sig_queue(1)  <= sig_queue(0);
                sig_queue(0)  <= (others=>'0');
          elsif (push_en='0') then
                record_out <= (others=>'0');
                tag_out <= (others=>'0');            
          end if;
        end if;
       end if;
   end process;
       
end behavioral;



