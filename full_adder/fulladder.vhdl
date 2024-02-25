library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
  port
  (
    -- Inputs
    A : in std_logic;
    B : in std_logic;
    C : in std_logic;

    -- Outputs
    sum : out std_logic;
    carry : out std_logic
  );
end entity fulladder;

architecture RTL of fulladder is
  -- Declare xor result
  signal xor_result : std_logic;

  begin
    -- Calculate xor result
    xor_result <= A xor B;

    -- Full adder Logic
    sum <= (xor_result xor C);
    carry <= ((A and B) or (xor_result and C));

end architecture RTL;
    