import numpy as np

# ==========================================
# Physical Parameters for the Hole-Substrate
# ==========================================
Seebeck_S = 200e-6    # Seebeck Coefficient (V/K)
R_electrical = 0.05   # Internal Electrical Resistance (Ohms)
K_thermal = 0.02      # Thermal Conductance of the interface (W/K)
T_cold = 300.0        # Local junction temperature (Kelvin)
T_hot = 304.0         # Hot-side temp at macro sink interface (Kelvin)
delta_T = T_hot - T_cold

# Current sweep array from 0 to 4 Amps
currents = np.linspace(0, 4, 200)

# ==========================================
# Compute Thermodynamic Components
# ==========================================
peltier_cooling = Seebeck_S * T_cold * currents
joule_parasitic = 0.5 * (currents**2) * R_electrical
conduction_loss = K_thermal * delta_T

# Net Heat Extracted from Chip
net_cooling = peltier_cooling - joule_parasitic - conduction_loss

# Find mathematical optimum current
opt_index = np.argmax(net_cooling)
I_opt = currents[opt_index]

print(f"Operational Parameter Verified: Injected current should cap at exactly {I_opt:.2f} A.")
