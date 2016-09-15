//
// cortex-m0-systick.v
//
// implements the 24-bit SysTick timer that is optionally available in
// cortex-m0 CPUs
//
// Danny Gale
// 9/15/2016
//

module cortex_m0_systick (
   input clk,
   input reset,

   output [23:0]syst_cvr;
);

reg [23:0]ticks;

reg[31:0] syst_csr;
reg[31:0] syst_rvr;
reg[31:0] syst_cvr;
reg[31:0] syst_calib;

always @ (posedge clk)
begin
   if (reset)
      syst_cvr <= 24'b0;
   else
      syst_cvr <= ticks + 1;
end

endmodule;
