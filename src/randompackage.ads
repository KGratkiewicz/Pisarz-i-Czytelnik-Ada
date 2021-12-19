-- Simple pseudo-random number generator package.
-- Adapated from the Ada literature by
-- Michael B. Feldman, The George Washington University, November 1990.

with Calendar; use Calendar;

package RandomPackage is

  procedure SetSeed (N: positive);
  function  UnitRandom return float;
    -- returns a float >=0.0 and <1.0
  function  RandomInt (N: positive) return positive;
    --return a random integer in the range 1..N

end RandomPackage;
