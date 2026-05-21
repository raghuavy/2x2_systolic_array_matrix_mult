# 2x2 Systolic Array Matrix Multiplier

A 2×2 matrix multiplier implemented as an output-stationary systolic array in SystemVerilog, taken through the full RTL-to-GDSII flow on the SkyWater 130nm PDK via OpenLane. Each processing element (PE) owns a MAC unit and an accumulator, with operands rippling through the array one hop per cycle via inter-PE registers.

## Architecture

Four PEs arranged in a 2×2 grid. Each PE registers its `a` and `b` inputs, multiplies and accumulates into a local `acc` register, and forwards the operands to its right (`a_out`) and bottom (`b_out`) neighbors on the next cycle.

```
        b_col_0      b_col_1
           |            |
           v            v
a_row_0 -> PE00 ------> PE01
           |            |
           v            v
a_row_1 -> PE10 ------> PE11
```

`a` operands walk left-to-right, `b` operands walk top-to-bottom. Outputs `c00`, `c01`, `c10`, `c11` are the stationary accumulators inside each PE.

## Input Skew

Because operands take one cycle per hop, inputs are fed with a triangular skew so each PE sees the correct `(a, b)` pair on the same cycle:

| cycle | a_row_0 | a_row_1 | b_col_0 | b_col_1 |
|-------|---------|---------|---------|---------|
| 1     | A[0][0] | 0       | B[0][0] | 0       |
| 2     | A[0][1] | A[1][0] | B[1][0] | B[0][1] |
| 3     | 0       | A[1][1] | 0       | B[1][1] |

Total latency is 5 cycles before all four accumulators hold the final result.

## Physical Implementation

Synthesized and placed-and-routed through OpenLane on SKY130 (sky130_fd_sc_hd standard cell library).

- ~388 × 378 µm die
- 50 MHz target clock, timing closed at typical corner (no setup or hold violations)
- DRC clean after detailed routing and GDS streamout (Magic + KLayout XOR match)
- Flow: Yosys synth → OpenROAD floorplan/place/CTS/route → Magic + KLayout signoff

## Files

- `pe_block.sv` — single PE with MAC and operand-forwarding registers
- `mat_mul.sv` — 2×2 top-level instantiating four PEs with local wiring
- `tb_mat_mul.sv` — testbench feeding skewed input streams for four test cases
- `config.json` — OpenLane flow configuration

## Elaborated Designs

<img width="968" height="416" alt="elaborated design 1" src="https://github.com/user-attachments/assets/87ec07ac-615a-4add-924b-c8b444a7cb0d" />
<img width="961" height="424" alt="elaborated design 2" src="https://github.com/user-attachments/assets/109708e2-dc52-416a-ba51-d12182282b84" />

## Synthesized Netlist

<img width="775" height="391" alt="synthesized netlist" src="https://github.com/user-attachments/assets/b3fceb4e-5eb5-4bd0-8710-04ddf09f9749" />

## Waveform

<img width="928" height="477" alt="simulation waveform" src="https://github.com/user-attachments/assets/013640bc-b205-4c27-ab0e-d20ecbb429e4" />

## Chip GDS in KLayout

<img width="866" height="631" alt="GDS layout in KLayout" src="https://github.com/user-attachments/assets/2a635a49-4381-49a3-aafe-a09f17f61349" />
