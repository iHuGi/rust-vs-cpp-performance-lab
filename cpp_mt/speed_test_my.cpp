/**
 * C++ vs. Rust (Multi-threaded)
 * This programme evaluates the execution speed of C++ across multiple CPU cores
 * by performing exactly 100 billion bitwise operations in parallel.
 * It is designed to be compared directly against the equivalent Rust implementation.
 */
#include <iostream>
#include <chrono>
#include <cstdint>
#include <thread>
#include <vector>

// This is the worker function each thread will execute independently.
// It computes a local sum to prevent race conditions and locking overhead.
void worker(uint64_t start, uint64_t end, uint64_t& local_result) {
    // A thread-local variable is initialised to store the cumulative result for this specific chunk.
    uint64_t sum = 0;
    
    // The outer loop executes only a fraction of the total 1,000,000 iterations, based on core count.
    for (uint64_t i = start; i < end; ++i) {
        
        // The inner loop executes 100,000 times per outer iteration.
        for (uint64_t j = 0; j < 100000; ++j) {
            
            // The programme calculates the bitwise XOR (^) of the two loop counters.
            // Unsigned integers in C++ naturally wrap around upon overflow.
            sum += (i ^ j);
        }
    }
    
    // The final local sum is passed back via the reference parameter.
    // if you do not know what reference is check the & in the function parameter
    // and ask AI or Google it
    local_result = sum;
}

int main() {
    // The programme initialises a 64-bit unsigned integer to store the grand total.
    uint64_t total_val = 0;
    
    // It detects the number of available CPU cores to determine how many threads to spawn.
    // If detection fails, it falls back to 4 threads.
    unsigned int num_threads = std::thread::hardware_concurrency();
    if (num_threads == 0) num_threads = 4;

    std::cout << "C++ is working across " << num_threads << " threads..." << std::endl;

    // It captures the exact high-resolution system time immediately before the processing begins.
    auto start_time = std::chrono::high_resolution_clock::now();

    // Vectors are used to manage the thread objects and store the individual results from each thread.
    std::vector<std::thread> threads;
    std::vector<uint64_t> results(num_threads, 0);

    uint64_t total_iterations = 1000000;
    
    // The total workload is divided equally among the available threads.
    uint64_t chunk_size = total_iterations / num_threads;

    // The programme spawns the threads and assigns each a specific range of iterations to compute.
    for (unsigned int t = 0; t < num_threads; ++t) {
        uint64_t start = t * chunk_size;
        
        // It ensures the final thread picks up any leftover iterations if the division wasn't perfect.
        uint64_t end = (t == num_threads - 1) ? total_iterations : start + chunk_size;
        
        threads.emplace_back(worker, start, end, std::ref(results[t]));
    }

    // The main thread waits (blocks) until all worker threads have completely finished their execution.
    for (auto& th : threads) {
        th.join();
    }

    // It accumulates the local results from all the individual threads into the final grand total.
    for (uint64_t res : results) {
        total_val += res;
    }

    // It calculates the total execution duration by subtracting the start time 
    // from the current time, and casting the result to milliseconds and seconds.
    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();
    auto duration_seconds = std::chrono::duration_cast<std::chrono::seconds>(end_time - start_time).count();

    // The programme outputs the final elapsed time and the computed value to prevent
    // the compiler from optimising the loops away entirely.
    std::cout << "Finished in: " << duration_ms << "ms" << std::endl;
    std::cout << "Finished in: " << duration_seconds << "s" << std::endl; 
    std::cout << "Result: " << total_val << std::endl;

    return 0;
}