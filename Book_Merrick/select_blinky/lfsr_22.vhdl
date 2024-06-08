library ieee;
use ieee.std_logic_1164.all;

entity lsfr_22 is
  port
  (
    -- Inputs
    i_clock : in std_logic;

    -- Outputs
    o_lfsr_data : out std_logic_vector(21 downto 0);
    o_lfsr_done : out std_logic
  );
end entity lsfr_22;

architecture RTL of lsfr_22 is
  signal r_lfsr : std_logic_vector(21 downto 0);
  signal w_xnor : std_logic;
begin
  process(i_clock) begin
    if rising_edge(i_clock) then
      r_lfsr <= r_lfsr(20 downto 0) & w_xnor;
    end if;
  end process;
  
  w_xnor <= r_lfsr(21) xnor r_lfsr(20);
  o_lfsr_done <= '1' when (r_lfsr = "0000000000000000000000") else '0';
  o_lfsr_data <= r_lfsr;
end architecture RTL;