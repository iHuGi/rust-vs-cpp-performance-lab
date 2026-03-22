# Performance Benchmark: Rust vs. C++

## 1. Overview

This project implements a controlled testing environment to evaluate the computational efficiency of **Rust (v1.94+)** and **C++ (GCC 13.3+)** in intensive processing scenarios. The analysis focuses on the optimisation capabilities of the **LLVM** and **GCC** compilers across both single-core and multi-core workloads, processing 100 billion binary operations.

## 2. Test Methodology

The benchmark utilises a stress test algorithm consisting of nested loops that perform bitwise XOR operations and wrapping additions. We test this workload under two conditions:
* **Single-Threaded:** Evaluates raw single-core execution speed.
* **Multi-Threaded:** Evaluates parallel processing efficiency and thread management across available CPU cores.

**Workload Parameters:**
* **Total Operations:** 1,000,000 external iterations x 100,000 internal iterations.
* **Data Types:** 64-bit unsigned integers (`u64` / `uint64_t`).
* **Variable Control:** Execution is automated over 5 consecutive rounds to calculate the arithmetic mean and mitigate the impact of thermal throttling or OS scheduler noise.

## 3. Environment Configuration

* **C++ Compiler:** g++ 13.3.0 utilising the `-O3` optimisation flag (and `-pthread` for multi-threaded tests).
* **Rust Compiler:** rustc 1.94.0 utilising the `-C opt-level=3` optimisation flag.
* **Operating System:** Ubuntu 24.04 LTS (WSL2).
* **Orchestration:** Bash scripts for automated compilation, execution, and log parsing.

## 4. Empirical Results

The reported times represent the average of 5 independent executions on the test hardware. 

### 4.1. Single-Threaded Results

| Language | Compiler Version | Average (ms) | Average (s) |
| --- | --- | --- | --- |
| **Rust** | **rustc 1.94.0** | **20,694** | **~20.7s** |
| **C++** | **g++ 13.3.0** | **24,296** | **~24.3s** |

**Technical Note:** The observed single-threaded performance advantage in Rust is attributed to the efficiency of the LLVM backend in register allocation and the application of aggressive loop unrolling strategies for this specific instruction set.

### 4.2. Multi-Threaded Results

| Language | Threads Utilised | Average (ms) | Average (s) |
| --- | --- | --- | --- |
| **Rust MT** | **Auto-detected**| **6,199** | **~6.2s** |
| **C++ MT** | **Auto-detected**| **8,021** | **~8.0s** |

**Technical Note:** Multi-threading yielded a ~3x performance increase for both languages. Rust maintained its lead in parallel execution, showcasing highly efficient thread spawning and memory safety guarantees without introducing runtime overhead.

## 5. Reproduction Instructions

### Prerequisites

* G++ (Build-essential)
* Rustc (Rust toolchain)
* Linux/WSL Environment

### Execution

1. Assign execution permissions to the orchestrators:

```bash
chmod +x benchmark.sh
chmod +x benchmark_mt.sh
```

2. Run the standard single-threaded test suite:

```bash
./benchmark.sh
```

3. Run the multi-threaded test suite:

```bash
./benchmark_mt.sh
```

## 6. Repository Structure

* `/cpp/speed_test.cpp`: C++ single-threaded implementation.
* `/cpp_mt/speed_test_my.cpp`: C++ multi-threaded implementation.
* `/rust/speed_test.rs`: Rust single-threaded implementation.
* `/rust_mt/speed_test_mt.rs`: Rust multi-threaded implementation.
* `benchmark.sh`: Automation script for single-threaded tests.
* `benchmark_mt.sh`: Automation script for multi-threaded tests.
```