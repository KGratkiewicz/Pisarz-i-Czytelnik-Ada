
-- Simple pseudo-random number generator package.
-- Adapated from the Ada literature by
-- Michael B. Feldman, The George Washington University, November 1990.

package body RandomPackage is

  modulus: constant:=9317;
  type int_16 is range - 2 ** 15 .. 2 ** 15 - 1;
  type int_32 is range - 2 ** 31 .. 2 ** 31 - 1;
  subtype seed_range is int_16 range 0 .. (modulus - 1);
  seed, default_seed : seed_range;

  procedure SetSeed(N: positive) is
  begin
    seed:=seed_range(N);
  end SetSeed;

  function UnitRandom return float is
    multiplier: constant:=421;
    increment: constant:=2073;
    result: float;
  begin
    seed:=(multiplier*seed+increment) mod modulus;
    result:=float(seed)/float(modulus);
    return result;
  exception
    when Constraint_Error|Numeric_Error =>
      seed:=int_16((multiplier*int_32(seed)+increment) mod modulus);
      result:=float(seed)/float(modulus);
      return result;
  end UnitRandom;

  function RandomInt(N: positive) return positive is
    result: integer range 1..N;
  begin
    result:=integer(float(N)*UnitRandom+0.5);
    return result;
  exception
    when Constraint_Error|Numeric_Error => return 1;
  end RandomInt;

begin
  default_seed:=int_16(int_32(seconds(clock)) mod modulus);
  seed:=default_seed;
end RandomPackage;
