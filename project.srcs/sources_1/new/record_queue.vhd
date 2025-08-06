library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity record_queue is
    generic ( SW_TAG_SIZE : integer := 4;
              SW_RECORD_SIZE : integer := 12 );
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           push_en      : in  std_logic;
           record_in : in std_logic_vector(15 downto 0);
           record_out   : out std_logic_vector(31 downto 0);
           tag_out      : out std_logic_vector(7 downto 0));
end record_queue;
signal tag : std_logic_vector(7 downto 0);
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
      if(reset='1') then
         record_out <= (others=>'0');
         tag_out <= (others=>'0');
         var_1 := 1;
      else
        if (rising_edge(clk)) then
          if (var_1 = 1 and push_en = '1') then
                record_out(SW_RECORD_SIZE - 1 downto 0) <= record_in(15 downto SW_TAG_SIZE);
                record_out(31 downto SW_RECORD_SIZE) <= (others => '0');
                tag_out(SW_TAG_SIZE - 1 downto 0) <= record_in(SW_TAG_SIZE - 1 downto 0);
                tag_out(7 downto SW_TAG_SIZE) <= (others => '0');
                
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



