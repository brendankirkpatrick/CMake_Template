#include "example.h"

int Factorial(int number)
{
    return number <= 1 ? number : Factorial(number - 1) * number;
}

int Square(int number)
{
    return number * number;
}
