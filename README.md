# Fault Detection Analysis in Simulated Detector Readout Electronics

## Overview

This project investigates fault detection in a simulated 16-bit digital readout system by comparing parity checking and CRC-8 (Cyclic Redundancy Check).

A Python-based fault-injection experiment evaluates all 65,535 nonzero bit-flip masks for a fixed 16-bit data word. Verilog/SystemVerilog is used to model the digital readout and its fault-detection logic.

## Objectives

- Model a 16-bit digital readout system.
- Inject bit-flip faults using fault masks.
- Compare parity and CRC-8 error detection.
- Measure detected and undetected fault patterns.
- Analyze the strengths and limitations of both methods.

## Tools Used

- Verilog/SystemVerilog
- EDA Playground
- Python
- Google Colab
- Matplotlib

## Methodology

1. Select a 16-bit reference data word.
2. Calculate its reference parity and CRC-8.
3. Inject bit-flip faults using XOR masks.
4. Check the received data using parity and CRC-8.
5. Count detected and undetected fault masks.
6. Compare the detection rates.

## Experimental Results

| Metric | Parity | CRC-8 |
|---|---:|---:|
| Fault masks tested | 65,535 | 65,535 |
| Detected | 32,768 | 65,280 |
| Undetected | 32,767 | 255 |
| Detection rate | 50.001% | 99.611% |

These are preliminary results from a Python experiment using the fixed data word `0xA53C`. The reference check values are assumed to remain intact.

## Repository Structure

- `rtl/` — Verilog design
- `testbench/` — HDL testbench
- `python/` — Python fault-injection implementation
- `results/` — Graphs and result tables
- `report.pdf` — Project report

## Limitations

The experiment uses a fixed data word and models data-bit flips. It does not represent every possible hardware fault. The Verilog implementation must be cross-validated against the Python implementation before claiming full implementation equivalence.

## Future Work

- Test multiple reference data words.
- Analyze burst-error patterns.
- Investigate undetected faults.
- Validate the HDL and Python implementations against the same test cases.
- Explore additional CRC polynomials.

## Conclusion

The preliminary experiment shows that CRC-8 detects more of the tested bit-flip fault masks than parity checking. The project provides a simulation-based study of digital data integrity and fault analysis.

## Author

**Name:** Akshya P B

**Department:** ECE 

**Institution:** Rajalakshmi Institute of Technology
