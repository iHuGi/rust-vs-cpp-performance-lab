/**
 * Rust vs. C++ Performance Benchmark (Multi-threaded)
 * This programme evaluates the execution speed of Rust across multiple CPU cores
 * by performing exactly 100 billion bitwise operations in parallel.
 * It is designed to be compared directly against the equivalent C++ implementation.
 */
use std::thread;
use std::time::Instant;

fn main() {
    // The programme detects the number of available CPU cores natively.
    // If it fails to detect the core count for any reason, it safely falls back to 4 threads.
    let num_threads = thread::available_parallelism().map(|n| n.get()).unwrap_or(4);
    println!("Rust is working across {} threads...", num_threads);

    // It captures the exact system time immediately before the processing begins.
    let now = Instant::now();
    
    // The total external iterations are defined as a 64-bit unsigned integer.
    let total_iterations: u64 = 1_000_000;
    
    // The total workload is divided equally among the available CPU threads.
    let chunk_size = total_iterations / num_threads as u64;

    // A mutable vector is initialised to hold the "JoinHandles".
    // These handles are like receipts; we use them later to collect the results from each thread.
    let mut handles = vec![];

    // The programme loops through the number of threads to spawn them one by one.
    for t in 0..num_threads as u64 {
        // Calculate the starting iteration for this specific thread.
        let start = t * chunk_size;
        
        // Ensure the very last thread picks up any remaining iterations if the division wasn't perfectly even.
        let end = if t == (num_threads as u64 - 1) { total_iterations } else { start + chunk_size };

        // thread::spawn creates a new independent worker.
        // The 'move' keyword is crucial here: it forces the thread to take full ownership
        // of the 'start' and 'end' variables so they aren't accidentally dropped from memory.
        let handle = thread::spawn(move || {
            // A local, mutable variable is initialised to store the cumulative result for this chunk.
            let mut local_val: u64 = 0;
            
            // The outer loop executes only this thread's designated fraction of the total workload.
            for i in start..end {
                // The inner loop executes 100,000 times per outer iteration.
                for j in 0..100_000 {
                    // It calculates the bitwise XOR (^) of the two loop counters.
                    // 'wrapping_add' is explicitly used to simulate C++'s natural integer overflow,
                    // preventing Rust from panicking (crashing) when the number gets too large.
                    local_val = local_val.wrapping_add(i ^ j);
                }
            }
            // By leaving off the semicolon here, the thread implicitly returns the final local_val.
            local_val 
        });
        
        // We push the receipt (handle) for this thread into our vector so we don't lose track of it.
        handles.push(handle);
    }

    // A mutable variable is initialised to store the grand total.
    let mut total_val: u64 = 0;
    
    // The main thread loops through all the saved receipts (handles).
    for handle in handles {
        // .join() forces the main programme to wait until the specific thread is finished.
        // .unwrap() extracts the 'local_val' that the thread returned.
        // We safely add that extracted value to the grand total.
        total_val = total_val.wrapping_add(handle.join().unwrap());
    }

    // It calculates the total execution duration by measuring the elapsed time since 'now'.
    let elapsed = now.elapsed();

    // The programme outputs the final elapsed time and the computed value to prevent
    // the LLVM compiler from optimising the loops away entirely.
    println!("Finished in: {}ms", elapsed.as_millis());
    println!("Finished in: {}s", elapsed.as_secs());
    println!("Result: {}", total_val);
}