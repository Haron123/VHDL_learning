library IEEE;
use IEEE.std_logic_1164.all;
use std.env.finish;

entity traffic_tb is
end entity traffic_tb;


architecture test of traffic_tb is

signal clk_s, rstn_s : std_logic := '0';

begin
    
clk_s <= not clk_s after 10 ns;

UUT : entity work.trafficlight
port map
(
    clk => clk_s,
    rstn => rstn_s,

    redlight => open,
    greenlight => open,
    yellowlight => open
);

process
begin
    wait for 10 ns;
    rstn_s <= '0';
    wait until rising_edge(clk_s);
    wait until rising_edge(clk_s);
    rstn_s <= '1';
    for i in 1 to 20 loop
        wait until rising_edge(clk_s);
    end loop;

    finish;
end process;
end architecture test;