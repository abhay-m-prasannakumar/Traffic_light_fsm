library ieee;
use ieee.std_logic_1164.all;

entity tb_simple_fsm is
end entity;

architecture testbench of tb_simple_fsm is

  signal clock       : std_logic := '0';
  signal reset       : std_logic := '0';
  signal side_sensor : std_logic := '0';
  signal M_red, M_yellow, M_green : std_logic;
  signal S_red, S_yellow, S_green : std_logic;

  constant CLK_PERIOD : time := 10 ns;

begin

  -- Instantiate the DUT (Design Under Test)
  uut: entity work.simple_fsm
    port map (
      clock => clock,
      reset => reset,
      side_sensor => side_sensor,
      M_red => M_red,
      M_yellow => M_yellow,
      M_green => M_green,
      S_red => S_red,
      S_yellow => S_yellow,
      S_green => S_green
    );

  -- Clock generation process
  clk_process: process
  begin
    while true loop
      clock <= '0';
      wait for CLK_PERIOD/2;
      clock <= '1';
      wait for CLK_PERIOD/2;
    end loop;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Apply reset
    reset <= '1';
    wait for 20 ns;
    reset <= '0';

    -- side_sensor = '0' initially
    side_sensor <= '0';
    -- Wait enough time to observe FSM staying in main_green
    wait for 50 ns;

    -- Change side_sensor to '1' to request side road green
    side_sensor <= '1';
    -- Wait enough time to observe state transitions
    wait for 100 ns;

    -- Optionally, set side_sensor back to '0'
    side_sensor <= '0';
    wait for 50 ns;

    -- Finish simulation
    wait;
  end process;

end architecture;
