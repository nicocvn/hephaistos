# GCC ARM Cortex-M0+ specific flags.

# C specifics flags.
set(C_CORTEX_SPECIFIC_FLAGS
    -mcpu=cortex-m0plus
    -ffunction-sections
    -fdata-sections)

# C++ specifics flags.
set(CXX_CORTEX_SPECIFIC_FLAGS
    -mcpu=cortex-m0plus
    -ffunction-sections
    -fdata-sections
    -fno-exceptions
    -fno-rtti)
