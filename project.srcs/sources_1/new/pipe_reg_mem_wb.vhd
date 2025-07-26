library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipe_reg_mem_wb is
    Port ( clk : in STD_LOGIC;

           ctrl_MemToRegIN  : in STD_LOGIC;
           ctrl_MemToReg    : out STD_LOGIC;
           
           ctrl_RegWriteIN  : in STD_LOGIC;
           ctrl_RegWrite    : out STD_LOGIC;
           
           ALUResultIN : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           ALUResult   : out STD_LOGIC_VECTOR(15 DOWNTO 0);

           WBAddrIN : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
           WBAddr   : out STD_LOGIC_VECTOR(3 DOWNTO 0);    
                  
           dataMemoryIN : in  STD_LOGIC_VECTOR(15 DOWNTO 0);
           dataMemory   : out STD_LOGIC_VECTOR(15 DOWNTO 0)
         );
end pipe_reg_mem_wb;

architecture Behavioral of pipe_reg_mem_wb is

begin
 reg: entity work.pipe_reg
        GENERIC MAP (n => 2 + 36)
        PORT MAP (
          clk => clk,
          rst => '0',
          writeDisable => '0',
         
          dIn(37) => ctrl_MemToRegIN,
          dIn(36) => ctrl_RegWriteIN,
          dIn(35 DOWNTO 20) => ALUResultIN,
          dIn(19 DOWNTO 16) => WBAddrIN,
          dIn(15 DOWNTO 0) => dataMemoryIN,
          
          dOut(37) => ctrl_MemToReg,
          dOut(36) => ctrl_RegWrite,
          dOut(35 DOWNTO 20) => ALUResult,
          dOut(19 DOWNTO 16) => WBAddr,
          dOut(15 DOWNTO 0) => dataMemory
        );

end Behavioral;
