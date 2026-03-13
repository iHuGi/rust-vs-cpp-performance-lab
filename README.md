# Performance Benchmark: Rust vs. C++

## 1. Overview

This project implements a controlled testing environment to evaluate the computational efficiency of **Rust (v1.94+)** and **C++ (GCC 13.3+)** in intensive processing scenarios. The analysis focuses on the optimization capabilities of the **LLVM** and **GCC** compilers when subjected to a workload of $10^{11}$ (100 billion) binary operations.

## 2. Test Methodology

The benchmark utilizes a stress test algorithm consisting of nested loops that perform bitwise XOR operations and wrapping additions.

* **Workload:** 1,000,000 external iterations $\times$ 100,000 internal iterations.
* **Data Types:** 64-bit unsigned integers (`u64` / `uint64_t`).
* **Variable Control:** Execution is automated over 5 consecutive rounds to calculate the arithmetic mean and mitigate the impact of thermal throttling or OS scheduler noise.

## 3. Environment Configuration

* **C++ Compiler:** g++ 13.3.0 utilizing the `-O3` optimization flag.
* **Rust Compiler:** rustc 1.94.0 utilizing the `-C opt-level=3` optimization flag.
* **Operating System:** Ubuntu 24.04 LTS (WSL2).
* **Orchestration:** Bash script for automated compilation, execution, and log parsing.

## 4. Empirical Results

The reported times represent the average of 5 independent executions.

| Language | Compiler Version | Average (ms) | Average (s) |
| --- | --- | --- | --- |
| **Rust** | **rustc 1.94.0** | **15,402** | **~15.4s** |
| **C++** | **g++ 13.3.0** | **16,896** | **~16.9s** |

**Technical Note:** The observed performance advantage in Rust is attributed to the efficiency of the LLVM backend in register allocation and the application of aggressive loop unrolling strategies for this specific instruction set.

## 5. Reproduction Instructions

### Prerequisites

* G++ (Build-essential)
* Rustc (Rust toolchain)
* Linux/WSL Environment

### Execution

1. Assign execution permissions to the orchestrator:

```bash
chmod +x benchmark.sh

```

2. Run the test suite:

```bash
./benchmark.sh

```

## 6. Repository Structure

* `/cpp/speed_test.cpp`: C++ implementation.
* `/rust/main.rs`: Rust implementation.
* `benchmark.sh`: Automation and statistical analysis script.