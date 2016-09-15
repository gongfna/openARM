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

   output [23:0]ticks;
);

reg [23:0]ticks;

always @ (posedge clk)
begin
   if (reset)
      ticks <= 24'b0;
   else
      ticks <= ticks + 1;
end

endmodule;
