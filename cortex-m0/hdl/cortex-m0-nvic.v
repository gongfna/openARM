//
// cortex-m0-nvic.v
//
// the nested vectored interrupt controller for the cortex-m0 cpu complex
// note that regardless of the endianness of the cpu, the nvic is always
// little endian
//
// Danny Gale
// 9/15/2016
//

module cortex_m0_nvic (
   input clk,
   input reset,

   input [N_EXT_INT-1:0] ext_int,
   input nmi

   // needs a bus interface
);

reg [31:0] ISER; // interrupt set-enable register
reg [31:0] ICER; // interrupt clear-enable register
reg [31:0] ISPR; // interrupt set-pending register
reg [31:0] ICPR; // interrupt clear-pending register
reg [31:0] IPR[7:0]; // interrupt priority registers

endmodule;
