# Duty/Standby Dual-Motor Control System (OpenPLC & AutoCAD Electrical)

Industrial automation portfolio project implementing a **duty/standby control system** for two three-phase induction motors (M1 & M2) — typical of pumping stations, cooling loops, and compressor skids.

The project combines **IEC 61131-3 PLC programming** (Ladder Diagram + Structured Text in OpenPLC) with a **two-sheet electrical panel design** (400 V AC power circuit & 24 V DC PLC control wiring in AutoCAD Electrical) and full technical documentation.

📄 **[Read the Full Technical Report (PDF)](docs/Motor_Control_Report.pdf)**  
📐 **[View Electrical Panel Schematics (PDF)](electrical-panel/Plc_motor_control.pdf)**

---

## Key Features

* **Mutual Interlocking (Software & Hardware):** Prevents simultaneous operation of M1 and M2 via PLC interlock contacts and hardwired NC auxiliary contacts (`KM1` / `KM2`).
* **Fail-Safe Input Logic:** Stop (`STOP_CMD`), Emergency Stop (`E_STOP`), and thermal overload relays (`M1_thermal`, `M2_thermal`) are wired as **Normally Closed (NC)** so a broken wire triggers a safe stop.
* **Latched Thermal Faults & Automatic Failover:** If the duty motor trips on thermal overload, its command drops and the standby motor takes over within the **same 20 ms scan cycle**.
* **Manual Reset with Restart Delay:** Pressing `Fault_reset` initiates a 5 s on-delay timer before clearing `Mx_FAULT`; the recovered motor returns to standby without interrupting the active motor.
* **Time-Based Duty Rotation:** Automatic wear-sharing rotation between M1 and M2 (15 s demonstration interval), blocked automatically if the standby motor is faulted.
* **Runtime & Switch Tracking (Structured Text):** Dedicated ST POU (`switch_counter`) tracks active motor state, counts valid duty transitions (ignoring initial startup and scan-cycle dead-times), and accumulates runtime in seconds (`DINT`).

---

## System Architecture & Repository Structure

Two POUs execute sequentially within a single **20 ms cyclic task**:
1. **`main` (Ladder Diagram):** Start/stop latching, safety interlocks, latched fault logic, reset timers, and duty rotation.
2. **`switch_counter` (Structured Text):** Active motor detection, edge-filtered switch counter, and 1 s runtime accumulators.

```text
duty-standby-motor-control-plc/
├── README.md
├── .gitignore
├── project.json                   # OpenPLC Editor project configuration
├── pous/                          # IEC 61131-3 POUs (main Ladder & switch_counter ST)
├── devices/                       # Hardware & resource configuration
├── docs/
│   ├── Motor_Control_Report.pdf   # Full technical report (LaTeX)
├── electrical_panel/
│   ├── Plc_motor_control.pdf      # Exported schematics (Power & Control)
│   ├── Plc_motor_control.wdp      # AutoCAD Electrical project file
│   └── *.dwg                      # Power & Control schematic drawings
└── media/
    ├── cmds.png                   # Motor command simulation traces
    └── active_sw.png              # Active motor & switch counter traces