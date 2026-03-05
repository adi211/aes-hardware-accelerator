# ⚡ AES Hardware Accelerator
### RTL Design · Verification · Synthesis · Gate-Level Validation

> **Full VLSI front-end flow** for AES-128 SubBytes + MixColumns — from RTL to gate-level netlist at **416 MHz** on a 90nm process node.

**Ben-Gurion University of the Negev** | Digital Design and Logic Synthesis (361-1-3611) | January 2026  
*Adi Shlomo · Shahar Halevy*

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Verification Environment](#verification-environment)
- [Verification Results](#verification-results)
- [Synthesis & Physical Results](#synthesis--physical-results)
- [Gate-Level Simulation](#gate-level-simulation)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)

---

## Overview

This project implements a complete **VLSI front-end flow** for AES-128 transformation modules, covering:

| Phase | Description |
|---|---|
| 🏗️ **RTL Design** | Modular SystemVerilog implementation of SubBytes (S-Box) + MixColumns |
| 🔬 **Verification** | Layered SV environment: BFM · Scoreboard · Assertions · Functional Coverage |
| ⚙️ **Synthesis** | Timing-driven synthesis to 2.4 ns (416 MHz) via Synopsys Design Compiler |
| 🔁 **GLS** | Post-synthesis Gate-Level Simulation with SDF back-annotation |
| 🔋 **Power Study** | A/B comparison: NOGATE vs. GATE (Integrated Clock Gating) |

### Key Results at a Glance

```
┌─────────────────────────────────────────────────────────┐
│  Operating Frequency : 416 MHz  (2.4 ns, zero slack)    │
│  Dynamic Power Saved : 79.4%   (via clock gating)       │
│  Functional Coverage : 100%                             │
│  SVA Pass Rate       : 100%  (9/9 assertions)           │
│  GLS Verification    : PASS  (txns=559, fail=0)         │
└─────────────────────────────────────────────────────────┘
```

---

## Architecture

### FSM-Controlled Datapath

The system operates under a strict **Start/Busy/Done handshake** managed by a 4-state synchronous Moore FSM:

```
        ┌─────────┐
  rst ──►  RESET  │
        └────┬────┘
             │ next clk
        ┌────▼────┐  start=0
        │  IDLE   │◄──────────────┐
        └────┬────┘               │
        start=1 │                 │
        ┌────▼────────┐           │
        │  SB         │  busy=1   │
        │  (SubBytes) │  en_sb    │
        └────┬────────┘           │
             │ next clk           │
        ┌────▼────────────────┐   │
        │  MC                 │   │
        │  (MixColumns)       ├───┘
        │  sb_valid=1, busy=1 │  done pulse → back to IDLE
        └─────────────────────┘
```

| State | Code | Description |
|---|---|---|
| **RESET** | `00` | System initialization |
| **IDLE** | `01` | Waits for `start`; latches `data_in` into Input Register |
| **SB** | `10` | SubBytes substitution active (`en_sb`) |
| **MC** | `11` | MixColumns active (`en_mc`); `sb_valid` asserted (1-cycle pulse) |

### Top-Level Ports

```
         ┌──────────────────────────────┐
  clk ──►│                              ├──► done
  rst ──►│                              ├──► busy
start ──►│           Top                ├──► sb_valid
         │                              ├──► fsm_state [1:0]
 data_in ►│ [127:0]               [127:0]├──► data_out
         │                        [127:0]├──► sb_out
         └──────────────────────────────┘
```

### RTL Source Files

| File | Description |
|---|---|
| `Top.sv` | Top-level module; input latching; exposes `sb_out` for verification |
| `ControlFsm.sv` | Synchronous FSM — Start/Busy/Done handshake |
| `MixColumns.sv` | AES MixColumns GF(2⁸) matrix transformation |
| `subBytes.v` | S-Box substitution wrapper |
| `sbox.v` | AES substitution look-up table (256 entries) |
| `Register.sv` | Generic synchronous register (pipelining / latching) |
| `constants.vh` | Global parameters & FSM state encodings |

---

## Verification Environment

A **layered, self-checking** environment built in SystemVerilog — no traditional directed-only testbench:

```
 ┌──────────────────────────────────────────────────────────┐
 │                  Verification Environment                │
 │                                                          │
 │  ┌─────────────┐         ┌────────────────────────────┐  │
 │  │   Stimuli   │─txns───►│     AES_BFM (Driver +      │  │
 │  │  Generator  │         │        Monitor)            │  │
 │  │             │         └──────────┬─────────────────┘  │
 │  │ • 3 directed│                    │ drive / sample      │
 │  │ • 256 sweep │    ┌───────────────▼──────────┐          │
 │  │ • 300 random│    │     RTL / DUT (Top.sv)   │          │
 │  └──────┬──────┘    │     via dut_if.sv        │          │
 │         │           └──────────────────────────┘          │
 │    calc expected                                          │
 │  ┌──────▼───────────┐   observed events                   │
 │  │  Golden Ref Model│──────────────────────────────►      │
 │  │  (SubBytes+MC)   │         ┌────────────────────┐      │
 │  └──────────────────┘         │  Scoreboard        │      │
 │                               │  • sb_out @ sb_valid│     │
 │   ┌────────────────────────┐  │  • data_out @ done │      │
 │   │ Assertions (SVA)       │  └────────────────────┘      │
 │   │ Functional Coverage    │                              │
 │   └────────────────────────┘                              │
 └──────────────────────────────────────────────────────────┘
```

### Stimulus Strategy (559 transactions)

| Category | Count | Purpose |
|---|---|---|
| Directed edge-cases | 3 | All-zeros, all-ones, reset behavior |
| Deterministic S-Box sweep | 256 | Full `0x00–0xFF` sweep on all 16 byte-lanes |
| Constrained-random | 300 | Back-to-back and delayed scenarios; stress control logic |

### Testbench Files (`TB/`)

| File | Role |
|---|---|
| `tb_top.sv` | Top-level testbench — connects DUT, interface, classes |
| `dut_if.sv` | Interface + clocking blocks |
| `aes_bfm.sv` | BFM driver/monitor — abstracts handshake protocol |
| `aes_ref_model.sv` | Golden behavioral reference model |
| `scoreboard.sv` | Self-checking scoreboard (intermediate + final checks) |
| `stimuli.sv` | Directed + constrained-random transaction generator |
| `tb_assertions.sv` | SVA protocol & timing checks |
| `tb_cov.sv` | Functional coverage model |
| `tb_types_pkg.sv` | Shared types & transaction definitions |

---

## Verification Results

### Simulation Summary

```
# TB COMPLETE | txns=559 pass=1118 fail=0
```

The `pass=1118` count reflects **two independent checks per transaction**:
1. **Intermediate check** — `sb_out` compared on `sb_valid`
2. **Final check** — `data_out` compared on `done`

### Coverage & Assertions

| Metric | Result |
|---|---|
| Functional Coverage | ✅ **100%** (25/25 bins) |
| SVA Assertion Pass Rate | ✅ **100%** (9/9 checkers, 0 failures) |
| Statement Coverage | ✅ **100%** |
| Toggle Coverage | ✅ **100%** |
| Expression Coverage | ✅ **100%** |
| Branch Coverage | ✅ **99.61%** (16 missed = unreachable S-Box defaults) |
| **Overall Code Coverage** | ✅ **99.90%** |

> The 0.10% branch gap corresponds to the `default` clause in the 16 S-Box instances, which is logically unreachable (8-bit input covers the full 0–255 space). This is a verified, justified exclusion.

### Functional Coverage Bins

| Coverpoint | Bins | Status |
|---|---|---|
| `cp_state` — FSM states | 5 (RESET/IDLE/SB/MC + full flow) | ✅ Covered |
| `cp_input_bucket` — data diversity | 16 | ✅ Covered |
| `cp_reset_while_busy` | 1 | ✅ Covered |
| `cp_start_in_idle` | 1 | ✅ Covered |
| `cp_sbvalid_in_mc` | 1 | ✅ Covered |
| `cp_done_in_idle` | 1 | ✅ Covered |

### SVA Checks

All 9 assertions passed with **0 failures**:
- **Handshake sequencing** — `busy` asserts exactly 1 cycle after `start`; `done` never asserts while `busy` is low
- **Pulse-width integrity** — `sb_valid` and `done` are strictly single-cycle pulses
- **X/Z propagation safety** — no unknown/high-impedance values on output buses when validity flags are high

---

## Synthesis & Physical Results

### Setup

Both synthesis runs used identical RTL sources, constraints, and the **90nm slow PVT corner** (`slow.db`, VDD = 1.62 V):

- **Target clock**: 2.4 ns (416 MHz) with 0.10 ns uncertainty
- **Optimization**: hierarchy flattening + register retiming (both runs)
- **GATE run adds**: Integrated Clock Gating (ICG)

### Timing Closure

| Flow | Target | Frequency | WNS | Status |
|---|---|---|---|---|
| NOGATE | 2.4 ns | 416 MHz | 0.00 ns | ✅ **MET** |
| GATE | 2.4 ns | 416 MHz | 0.00 ns | ✅ **MET** |

Clock gating was introduced **without any timing degradation** — the GATE critical path explicitly includes clock-gate/latch structures and still closes at 0.00 ns slack.

### Power & Area (NOGATE vs. GATE)

| Metric | NOGATE | GATE | Δ |
|---|---|---|---|
| **Total Dynamic Power** | 21.94 mW | 4.52 mW | **−79.4%** |
| **Clock Network Power** | 17.09 mW | 1.39 mW | **−91.9%** |
| Cell Leakage Power | 5.23 µW | 3.98 µW | −23.8% |
| Total Cell Area | 172,769 | 145,108 | −16.0% |
| Sequential Cells | 783 | 589 | −24.8% |
| Gated Registers (GATE) | — | 582 / 585 | **99.49%** |

> The GATE run achieves lower area *and* lower power than NOGATE — clock gating enables more efficient optimization during synthesis in addition to the direct switching-activity reduction.

### Synthesis Runtime

| Run | Wall Clock Time |
|---|---|
| GATE | ~156 s |
| NOGATE | ~185 s |

The clock-gated run completes faster due to reduced switching activity during optimization.

---

## Gate-Level Simulation

GLS was performed on both post-synthesis netlists with **SDF back-annotation** (max and min delay modes) using the same verification environment as RTL simulation.

| Netlist | SDF Annotation | Transactions | Failures |
|---|---|---|---|
| NOGATE | ✅ Successfully applied | 559 | **0** |
| GATE | ✅ Successfully applied | 559 | **0** |

```
# TB COMPLETE | txns=559 pass=1118 fail=0   ← NOGATE GLS
# TB COMPLETE | txns=559 pass=1118 fail=0   ← GATE GLS
```

Both netlists are **functionally equivalent** under realistic gate-level delays, confirming that clock gating does not affect functional correctness.

---

## Project Structure

```
DDLS PROJECT FINAL/
├── RTL/                        # RTL source files (SystemVerilog/Verilog)
│   ├── Top.sv
│   ├── ControlFsm.sv
│   ├── MixColumns.sv
│   ├── Register.sv
│   ├── subBytes.v
│   ├── sbox.v
│   └── constants.vh
│
├── TB/                         # RTL verification environment
│   ├── tb_top.sv
│   ├── dut_if.sv
│   ├── aes_bfm.sv
│   ├── aes_ref_model.sv
│   ├── scoreboard.sv
│   ├── stimuli.sv
│   ├── tb_assertions.sv
│   ├── tb_cov.sv
│   └── tb_types_pkg.sv
│
├── gate_level/                 # Post-synthesis netlists + SDF/SDC
│   ├── gate/                   # With clock gating
│   └── nogate/                 # Without clock gating
│
├── gate_level_TB/              # GLS verification environment
│
├── lib/
│   └── slow.v                  # 90nm standard-cell behavioral models
│
├── synthesis_reports/          # DC reports: timing / area / power / QoR
│   ├── gate/
│   └── nogate/
│
├── verification_reports/       # Coverage, assertion, and code coverage logs
│
├── WaveDo/
│   └── wave.do                 # ModelSim waveform script
│
└── DOC/
    ├── Final_Project_Report.pdf
    └── README.md
```

---

## How to Run

> Simulator: **ModelSim / QuestaSim**  
> Note: `constants.vh` is under `RTL/` — add `+incdir+RTL` when compiling.

### 1 · RTL Simulation

Compile in this order:

```tcl
vlog TB/tb_types_pkg.sv
vlog RTL/Register.sv
vlog RTL/ControlFsm.sv
vlog RTL/MixColumns.sv
vlog RTL/sbox.v
vlog RTL/subBytes.v
vlog RTL/Top.sv
vlog TB/aes_ref_model.sv
vlog TB/dut_if.sv
vlog TB/aes_bfm.sv
vlog TB/scoreboard.sv
vlog TB/stimuli.sv
vlog TB/tb_assertions.sv
vlog TB/tb_cov.sv
vlog TB/tb_top.sv
```

Then simulate:

```tcl
vsim work.tb_top
do WaveDo/wave.do    # optional — load waveform config
run -all
```

Expected output: `# TB COMPLETE | txns=559 pass=1118 fail=0`

### 2 · Gate-Level Simulation (GLS) with SDF

Compile (replace `<gate|nogate>` with the desired variant):

```tcl
vlog lib/slow.v
vlog gate_level/<gate|nogate>/Top_netlist.v
vlog gate_level_TB/tb_types_pkg.sv
vlog gate_level_TB/dut_if.sv
vlog gate_level_TB/aes_bfm.sv
vlog gate_level_TB/aes_ref_model.sv
vlog gate_level_TB/scoreboard.sv
vlog gate_level_TB/stimuli.sv
vlog gate_level_TB/tb_top.sv
```

Simulate (NOGATE — max delays):

```tcl
vsim -voptargs=+acc work.tb_top \
     -sdfmax {/tb_top/dut=gate_level/nogate/Top.sdf} +maxdelays
run -all
```

Simulate (GATE — max delays):

```tcl
vsim -voptargs=+acc work.tb_top \
     -sdfmax {/tb_top/dut=gate_level/gate/Top.sdf} +maxdelays
run -all
```

Replace `-sdfmax`/`+maxdelays` with `-sdfmin`/`+mindelays` for best-case (hold) analysis.

---

*Ben-Gurion University of the Negev — Digital Design and Logic Synthesis, 2026*
