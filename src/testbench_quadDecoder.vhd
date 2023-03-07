LIBRARY ieee; 
USE ieee.std_logic_1164.all;
ENTITY testbench_quadDecoder IS
END testbench_quadDecoder;

ARCHITECTURE structure OF testbench_quadDecoder IS
  COMPONENT testset_quadDecoder IS
    PORT(
      A     :  OUT std_logic; 
      B     :  OUT std_logic; 
      reset :  OUT std_logic;
      clk   :  OUT std_logic	  
    );
  END COMPONENT testset_quadDecoder;  

  COMPONENT quadDecoder IS
    PORT(
      a_async  :  IN  STD_LOGIC;  -- encoder signal a
      b_async  :  IN  STD_LOGIC;  -- encoder signal b
      reset    :  IN  STD_LOGIC;  -- active-high reset of pos
      clk      :  IN  STD_LOGIC;  
      position :  OUT INTEGER);   
  END COMPONENT quadDecoder;

  SIGNAL A,B, reset, clk : std_logic;
  SIGNAL position : integer;

BEGIN
  ts: testset_quadDecoder PORT MAP (A,B,reset,clk);
  qd: quadDecoder PORT MAP( A,B,reset,clk,position);
  
END structure;