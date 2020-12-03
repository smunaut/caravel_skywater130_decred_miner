`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oen,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7.
    inout [`MPRJ_IO_PADS-8:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2
);

    /*--------------------------------------*/
    /* Instantiation of decred_top.         */
    /*--------------------------------------*/

    decred_top mprj (
    `ifdef USE_POWER_PINS
	.vdda1(vdda1),	// User area 1 3.3V power
	.vdda2(vdda2),	// User area 2 3.3V power
	.vssa1(vssa1),	// User area 1 analog ground
	.vssa2(vssa2),	// User area 2 analog ground
	.vccd1(vccd1),	// User area 1 1.8V power
	.vccd2(vccd2),	// User area 2 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
	.vssd2(vssd2),	// User area 2 digital ground
    `endif
	// inputs
	.PLL_INPUT(user_clock2),
	.EXT_RESET_N_fromHost(io_in[0]),
	.SCLK_fromHost(io_in[1]),
	.M1_CLK_IN(io_in[2]),
	.M1_CLK_SELECT(io_in[3]),
	.S1_CLK_IN(io_in[4]),
	.S1_CLK_SELECT(io_in[5]),
	.SCSN_fromHost(io_in[6]),
	.MOSI_fromHost(io_in[7]),
	.MISO_fromClient(io_in[8]),
	.IRQ_OUT_fromClient(io_in[9]),
	.ID_fromClient(io_in[10]),
	.SPI_CLK_RESET_N(io_in[11]),

	// outputs
	.SCSN_toClient(io_out[0]),
	.SCLK_toClient(io_out[1]),
	.MOSI_toClient(io_out[2]),
	.EXT_RESET_N_toClient(io_out[3]),
	.ID_toHost(io_out[4]),
	.CLK_LED(io_out[5]),
	.MISO_toHost(io_out[6]),
	.HASH_LED(io_out[7]),
	.IRQ_OUT_toHost(io_out[8])
    );

endmodule	// user_project_wrapper
`default_nettype wire
