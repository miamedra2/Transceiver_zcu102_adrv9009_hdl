// ----------------------------------------------------------------
// axi4_address_counter.sv
//
// 5/3/2017 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// This component implements an address counter that meets the
// requirements of the ARM AMBA AXI4 standard [1]. Independent
// address logic is used on the AXI4 write and read interfaces
// (this component can be used on both interfaces).
//
// ARM AXI4 interface signal descriptions;
//
//   Signal     Description
//   ------     -----------
//   AxADDR     Byte-based start address
//   AxLEN      Burst length (number of transfers)
//   AxSIZE     Size of each transfer (in bytes)
//   AxBURST    Burst type
//
//   where x = W for write, R for read
//
// The supported burst types are;
//
//  AxBURST[1:0]
//  ------------
//  00b = FIXED
//  01b = INCR
//  10b = WRAP
//  11b = Reserved
//
// The burst length (number of transfers) depends on the burst
// mode;
//
//  Burst Mode     Burst Length
//  AxBURST[1:0]   AxLEN[3:0]+1   AxLEN[3:0]
//  -----------    ------------   ----------
//  00b = FIXED     1 to 16       0000b to 1111b
//  01b = INCR      1 to 256      0000_0000b to 1111_1111b
//  10b = WRAP      2, 4, 8, 16   0001b, 0011b, 0111b, 1111b
//
// AXI4 slave designers can assume the use of an AXI4 compliant
// master, and so the slave does not need to check for invalid
// transaction parameters (verification of the components can
// ensure this assumption is true).
//
// Slaves can use the burst length, AxLEN, during read or write
// phases. The burst length is typically used during read
// transactions to intialize a down-counter which is then used
// to count the number of transfers in the read burst. The
// burst length can be optionally used during write bursts.
// Alternatively, the slave can assume the AXI4 master is
// compliant to the standard, and simply continue to accept
// write phases until the master asserts WLAST to indicate
// the end of the burst.
//
// This address counter component uses the burst length, AxLEN,
// only when the burst mode is WRAP, since in this mode, the
// burst length determines the address wrap boundary.
//
// ----------------------------------------------------------------
// Address Counter Implementation Details
// --------------------------------------
//
// The ARM AMBA AXI4 address counter includes;
//  * a 12-bit address counter for the 4kB burst boundary
//  * a (AXI_ADDR_WIDTH-12)-bit register for the address MSBs
//  * an increment register initialized to (1 << axi_size)
//  * a combinatorial sum
//  * burst-mode dependent address counter bit-enable logic;
//    - FIXED: bit_en = '0
//    - INCR : bit_en = '1
//    - WRAP : bit_en <= (axi_len << axi_size)
//
// An AXI4 transaction sequence proceeds as follows;
//
// 1. Transaction start
//    * Load the byte-based address counter with AxADDR[]
//    * Assuming a 4kB decode region, the byte-based address
//      width is 12-bits. In the examples below, the start
//      address bits are ssss_ssss_ssss.
//
// 2. Increment the address counter after each transfer
//
//    a) For (AxBURST == FIXED)
//
//       The address counter does not increment. The address
//       counter bits are ssss_ssss_ssss.
//
//    b) For (AxBURST == INCR)
//
//       The AxSIZE field determines the increment, i.e.,
//
//        AxSIZE  Incr   Address Bits (that change)
//        ------  ----   --------------------------
//         000b    +1    XXXX_XXXX_XXXX
//         001b    +2    XXXX_XXXX_XXXs
//         010b    +4    XXXX_XXXX_XXss
//
//      where XXXX_XXXX = ssss_ssss + n*incr
//      and n = 0, 1, 2, 3, ... (length-1)
//
//      If the start address is not 256-byte aligned, then
//      the carry out will affect the counter MSBs.
//
//    c) For (AxBURST == WRAP)
//
//       AxLEN is 2, 4, 8, or 16.
//       Relative to INCR, there is a reduced number of
//       bits that change in the counter, eg.,
//
//      i) (AxLEN == 2)
//
//        AxSIZE  Incr   Address Bits
//        ------  ----   --------------
//         000b    +1    ssss_ssss_sssX
//         001b    +2    ssss_ssss_ssXs
//         010b    +4    ssss_ssss_sXss
//
//      ii) (AxLEN == 4)
//
//        AxSIZE  Incr   Address Bits
//        ------  ----   --------------
//         000b    +1    ssss_ssss_ssXX
//         001b    +2    ssss_ssss_sXXs
//         010b    +4    ssss_ssss_XXss
//
//      iii) (AxLEN == 8)
//
//        AxSIZE  Incr   Address Bits
//        ------  ----   --------------
//         000b    +1    ssss_ssss_sXXX
//         001b    +2    ssss_ssss_XXXs
//         010b    +4    ssss_sssX_XXss
//
//      iv) (AxLEN == 16)
//
//        AxSIZE  Incr   Address Bits
//        ------  ----   --------------
//         000b    +1    ssss_ssss_XXXX
//         001b    +2    ssss_sssX_XXXs
//         010b    +4    ssss_ssXX_XXss
//
//      These patterns show that a subset of bits within the
//      combinatorial sum need to be captured by the address
//      registers. This component meets this requirement using
//      the bit_en bits.
//
// ARM does not publish a recommended HDL implementation for the
// AXI4 standard. The fact that the logic below has a fairly
// simply implementation (in terms of logic operators) implies
// that the AXI4 standard addressing modes were designed
// with the intention of using logic similar to this component.
//
// ----------------------------------------------------------------
// Notes
// -----
//
// 1. AXI4 address phase
//
//    The AXI4 address phase is only valid for the single clock
//    during which AxVALID and AxREADY are asserted. This AXI4 bus
//    phase occurs when addr_load is asserted. The addr_load input
//    is used to capture the burst mode, increment, bit-enables,
//    and start address.
//
// 2. AXI4 data phases
//
//    The AXI4 write or read data phases are used to control the
//    addr_en input.
//
// ----------------------------------------------------------------
// References
// ----------
//
// [1] ARM, "AMBA 4 AXI4, AXI4-Lite, and AXI4-Stream Protocol
//     Assertions User Guide", Rev. r0p1, 2012.
//     DUI0534B_amba_4_axi4_protocol_assertions_ug.pdf
//
// ----------------------------------------------------------------

