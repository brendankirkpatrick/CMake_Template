#include <catch2/catch_test_macros.hpp>

#include "example.h"

TEST_CASE("Factorials are computed", "[factorial]")
{
  SECTION("Test positive numbers")
  {
    REQUIRE(Factorial(1) == 1);
    REQUIRE(Factorial(2) == 2);
    REQUIRE(Factorial(3) == 6);
    REQUIRE(Factorial(10) == 3628800);
  }
  SECTION("Test negative numbers")
  {
    REQUIRE(Factorial(-1) == -1);
    REQUIRE(Factorial(-327) == -327);
  }
}

TEST_CASE("Square computed correctly", "[square]") 
{
  SECTION("Test positive numbers")
  {
    REQUIRE(Square(5) == 25);
    REQUIRE(Square(1234) == 1'522'756);
  }
  SECTION("Test negative numbers")
  {
    REQUIRE(Square(-5) == 25);
    REQUIRE(Square(-327) == 106'929);
  }
}
