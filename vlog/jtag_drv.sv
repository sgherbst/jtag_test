`timescale 1ns / 1ps

module jtag_drv(
    inout [14:0] DDR_addr,
    inout [2:0] DDR_ba,
    inout DDR_cas_n,
    inout DDR_ck_n,
    inout DDR_ck_p,
    inout DDR_cke,
    inout DDR_cs_n,
    inout [3:0] DDR_dm,
    inout [31:0] DDR_dq,
    inout [3:0] DDR_dqs_n,
    inout [3:0] DDR_dqs_p,
    inout DDR_odt,
    inout DDR_ras_n,
    inout DDR_reset_n,
    inout DDR_we_n,
    inout FIXED_IO_ddr_vrn,
    inout FIXED_IO_ddr_vrp,
    inout [53:0] FIXED_IO_mio,
    inout FIXED_IO_ps_clk,
    inout FIXED_IO_ps_porb,
    inout FIXED_IO_ps_srstb
);

    // internal signals   
    wire [31:0] gpio_in;
    wire [31:0] gpio_out;
    wire tck, trst_n, tms, tdi, tdo;
    wire [15:0] tap_state;
    
    // wiring
    assign gpio_in = {12'hFAD, tap_state, 3'b000, tdo};
    assign tck = gpio_out[0];
    assign trst_n = gpio_out[1];
    assign tms = gpio_out[2];
    assign tdi = gpio_out[3];
    
    design_1_wrapper bd_i (
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );

    tap_core tap_core_i (
        .tck(tck),
        .trst_n(trst_n),
        .tms(tms),
        .tdi(tdi),
        .so(1'b0),
        .bypass_sel(1'b0),
        .sentinel_val(4'b0),

        .clock_dr(),
        .shift_dr(),
        .update_dr(),
        .tdo(tdo),
        .tdo_en(),
        .tap_state(tap_state),
        .extest(),
        .samp_load(),
        .instructions(),
        .sync_capture_en(),
        .sync_update_dr(),

        .test(1'b0)
    );
endmodule