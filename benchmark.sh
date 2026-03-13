#!/bin/bash

# Usage instructions:
# 1. Grant execution permissions: chmod +x benchmark.sh
# 2. Run the script: ./benchmark.sh

# --- 1. PATH CONFIGURATION ---
# The script defines relative paths for the source files within the repository.
CPP_FILE="./cpp/speed_test.cpp"
RUST_FILE="./rust/speed_test.rs"

echo "🚀 Starting Performance Lab: Preparing binaries..."

# --- 2. HIGH-PERFORMANCE COMPILATION ---
# The system invokes the GNU C++ compiler with level 3 optimization (-O3).
g++ -O3 $CPP_FILE -o ./cpp/speed_test_cpp

# The system utilizes the native Rust compiler (rustc) with maximum optimization (opt-level 3).
# This approach compiles the standalone source file without requiring a full Cargo project.
rustc -C opt-level=3 $RUST_FILE -o ./rust/speed_test_rust

echo "-------------------------------------------"
echo "Starting Automated Benchmark (5 rounds)"
echo "Workload: 100 Billion Operations"
echo "-------------------------------------------"

# --- 3. ACCUMULATOR INITIALIZATION ---
# Numeric variables initialized to store the cumulative execution times for final averaging.
cpp_total=0
rust_total=0

# --- 4. EXECUTION AND DATA CAPTURE ---
# The loop executes 5 iterations to mitigate CPU thermal throttling or background noise.
for i in {1..5}
do
    echo "Round $i of 5..."
    
    # C++ Execution and Output Parsing:
    # The script filters the output for the timing line, isolates the numeric value,
    # and strips the 'ms' suffix to allow for mathematical operations in Bash.
    cpp_ms=$(./cpp/speed_test_cpp | grep "ms" | head -n 1 | awk '{print $3}' | sed 's/ms//')
    cpp_total=$((cpp_total + cpp_ms))
    
    # Rust Execution and Output Parsing:
    # Identical parsing logic applied to the Rust executable for consistent measurement.
    rust_ms=$(./rust/speed_test_rust | grep "ms" | head -n 1 | awk '{print $3}' | sed 's/ms//')
    rust_total=$((rust_total + rust_ms))
    
    echo "  C++: ${cpp_ms}ms | Rust: ${rust_ms}ms"
done

# --- 5. FINAL RESULTS AND VERDICT ---
# The system calculates the arithmetic mean by dividing the total sum by the number of rounds.
cpp_avg=$((cpp_total / 5))
rust_avg=$((rust_total / 5))

echo "-------------------------------------------"
echo "FINAL RESULTS (AVERAGE)"
echo "-------------------------------------------"
echo "C++ Average: ${cpp_avg}ms"
echo "Rust Average: ${rust_avg}ms"

# Logic to determine the winner based on the lowest execution time.
if [ $rust_avg -lt $cpp_avg ]; then
    echo "RUST Wins!"
else
    echo "C++ Wins!"
fi