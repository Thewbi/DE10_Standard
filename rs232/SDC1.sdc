create_clock -period "50.0 MHz" [get_ports CLOCK_50]
create_clock -period "50.0 MHz" [get_ports CLOCK2_50]
create_clock -period "10.0 MHz" [get_ports CLOCK_ADC_10]
create_clock -period "100.0 MHz" [get_ports DRAM_CLK]
derive_pll_clocks
derive_clock_uncertainty