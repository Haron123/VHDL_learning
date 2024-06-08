library ieee;
use ieee.std_logic_1164.all;

entity seg7 is
  port
  (
    -- Inputs
    i_number : in integer range 0 to 7 ;

    -- Outputs
    A : out std_logic;
    B : out std_logic;
    C : out std_logic;
    D : out std_logic;
    E : out std_logic;
    F : out std_logic;
    G : out std_logic;
    SEL : out std_logic
  );
end entity seg7;

architecture RTL of seg7 is
  signal r_hex : std_logic_vector(6 downto 0);
begin
  process(i_number) begin
    case i_number is
      when 0 => r_hex <= "0000001"; -- 0
      when 1 => r_hex <= "1001111"; -- 1
      when 2 => r_hex <= "0010010"; -- 2
      when 3 => r_hex <= "0000110"; -- 3
      when 4 => r_hex <= "1001100"; -- 4
      when 5 => r_hex <= "0100100"; -- 5
      when 6 => r_hex <= "0100000"; -- 6
      when 7 => r_hex <= "0001111"; -- 7
      when others => r_hex <= "0000000"; -- error
    end case;
  end process;

  A <= r_hex(6);
  B <= r_hex(5);
  C <= r_hex(4);
  D <= r_hex(3);
  E <= r_hex(2);
  F <= r_hex(1);
  G <= r_hex(0);
  
end architecture RTL;