`timescale 1ns / 1ps

module top(
    input sysclk,
    input [1:0] sw,
    output [3:0] led
);
    // clock wizard
    wire clk;
    clk_wiz_0 clk_wiz_0_i (
        .clk_out1(clk),
        .clk_in1(sysclk)
    );
        
    // key I/O
    wire tck, trst_n, tms, tdi, tdo;
    
    // secondary inputs
    wire so, test;
    
    // secondary outputs
    wire clock_dr, shift_dr, update_dr, tdo_en;
    wire extest, samp_load, sync_capture_en, sync_update_dr;
    wire [15:0] tap_state;
    wire [4:0] instructions;
    
    tap_core tap_core_i (
        .tck(tck),
        .trst_n(trst_n),
        .tms(tms),
        .tdi(tdi),
        .so(so),
        .bypass_sel(1'b0),
        .sentinel_val(4'b0),

        .clock_dr(clock_dr),
        .shift_dr(shift_dr),
        .update_dr(update_dr),
        .tdo(tdo),
        .tdo_en(tdo_en),
        .tap_state(tap_state),
        .extest(extest),
        .samp_load(samp_load),
        .instructions(instructions),
        .sync_capture_en(sync_capture_en),
        .sync_update_dr(sync_update_dr),

        .test(test)
    );
    
    // VIO
    vio_0 vio_0_wiz (
        .clk(clk),
        .probe_in0(tdo),
        .probe_in1(clock_dr),
        .probe_in2(shift_dr),
        .probe_in3(update_dr),
        .probe_in4(tdo_en),
        .probe_in5(extest),
        .probe_in6(samp_load),
        .probe_in7(sync_capture_en),
        .probe_in8(sync_update_dr),
        .probe_in9(tap_state),
        .probe_in10(instructions),
        .probe_out0(tck),
        .probe_out1(trst_n),
        .probe_out2(tms),
        .probe_out3(tdi),
        .probe_out4(so),
        .probe_out5(test)
    );  
    
    // sanity check
    assign led = 4'b0001 << sw;
endmodule