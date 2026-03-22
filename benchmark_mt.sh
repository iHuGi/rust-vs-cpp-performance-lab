#!/bin/bash

# Usage instructions:
# 1. Grant execution permissions: chmod +x benchmark_mt.sh
# 2. Run the script: ./benchmark_mt.sh

# --- 1. PATH CONFIGURATION ---
# The script defines relative paths for the multi-threaded source files.
CPP_FILE="./cpp_mt/speed_test_my.cpp"
RUST_FILE="./rust_mt/speed_test_mt.rs"

echo "🚀 Starting Multi-Threaded Performance Lab: Preparing binaries..."

# --- 2. HIGH-PERFORMANCE COMPILATION ---
# The system invokes the GNU C++ compiler with level 3 optimisation (-O3).
# CRITICAL: -pthread is required for std::thread to compile correctly on Linux.
g++ -O3 -pthread $CPP_FILE -o ./cpp_mt/speed_test_cpp_mt

# The system utilises the native Rust compiler (rustc) with maximum optimisation (opt-level 3).
rustc -C opt-level=3 $RUST_FILE -o ./rust_mt/speed_test_rust_mt

echo "-------------------------------------------"
echo "Starting Automated MT Benchmark (5 rounds)"
echo "Workload: 100 Billion Operations (Parallel)"
echo "-------------------------------------------"

# --- 3. ACCUMULATOR INITIALISATION ---
cpp_total=0
rust_total=0

# --- 4. EXECUTION AND DATA CAPTURE ---
# The loop executes 5 iterations to mitigate CPU thermal throttling or background noise.
for i in {1..5}
do
    echo "Round $i of 5..."
    
    # C++ Execution and Output Parsing:
    cpp_ms=$(./cpp_mt/speed_test_cpp_mt | grep "ms" | head -n 1 | awk '{print $3}' | sed 's/ms//')
    cpp_total=$((cpp_total + cpp_ms))
    
    # Rust Execution and Output Parsing:
    rust_ms=$(./rust_mt/speed_test_rust_mt | grep "ms" | head -n 1 | awk '{print $3}' | sed 's/ms//')
    rust_total=$((rust_total + rust_ms))
    
    echo "  C++ MT: ${cpp_ms}ms | Rust MT: ${rust_ms}ms"
done

# --- 5. FINAL RESULTS AND VERDICT ---
cpp_avg=$((cpp_total / 5))
rust_avg=$((rust_total / 5))

echo "-------------------------------------------"
echo "FINAL RESULTS (AVERAGE)"
echo "-------------------------------------------"
echo "C++ Multi-Threaded Average: ${cpp_avg}ms"
echo "Rust Multi-Threaded Average: ${rust_avg}ms"

# Logic to determine the winner based on the lowest execution time.
if [ $rust_avg -lt $cpp_avg ]; then
    echo "🏆 RUST MT Wins!"
else
    echo "🏆 C++ MT Wins!"
fi