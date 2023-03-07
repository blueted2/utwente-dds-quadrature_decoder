LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY testset_quadDecoder IS
  PORT(
    A     :  OUT STD_LOGIC; 
    B     :  OUT STD_LOGIC; 
    reset :  OUT STD_LOGIC ;
    clk   :  OUT STD_LOGIC    
  );
END testset_quadDecoder;

ARCHITECTURE bhv OF testset_quadDecoder IS

  SIGNAL clki : std_logic := '0';
  
  SIGNAL clk_data : std_logic := '0'; -- used for generation A and B
  SIGNAL ai, bi : std_logic;
  SIGNAL finished : boolean := FALSE;
  
  FUNCTION incr_gray (i : std_logic_vector(1 downto 0)) return std_logic_vector is
  BEGIN
    CASE i IS
    WHEN "00"   => RETURN "10";
    WHEN "10"   => RETURN "11";   
    WHEN "11"   => RETURN "01";
    WHEN OTHERS => RETURN "00";
  END CASE;
  END FUNCTION incr_gray;

  FUNCTION decr_gray (i : std_logic_vector(1 downto 0)) return std_logic_vector is
  BEGIN
    CASE i IS
    WHEN "00"   => RETURN "01";
    WHEN "10"   => RETURN "00";   
    WHEN "11"   => RETURN "10";
    WHEN OTHERS => RETURN "11";
  END CASE;
  END FUNCTION decr_gray;  
BEGIN

  clki <= not clki after 10 ns when not finished;
  clk  <= clki;

  clk_data <= not clk_data after 78 ns when not finished;
  A <= ai; B <= bi;
  
  PROCESS
  BEGIN
    reset <= '1'; ai<='0'; bi<='0';
    WAIT UNTIL falling_edge(clk_data);
    reset <= '0';
    WAIT UNTIL falling_edge(clk_data);
    REPORT "rotate right; increment nmb" SEVERITY note;
    FOR i IN 0 TO 12 LOOP
      (ai,bi) <= incr_gray(ai&bi);
      WAIT UNTIL falling_edge(clk_data);
    END LOOP;
  
    REPORT "no rotation" SEVERITY note;
    FOR i IN 0 TO 5 LOOP
      WAIT UNTIL falling_edge(clk_data);
    END LOOP;
  
    REPORT "rotate left; decrement nmb" SEVERITY note;
    FOR i IN 0 TO 12 LOOP
      (ai,bi) <= decr_gray(ai&bi);
      WAIT UNTIL falling_edge(clk_data);
    END LOOP;  
  
    REPORT "finished" SEVERITY note;
    finished <= TRUE;
    WAIT;
  END PROCESS;
  
END bhv;