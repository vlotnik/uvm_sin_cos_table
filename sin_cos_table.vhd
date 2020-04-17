----------------------------------------------------------------------------------------------------------------------------------
-- Author : Vitaly Lotnik
-- Name : sin_cos_table
-- Created : 17/04/2020
-- v 0.0.0
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
-- libraries
----------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

----------------------------------------------------------------------------------------------------------------------------------
-- entity declaration
----------------------------------------------------------------------------------------------------------------------------------
entity sin_cos_table is
    port(
          iCLK                      : in std_logic
        ; iPHASE_V                  : in std_logic
        ; iPHASE                    : in unsigned(11 downto 0)
        ; oSINCOS_V                 : out std_logic
        ; oSIN                      : out signed(15 downto 0)
        ; oCOS                      : out signed(15 downto 0)
    );
end entity;

----------------------------------------------------------------------------------------------------------------------------------
-- architecture declaration
----------------------------------------------------------------------------------------------------------------------------------
architecture behavioral of sin_cos_table is
----------------------------------------------------------------------------------------------------------------------------------
-- types declaration
----------------------------------------------------------------------------------------------------------------------------------
    type
        t_table
            is array (0 to 4095) of signed(15 downto 0);

----------------------------------------------------------------------------------------------------------------------------------
-- function declaration
----------------------------------------------------------------------------------------------------------------------------------
    -- calculates and returns sin/cos table
    function f_get_table (sin : in boolean) return t_table is
        variable v_table : t_table;
        variable v_phase : real := 0.0;
        variable v_step : real := 1.0 / 1024.0;
        variable v_max_value : integer := 32767;
        variable v_result_real : real;
        variable v_result_int : integer;
    begin
        for a in 0 to 4095 loop
            if sin then
                v_result_real := round(real(v_max_value) * ieee.math_real.sin(v_phase * ieee.math_real.MATH_PI * 0.5));
            else
                v_result_real := round(real(v_max_value) * ieee.math_real.cos(v_phase * ieee.math_real.MATH_PI * 0.5));
            end if;
            v_result_int := integer(v_result_real);
            --REPORT INTEGER'IMAGE(v_result_int);
            v_table(a) := to_signed(v_result_int, 16);
            v_phase := v_phase + v_step;
        end loop;

        return v_table;
    end;

----------------------------------------------------------------------------------------------------------------------------------
-- constants declaration
----------------------------------------------------------------------------------------------------------------------------------
    subtype constants is std_logic;
        constant
              c_sintable
                : t_table := f_get_table(sin => true);
        constant
              c_costable
                : t_table := f_get_table(sin => false);

---------------------------------------------------------------------------------------------------------------------------------
-- signals declaration
---------------------------------------------------------------------------------------------------------------------------------
    -- input buffers
    subtype signals_ib is std_logic;
        signal
              ib_phase_v
                : std_logic := '0';
        signal
              ib_phase
                : unsigned(11 downto 0) := (others => '0');

    -- internal latch
    subtype signals_int is std_logic;
        signal
              int_v
                : std_logic := '0';
        signal
              int_phase
                : unsigned(11 downto 0) := (others => '0');

    -- output buffers
    subtype signals_ob is std_logic;
        signal
              ob_v
                : std_logic := '0';
        signal
              ob_sin
            , ob_cos
                : signed(15 downto 0) := (others => '0');

begin
----------------------------------------------------------------------------------------------------------------------------------
-- input
----------------------------------------------------------------------------------------------------------------------------------
    ib_phase_v                      <= iPHASE_V;
    ib_phase                        <= iPHASE;

----------------------------------------------------------------------------------------------------------------------------------
-- process, main
----------------------------------------------------------------------------------------------------------------------------------
    p_main : process(iCLK)
    begin
        if rising_edge(iCLK) then
            int_v <= ib_phase_v;
            if (ib_phase_v = '1') then
                int_phase <= ib_phase;
            end if; -- CE

            ob_v <= int_v;
            if (int_v = '1') then
                -- get cosine/sine from table
                ob_sin <= c_sintable(to_integer(int_phase));
                ob_cos <= c_costable(to_integer(int_phase));
            end if; -- CE
        end if; -- CLK
    end process;

----------------------------------------------------------------------------------------------------------------------------------
-- output
----------------------------------------------------------------------------------------------------------------------------------
    oSINCOS_V                       <= ob_v;
    oSIN                            <= ob_sin;
    oCOS                            <= ob_cos;

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
end;