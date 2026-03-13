/**
 * C++ vs. Rust
 * This programme evaluates the execution speed of C++ by performing exactly one billion bitwise operations.
 * It is designed to be compared directly against the equivalent Rust implementation.
 */
#include <iostream>
#include <chrono>
#include <cstdint>

int main() {
    // The programme initialises a 64-bit unsigned integer to store the cumulative result.
    // This perfectly matches the 'u64' type used in the Rust implementation.
    uint64_t val = 0;

    // It captures the exact high-resolution system time immediately before the processing begins.
    auto start_time = std::chrono::high_resolution_clock::now();

    std::cout << "C++ is working... executing raw machine code..." << std::endl;

    // The outer loop executes 100,000 times.
    for (uint64_t i = 0; i < 1000000; ++i) {
        
        // The inner loop executes 10,000 times per outer iteration.
        // This results in a total of 1,000,000,000 (one billion) calculations.
        for (uint64_t j = 0; j < 100000; ++j) {
            
            // The programme calculates the bitwise XOR (^) of the two loop counters.
            // It adds the result to the running total. Unsigned integers in C++ 
            // naturally wrap around upon overflow, simulating Rust's wrapping_add logic.
            val += (i ^ j);
        }
    }

    // It calculates the total execution duration by subtracting the start time 
    // from the current time, and casting the result to milliseconds.
    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();
    auto duration_seconds = std::chrono::duration_cast<std::chrono::seconds>(end_time - start_time).count();

    // The programme outputs the final elapsed time and the computed value to prevent
    // the GCC/Clang compiler from optimising the loop away entirely.
    std::cout << "Finished in: " << duration_ms << "ms" << std::endl;
    std::cout << "Finished in: " << duration_seconds << "s" << std::endl; 
    std::cout << "Result: " << val << std::endl;

    return 0;
}