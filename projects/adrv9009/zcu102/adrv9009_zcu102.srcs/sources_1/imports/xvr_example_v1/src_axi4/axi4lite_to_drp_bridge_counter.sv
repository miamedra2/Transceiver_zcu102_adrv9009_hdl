// ----------------------------------------------------------------
// axi4lite_to_drp_bridge_counter.sv
//
// 5/3/2017 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// General purpose counter.
//
// ----------------------------------------------------------------

module axi4lite_to_drp_bridge_counter #(
      // Counter bit-width
      parameter WIDTH = 16,

      // Asynchronous reset load value
      parameter logic [WIDTH-1:0] INIT = '0
   )(
      input  logic             rst_n,
      input  logic             clk,
      input  logic             load,
      input  logic             en,
      input  logic             dir,
      input  logic             cin,
      input  logic [WIDTH-1:0] d,
      output logic [WIDTH-1:0] q,
      output logic             cout
   );

   // ------------------------------------------------------------
   // Internal signals
   // ------------------------------------------------------------
   //
   // Combinatorial sum (used to generate the carry out)
   logic [WIDTH:0] sum;
   //
   // Registered count
   logic [WIDTH-1:0] count = '0;

   // ------------------------------------------------------------
   // Combinatorial sum
   // ------------------------------------------------------------
   //
   // Up/Down counter
   always_comb begin
      if (dir) begin
         sum = count + cin;
      end
      else begin
         sum = count - cin;
      end
   end

   // Carry out
   assign cout = sum[WIDTH];

   // ------------------------------------------------------------
   // Registered count
   // ------------------------------------------------------------
   //
   always_ff @(negedge rst_n, posedge clk) begin
      if (~rst_n) begin
         count <= INIT;
      end
      else begin
         if (load) begin
            count <= d;
         end
         else if (en) begin
            count <= sum;
         end
      end
   end

   // Count output
   assign q = count;

endmodule