module axi4_address_counter #(
		// AXI parameters
		parameter integer AXI_ADDR_WIDTH = 12,
		parameter integer AXI_DATA_WIDTH = 32
	) (
		// --------------------------------------------------------
		// AXI Reset and Clock
		// --------------------------------------------------------
		//
		input  logic                      axi_aresetn,
		input  logic                      axi_aclk,

		// --------------------------------------------------------
		// AXI Write or Read Address Channel
		// --------------------------------------------------------
		//
		input  logic [AXI_ADDR_WIDTH-1:0] axi_addr,
		input  logic                [7:0] axi_len,
		input  logic                [2:0] axi_size,
		input  logic                [1:0] axi_burst,

		// --------------------------------------------------------
		// Byte-based Address
		// --------------------------------------------------------
		//
		input  logic                      addr_load,
		input  logic                      addr_en,
		output logic [AXI_ADDR_WIDTH-1:0] addr
	);

	// ------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------
	//
	logic [AXI_ADDR_WIDTH-1:12] addr_msbs = '0;
	logic [11:0]                addr_lsbs = '0;
	logic [11:0]                sum;
	logic [7:0]                 incr      = '0;
	logic [11:0]                bit_en    = '0;

	// ------------------------------------------------------------
	// Increment
	// ------------------------------------------------------------
	//
	// The AXI4 standard indicates that the size of any transfer
	// must not exceed the data bus width. For a 32-bit data bus,
	// the only valid increment values are 1, 2, and 4-bytes.
	//
	// The AXI_DATA_WIDTH generic could be used to implement the
	// increment based on the bus width, however, the following
	// logic implements all possible increment values.
	// Implementing the increment register based on the bus width
	// would complicate the code with very little benefit.
	//
	always_ff @(negedge axi_aresetn, posedge axi_aclk) begin
		if (~axi_aresetn) begin
			incr <= '0;
		end
		else begin
			if (addr_load) begin
				incr <= (1 << axi_size);
			end
		end
	end

	// ------------------------------------------------------------
	// Address register enables
	// ------------------------------------------------------------
	//
	// In FIXED mode, the address counter does not increment, so
	// the address register enables are all zero.
	//
	// In INCR mode, the address counter increments, so the address
	// register enables are all one.
	//
	// In WRAP mode only some of the bits of the sum are copied
	// into the address register. The number of address bits
	// depends on AxSIZE and AxLEN. The relationship between the
	// bit-enables and AXI4 transaction parameters is;
	//
	//                  bit_en binary values
	//    ---------------------------------------------------
	//   |       | AxLEN                                     |
	//   |AxSIZE |     1         3          7         15     |
	//   |-------|-------------------------------------------|
	//   |    0  | 0000_0001 0000_0011  0000_0111  0000_1111 |
	//   |    1  | 0000_0010 0000_0110  0000_1110  0001_1110 |
	//   |    2  | 0000_0100 0000_1100  0001_1100  0011_1100 |
	//   |    3  | 0000_1000 0001_1000  0011_1000  0111_1000 |
	//                       ... etc ...
	//
	// i.e., bit_en <= (axi_len << axi_size).
	//
	// The bit-enable setting is determined during the AXI4
	// address transaction phase.
	//
	always_ff @(negedge axi_aresetn, posedge axi_aclk) begin
		if (~axi_aresetn) begin
			bit_en <= '0;
		end
		else begin
			if (addr_load) begin
				case (axi_burst)
					// FIXED
					// * no bits enabled
					2'b00: bit_en <= '0;

					// INCR
					// * all bits enabled
					2'b01: bit_en <= '1;

					// WRAP
					// * some bits enabled
					2'b10: bit_en <= (axi_len << axi_size);

					// Default to INCR
					default: bit_en <= '1;
				endcase
			end
		end
	end

	// ------------------------------------------------------------
	// Combinatorial sum
	// ------------------------------------------------------------
	//
	// This is the simplest way to describe the sum carry-in and
	// carry-out logic.
	//
	assign sum = addr_lsbs + incr;

	// ------------------------------------------------------------
	// Registered address
	// ------------------------------------------------------------
	//
	// The AXI4 bus defines a 4kB burst boundary, so only the
	// 12-LSBs of the address need to implement a counter. The
	// MSBs are simply registered.
	//
	// The bit-enables are the key to implementing the increment
	// and wrap addressing modes.
	//
	always_ff @(negedge axi_aresetn, posedge axi_aclk) begin
		if (~axi_aresetn) begin
			addr_msbs <= '0;
			addr_lsbs <= '0;
		end
		else begin
			if (addr_load) begin
				addr_msbs <= axi_addr[AXI_ADDR_WIDTH-1:12];
				addr_lsbs <= axi_addr[11:0];
			end
			else if (addr_en) begin
				for (int i = 0; i < 12; i++) begin
					if (bit_en[i]) begin
						addr_lsbs[i] <= sum[i];
					end
				end
			end
		end
	end

	// Output address
	assign addr = {addr_msbs, addr_lsbs};

endmodule

