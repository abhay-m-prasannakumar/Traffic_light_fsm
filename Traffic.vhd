
library ieee;
use ieee.std_logic_1164.all;

entity simple_fsm is
  port (
    clock : in std_logic;
    reset : in std_logic;
    side_sensor : in std_logic;
    M_red,M_yellow,M_green,S_red,S_yellow,S_green: out std_logic
  );
end entity;

architecture behavioral of simple_fsm is
  type state_type is (main_green,main_yellow,side_green,side_yellow);
  signal current_state : state_type;
  signal next_state : state_type;
  signal counter:integer range 0 to 15:=0;
  constant GREEN_TIME:integer :=6;
  constant YELLOW_TIME:integer :=3;
begin
  process (clock, reset)
  begin
    if reset = '1' then
      current_state <= main_green;
      counter<=0;
    elsif rising_edge(clock) then
    if counter=0 then
      current_state <= next_state;
      case next_state is
       when main_green =>counter<=GREEN_TIME;
       when main_yellow =>counter<=YELLOW_TIME;
       when side_green =>counter<=GREEN_TIME;
       when side_yellow =>counter<=YELLOW_TIME;
       end case;
       else
       counter<=counter -1;
    end if;
    end if;
  end process;

  process (current_state, side_sensor,counter)
  begin
    case current_state is
      when main_green => if (counter=0 and side_sensor ='1') then next_state<=main_yellow;
      else next_state <= main_green;
      end if;
       when main_yellow => if counter =0 then next_state<=side_green;
      else next_state <= main_yellow;
      end if;
      when side_green => if counter =0 then next_state<=side_yellow;
      else next_state <= side_green;
      end if;
      when side_yellow => if counter =0  then next_state<=main_green;
      else next_state <= side_yellow;
      end if; 
      end case;
  end process;
  process(current_state)
  begin
  M_red<='0';M_yellow<='0';M_green<='0';S_red<='0';S_yellow<='0';S_green<='0';
  case current_state is
  when main_green=>M_green<='1';S_red<='1';
    when main_yellow=>M_yellow<='1';S_red<='1';
      when side_green=>M_red<='1';S_green<='1';
        when side_yellow=>M_red<='1';S_yellow<='1';
        end case;
        end process;
end architecture;
