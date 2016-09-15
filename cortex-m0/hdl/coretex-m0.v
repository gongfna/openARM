//
// coretex-m0.v
//
// Danny Gale
// 09/15/2016
//
// Top-level module for a cortex-m0 compatible cpu
//
// external interfaces:
//	 AHB-lite
//	 Debug Access Port (DAP)
//
// configurable options:
//    external interrupts: 1, 2, 4, 8, 16, 24, or 32
//    data endianness: big or little
//    SysTick timer: present or absent
//    Halting debug support: present or absent
//    when halting debug support is present:
//	 # of watchpoint comparators: 0, 1, 2 
//	 # of breakpoint comparators: 0, 1, 2, 3, 4
//    Multiplier: fast (single cycle) or small (iterative 32-cycle)
//
//


module cortex_m0 (
   input clk,
   input reset,

);


endmodule

