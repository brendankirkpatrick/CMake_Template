# CMake_Template
This project is a simple CMake template that features:

- compiler warnings (optionally treated as errors)
- sanitization options (address, memory, etc...)
- clang-tidy static analysis
- basic unit testing with [Catch2](https://github.com/catchorg/Catch2)
- Valgrind integration (when sanitization disabled)
