#include "example.h"

unsigned int Factorial(int number)
{
    return number <= 1 ? number : Factorial(number - 1) * number;
}

unsigned int Square(int number)
{
    return number * number;
}
