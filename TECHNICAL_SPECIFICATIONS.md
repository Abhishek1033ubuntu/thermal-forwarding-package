# Co-Designed Thermal Forwarding Package Matrix: Technical Specifications

This document outlines the exact structural boundaries, physical constraints, and fluid dynamic validations governing the modular active/passive thermal forwarding architecture.

## 1. Physical Layer Geometry & Material Stack

The package matrix utilizes a system-in-package (SiP) stack to isolate fragile thermoelectric materials to localized, high-heat zones directly beneath computational core blocks.

| Package Layer | Material | Key Property | Target Thickness | Manufacturing Tolerance |
| :--- | :--- | :--- | :--- | :--- |
| **Logic Core** | Silicon / GaN | $k = 150 \text{ W/m}\cdot\text{K}$ | $180 \ \mu\text{m}$ | $\pm 5 \ \mu\text{m}$ |
| **Micro-TIM Spreader** | Polycrystalline Diamond | $k \ge 1000 \text{ W/m}\cdot\text{K}$ | $2 \ \mu\text{m}$ | $\pm 50 \text{ nm}$ |
| **Active Pillars (Tier 1)** | Bismuth Telluride ($\text{Bi}_2\text{Te}_3$) | Seebeck $S = 200 \ \mu\text{V/K}$ | $60 \ \mu\text{m}$ | $\pm 1 \ \mu\text{m}$ |
| **Passive Substrate (Tier 2)**| Silicon Carbide (4H-SiC) | $k \approx 350 \text{ W/m}\cdot\text{K}$ | $60 \ \mu\text{m}$ | $\pm 1 \ \mu\text{m}$ |
| **Interfacial Void Filler** | Indium-Based TLPB Matrix | $k \approx 80 \text{ W/m}\cdot\text{K}$ | Roughness $R_a < 0.3 \text{ nm}$ | Atomic Flatness |

## 2. Thermoelectric Optimization & Boundary Conditions

The injection current protocol driven into the active $\text{Bi}_2\text{Te}_3$ pillars is calculated using the net junction heat extraction equation:

$$Q_{net} = S \cdot T_{cold} \cdot I - \frac{1}{2} I^2 R - K \cdot \Delta T$$

### Critical Parametric Inflection Point
* **Linear Peltier Power Extracted ($S \cdot T_{cold} \cdot I$):** Dominates at lower currents ($0\text{ A}$ to $1.1\text{ A}$).
* **Quadratic Parasitic Joule Heating ($\frac{1}{2}I^2R$):** Dominates exponentially past the optimal inversion threshold.
* **Verified Absolute Peak Performance Ceilng ($I_{opt}$):** **$1.21\text{ A}$**. The predictive hardware plane hard-caps current delivery at this value to prevent thermal runaway inside the substrate.

## 3. Micro-Channel Fluid Dynamics (Base Macro Sink)

Heat forwarded away from the silicon die is aggressively dissipated via an ultra-precise copper micro-channel liquid cold plate.

### Fluidic Boundaries
* **Channel Width ($W_c$):** $50 \ \mu\text{m}$
* **Fin Width ($W_f$):** $50 \ \mu\text{m}$
* **Channel Height ($H_c$):** $250 \ \mu\text{m}$
* **Hydraulic Diameter ($D_h$):** $83.33 \ \mu\text{m}$

At a target fluid flow velocity of $v = 1.5\text{ m/s}$, the calculated **Reynolds Number ($Re$)** remains well below the turbulence threshold ($Re \ll 2000$). This guarantees a **Strictly Laminar Flow Regime**, ensuring a stable conduction boundary layer and preventing high fluidic back-pressure penalties across the bottom of the package housing.

## 4. Hardware/Software Look-Ahead Protocol

The **Thermal Look-Ahead Unit** acts as an internal hardware scheduler embedded within the processor's command decoding infrastructure.

### Memory-Mapped Register Space
* `0x4002_F000` **`THERM_CTRL`** (8-bit) : Global active state configuration and emergency safety overrides.
* `0x4002_F004` **`OP_WEIGHT`** (16-bit) : Computational thermal load scalar calculated dynamically from decoded incoming opcodes.
* `0x4002_F008` **`I_TARGET`** (16-bit) : Target current output vector driven to the PMIC (Hard-capped at `12'h4BA` / $1.21\text{ A}$).
* `0x4002_F00C` **`JUNCT_TEMP`** (32-bit) : High-frequency thermal micro-diode feedback loop telemetry.
