# GCC ARM Cortex-M4 specific flags.

# C specifics flags.
set(C_CORTEX_SPECIFIC_FLAGS
    -mcpu=cortex-m4
    -mfloat-abi=hard
    -mfpu=fpv4-sp-d16
    -ffunction-sections
    -fdata-sections)

# C++ specifics flags.
set(CXX_CORTEX_SPECIFIC_FLAGS
    -mcpu=cortex-m4
    -mfloat-abi=hard
    -mfpu=fpv4-sp-d16
    -ffunction-sections
    -fdata-sections
    -fno-exceptions
    -fno-rtti)
