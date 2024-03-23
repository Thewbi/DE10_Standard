set_global_assignment -entity "vga_25Mhz_pll" -library "lib_vga_25Mhz_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "vga_25Mhz_pll" -library "lib_vga_25Mhz_pll" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "vga_25Mhz_pll" -library "lib_vga_25Mhz_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_vga_25Mhz_pll" -name SPD_FILE [file join $::quartus(sip_path) "vga_25Mhz_pll.spd"]

set_global_assignment -library "lib_vga_25Mhz_pll" -name MISC_FILE [file join $::quartus(sip_path) "vga_25Mhz_pll_sim/vga_25Mhz_pll.vo"]
