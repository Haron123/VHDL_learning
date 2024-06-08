library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity trafficlight is
    port 
    (
        clk : in std_logic;
        rstn : in std_logic;

        redlight : out std_logic;
        greenlight : out std_logic;
        yellowlight : out std_logic
    );
end entity trafficlight;

architecture rtl of trafficlight is
    
type states is (RED, REDYELLOW, GREEN, YELLOW);

signal state_cs, state_ns : states;
signal redlight_s, greenlight_s, yellowlight_s : std_logic;
signal counter_cs, counter_ns : std_logic_vector(31 downto 0);

begin
-- output assignments
redlight <= redlight_s;
greenlight <= greenlight_s;
yellowlight <= yellowlight_s;

-- Synchronous
sync: process(clk)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            state_cs <= RED;
            counter_cs <= (others => '0');
        else
            state_cs <= state_ns;
            counter_cs <= counter_ns;
        end if;
    end if;
end process sync;

-- Combitional
comb: process(state_cs, counter_cs)
    variable state_v : states;
    variable greenlight_v, yellowlight_v, redlight_v : std_logic;
    variable counter_v : std_logic_vector(31 downto 0);
begin
    state_v := state_cs;
    counter_v := counter_cs;

    greenlight_v := '0';
    yellowlight_v := '0';
    redlight_v := '0';

    case state_v is
        when RED =>
            greenlight_v := '0';
            yellowlight_v := '0';
            redlight_v := '1';

            if counter_v(24) = '1' then
                state_v := REDYELLOW;
                counter_v := (others => '0');
            end if;
        when REDYELLOW =>
            greenlight_v := '0';
            yellowlight_v := '1';
            redlight_v := '1';

            if counter_v(24) = '1' then
                state_v := GREEN;
                counter_v := (others => '0');
            end if;
        when GREEN =>
            greenlight_v := '1';
            yellowlight_v := '0';
            redlight_v := '0';

            if counter_v(24) = '1' then
                state_v := YELLOW;
                counter_v := (others => '0');
            end if;
        when YELLOW =>
            greenlight_v := '0';
            yellowlight_v := '1';
            redlight_v := '0';

            if counter_v(24) = '1' then
                state_v := RED;
                counter_v := (others => '0');
            end if;
        end case;

    state_ns <= state_v;
    counter_ns <= std_logic_vector(unsigned(counter_v) + 1);
    
    redlight_s <= redlight_v;
    greenlight_s <= greenlight_v;
    yellowlight_s <= yellowlight_v;
end process comb;


    
end architecture rtl;