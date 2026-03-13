/**
 * Rust vs. C++ Performance Benchmark
 * This program evaluates Rust's execution speed by performing 100 billion bitwise operations.
 * The output is formatted for direct comparison with C++ timing results.
 */

fn main() {
    // A 64-bit unsigned integer (u64) is used for the result.
    // The 'mut' keyword allows the variable to be updated within the loop.
    let mut val: u64 = 0;

    println!("Rust is working... processing 100 billion operations...");

    // Capture the exact timestamp before processing begins.
    let now = std::time::Instant::now();

    // Outer loop: 1,000,000 iterations.
    for i in 0..1_000_000 {
        // Inner loop: 100,000 iterations.
        // Total operations: 1,000,000 * 100,000 = 100,000,000,000 (100 Billion).
        for j in 0..100_000 {
            // XOR operation (^) and wrapping addition to prevent overflow crashes.
            // This simulates standard C++ integer overflow behavior.
            val = val.wrapping_add(i ^ j);
        }
    }

    // Calculate elapsed time.
    let elapsed = now.elapsed();

    // Output formatting standardized for benchmark comparison.
    println!("Finished in: {}ms", elapsed.as_millis());
    println!("Finished in: {}s", elapsed.as_secs());
    println!("Result: {}", val);
}