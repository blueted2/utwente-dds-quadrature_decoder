LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY quadDecoder IS
    PORT (
        a_async : IN STD_LOGIC; -- encoder signal a 
        b_async : IN STD_LOGIC; -- encoder signal b 
        reset : IN STD_LOGIC;   -- active-high reset of pos 
        clk : IN STD_LOGIC;
        position : OUT INTEGER);
END quadDecoder;

ARCHITECTURE behavior of quadDecoder IS 
    signal pos_internal : integer;
BEGIN
    -- update output when internal value changes
    position <= pos_internal;

    PROCESS(reset, clk)
        variable a_prev, b_prev : std_logic;
        variable a_changed, b_changed, a_equal_b : std_logic;
        variable concat : std_logic_vector(0 to 2);
        variable change : integer range -1 to 1;
    BEGIN
        if reset='1' then
            a_prev := a_async;
            b_prev := b_async;
            pos_internal <= 0;
        elsif rising_edge(clk) then

            -- "boolean" (std_logic) expressions moved here to get better names in the netlist
            -- also used in case below
            a_changed := a_prev xor a_async;
            b_changed := b_prev xor b_async;
            a_equal_b := a_async xnor b_async;
            
            -- combine expressions for case statement
            concat := a_changed & b_changed & a_equal_b;

            -- using case instead of nested if statements
            case concat is
                --    ab=
                when "101"  => change := -1; -- a has changed, a == b
                when "100"  => change :=  1; -- a has changed, a != b
                when "011"  => change :=  1; -- b has changed, a == b
                when "010"  => change := -1; -- b has changed, a != b

                when "00-"  => change :=  0; -- nothing has changed

                -- "other" cases
                when "11-"  => change :=  0; -- both changed, shouldn't happen
                when others => change :=  0; -- undefined states
            end case;

            -- remeber current state
            a_prev := a_async;
            b_prev := b_async;

            -- update internal position
            pos_internal <= pos_internal + change;

        end if;
    END PROCESS;

END behavior;