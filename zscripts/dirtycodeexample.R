# ==============================
# CMIP6 File Metadata & Variable Plot
# ==============================

library(terra)
library(maps)

# --- 1. Load the file ---
f <- "/Users/ibrito/Downloads/tos_Omon_GFDL-ESM4_ssp585_r1i1p1f1_gr_207501-209412.nc"   # <- change to your downloaded file
r <- rast(f)

# --- 2. Identify variable (generic) ---
vn  <- terra::varnames(r)          # short variable name in the NetCDF (e.g., tos, ph, o2)
r_var <- r[[1]]                    # use the first variable stack in the file

# --- 3. Print full metadata ---
cat("\n================== METADATA ==================\n")
print(r)

# Parse filename parts (CMIP6-style)
fname <- basename(f)
parts <- unlist(strsplit(fname, "_"))

model    <- parts[3]
scenario <- parts[4]
ensemble <- parts[5]

cat("\nModel name:", model,
    "\nEnsemble member:", ensemble,
    "\nScenario:", scenario,
    "\nNative resolution (lat/lon degrees):", paste(terra::res(r_var), collapse = " x "),
    "\nVariable units:", units(r_var)[1],
    "\n=============================================\n\n")

# --- 4. Plot first layer ---
if (nlyr(r_var) > 1) r_var <- r_var[[1]]

png("/Users/ibrito/Desktop/quick_var.png", width = 1000, height = 600, res = 120)
plot(terra::rotate(r_var), main = paste("Quick Plot -", vn, terra::time(r_var)))
maps::map("world", add = TRUE)
dev.off()

# --- 5. Global mean ---
mean_val <- terra::global(r_var, "mean", na.rm = TRUE)[[1]]
cat("Variable plotted:", vn, "\n")
cat("Global mean value (first time step):", round(mean_val, 3), units(r_var)[1], "\n")
cat("PNG saved: quick_var.png\n")