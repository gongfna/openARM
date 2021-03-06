//
// cortex-m0-core.v
//
// Implements the CPU core of the cortex-m0
//
// Danny Gale
// 09/15/2016
//

module cortex_m0_core (
   input clk,
   input reset,

   // needs a bus interface
);

`define MSP r[13]
`define PSP r[13]
`define LR r[14]
`define PC r[15]

parameter BW = 32;

reg [BW-1:0] r[15:0];
reg [BW-1:0] psr;
reg [BW-1:0] primask;
reg [BW-1:0] control;

reg [BW-1:0] cpuid;

// set the next program counter
always @ (posedge clk)
begin
   if (reset)
   begin
      `PC <= 32'b0;
   end else begin
      // what sources does the program counter have?
      //    normal increment
      //    jump/branch instructions

   end
end
