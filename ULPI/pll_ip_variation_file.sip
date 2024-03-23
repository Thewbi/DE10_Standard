set_global_assignment -entity "pll_ip_variation_file" -library "lib_pll_ip_variation_file" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_ip_variation_file" -library "lib_pll_ip_variation_file" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "pll_ip_variation_file" -library "lib_pll_ip_variation_file" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_ip_variation_file" -name SPD_FILE [file join $::quartus(sip_path) "pll_ip_variation_file.spd"]

set_global_assignment -library "lib_pll_ip_variation_file" -name MISC_FILE [file join $::quartus(sip_path) "pll_ip_variation_file_sim/pll_ip_variation_file.vo"]
