-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use std.env.finish;

entity i2c_tb is
end entity i2c_tb;

architecture test of i2c_tb is
	signal r_start, r_stop, r_rw, r_clock, r_scl, r_sda, r_dv : std_logic := '0';
    signal r_data : std_logic_vector(7 downto 0);
begin
	r_clock <= not r_clock after 10 ns;
    UUT : entity work.I2C
	generic map (CLOCK_DIV => 0)
    port map
    (
    	i_clock => r_clock,
        i_data => r_data,
        i_start => r_start,
        i_stop => r_stop,
        i_rw => r_rw,
        i_dv => r_dv,
        o_scl => r_scl,
        o_sda => r_sda,
        o_data => open,
        o_send_done => open,
        o_read_done => open,
        o_error => open,
        o_ready => open
    );
    
  	process is
    begin
    	wait for 10 ns;
        wait until rising_edge(r_clock);
        r_start <= '1';
        wait until rising_edge(r_clock);
        r_start <= '0';
        wait until rising_edge(r_clock);
        r_data <= "10101100";
        r_dv <= '1';
        wait until rising_edge(r_clock);
        r_dv <= '0';
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait until rising_edge(r_clock);
        wait for 20 ns;
        finish;
	end process;
end test;