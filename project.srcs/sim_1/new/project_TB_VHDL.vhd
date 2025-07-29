
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity project_TB_VHDL is
end project_TB_VHDL;


architecture behave of project_TB_VHDL is
 
  -- 1 GHz = 2 nanoseconds period
  constant c_CLOCK_PERIOD : time := 2 ns; 


 signal r_CLOCK     : std_logic := '0';
 signal r_reset    : std_logic := '0';
 

-- Component declaration for the Unit Under Test (UUT)
component project_core is
    port ( clk    : in  std_logic );
end component ;

begin
   
    -- Instantiate the Unit Under Test (UUT)
    UUT : project_core
      port map (
        clk     => r_CLOCK
                    
        );
   
    p_CLK_GEN : process is
    begin
      wait for c_CLOCK_PERIOD/2;
      r_CLOCK <= not r_CLOCK;
    end process p_CLK_GEN; 
     
    process                               -- main testing
    begin
      r_reset <= '0';
   
         wait for 2*c_CLOCK_PERIOD ;
    r_reset <= '1';
       
       wait for 2*c_CLOCK_PERIOD ;
            r_reset <= '0';         
      
      wait for 2 sec;
       
    end process;
     
end behave;
  