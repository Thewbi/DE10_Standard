set_global_assignment -entity "baudrate_pll" -library "lib_baudrate_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "baudrate_pll" -library "lib_baudrate_pll" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "baudrate_pll" -library "lib_baudrate_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_baudrate_pll" -name SPD_FILE [file join $::quartus(sip_path) "baudrate_pll.spd"]

set_global_assignment -library "lib_baudrate_pll" -name MISC_FILE [file join $::quartus(sip_path) "baudrate_pll_sim/baudrate_pll.vo"]
