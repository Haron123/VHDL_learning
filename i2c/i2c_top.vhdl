-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity i2c_top is
  port
  (
    i_clock : in std_logic;

    PMOD1 : out std_logic;
    PMOD2 : inout std_logic
  );
end entity i2c_top;

architecture RTL of i2c_top is
	signal r_start, r_stop, r_rw, r_clock, r_dv, r_sr, r_sw : std_logic := '0';
  signal r_ready : std_logic;
  signal r_data : std_logic_vector(7 downto 0);
  signal r_step : integer range 0 to 11;
begin
  UUT : entity work.I2C
  generic map 
  (
    CLOCK_DIV => 32
  )
  port map
  (
    i_clock => i_clock,
    i_data => r_data,
    i_start => r_start,
    i_stop => r_stop,
    i_sw => r_sw,
    i_sr => r_sr,
    o_scl => PMOD1,
    io_sda => PMOD2,
    o_data => open,
    o_dv => open,
    o_error => open,
    o_ready => r_ready
  );
  
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      if(r_ready = '1')
      then
    	  case r_step is
          when 0 =>
            r_start <= '1';
            r_step <= r_step + 1;
          when 1 =>
            r_start <= '0';
            r_step <= r_step + 1;
          when 2 =>
            r_data <= x"A0";
            r_sw <= '1';
            r_step <= r_step + 1;
          when 3 =>
            r_sw <= '0';
            r_step <= r_step + 1;
          when 4 =>
            r_data <= x"CC";
            r_sw <= '1';
            r_step <= r_step + 1;
          when 5 =>
            r_sw <= '0';
            r_step <= r_step + 1;
          when 6 =>
            r_start <= '1';
            r_step <= r_step + 1;
          when 7 =>
            r_start <= '0';
            r_step <= r_step + 1;
          when 8 =>
            r_sr <= '1';
            r_step <= r_step + 1;
          when 9 =>
            r_sr <= '0';
            r_step <= r_step + 1;
          when 10 =>
            r_stop <= '1';
            r_step <= r_step + 1;
          when 11 =>
            r_stop <= '0';
        end case;
      end if;
    end if;
	end process;
end architecture RTL;