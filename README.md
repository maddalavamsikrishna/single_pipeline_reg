# single_pipeline_reg

## 📌 Project Overview
This repository contains a synthesizable Single-Stage Pipeline Register implemented in SystemVerilog. The design utilizes a standard Valid/Ready handshake protocol to manage data flow and backpressure, ensuring zero data loss or duplication in high-throughput environments.

### Design:
This is a synthesizable RTL implementation of a single-stage pipeline register that uses registered outputs to break critical timing paths. Helps for easier Static Timing Analysis (STA) in high-frequency designs.

### Testbench:
The SystemVerilog testbench was developed using clocking blocks with specified input/output skews to eliminate simulation race conditions and mimic real-world hardware setup/hold timing.

### RTL Schematics:
This is the RTL Schematics of the design obtained from the xilinx vivado tool (2023.1 version). 

![RTL Schematics](https://raw.githubusercontent.com/maddalavamsikrishna/single_pipeline_reg/main/results/rtl_schematics.png)
### Post Implementation Schematics:
This is the Post-Implementation Schematics of the design obtained from the xilinx vivado tool (2023.1 version). 

![Post-Implementation Schematics](https://github.com/maddalavamsikrishna/single_pipeline_reg/blob/main/results/Post_implementation_schematics.png)

## 📈 Simulation Results

### 1. Functional Waveform
The waveform below confirms the cycle-accurate behavior of the handshake protocol. It demonstrates that data is sampled on the rising edge only when the "handshake" (`in_valid` && `in_ready`) is active. The output appears exactly one clock cycle later, proving a perfect single-stage pipeline latency.

![Functional Waveform](https://raw.githubusercontent.com/maddalavamsikrishna/single_pipeline_reg/main/results/waveform.png)

### 2. Simulation Log & Transaction Trace
The simulation log provides a transparent audit trail of every data transaction. The trace shows the exact hex values entering and exiting the module with nanosecond precision. This log confirms that even under heavy backpressure (Scenario 2), the data is held stable and correctly released without any loss or duplication.

![Simulation Log](https://raw.githubusercontent.com/maddalavamsikrishna/single_pipeline_reg/main/results/Log.png)

## 📁 Repository Structure
* `rtl/pipeline_register.sv`: Synthesizable RTL code.
* `dv/pipeline_register_tb.sv`: SystemVerilog Testbench with clocking block.
* `results/`: Waveform screenshots and simulation logs.

---
