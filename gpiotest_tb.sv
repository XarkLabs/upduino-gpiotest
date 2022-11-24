// gpiotest_tb.sv
//
// vim: set et ts=4 sw=4
//
// Simulation "testbench" for gpiotest design.  This "pretends" to be the FPGA
// hardware by generating a clock input and monitoring the LED outputs.
//

`default_nettype none               // mandatory for Verilog sanity
`timescale 1ns/1ps

module gpiotest_tb();                // module definition

logic       gpio_23;
logic       gpio_25;
logic       gpio_26;
logic       gpio_27;
logic       gpio_32;
logic       gpio_35;
logic       gpio_31;
logic       gpio_37;
logic       gpio_34;
logic       gpio_43;
logic       gpio_36;
logic       gpio_42;
logic       gpio_38;
logic       gpio_28;
logic       gpio_20;
logic       gpio_10;
logic       gpio_12;
logic       gpio_21;
logic       gpio_13;
logic       gpio_19;
logic       gpio_18;
logic       gpio_11;
logic       gpio_9;
logic       gpio_6;
logic       gpio_44;
logic       gpio_4;
logic       gpio_3;
logic       gpio_48;
logic       gpio_45;
logic       gpio_47;
logic       gpio_46;
logic       gpio_2;
logic       clk;    // simulated 12MHz "external clock" for design

// instantiate the design to test (unit-under-test)
gpiotest_main uut(
    // all 32 normal GPIO pins
    .gpio_23(gpio_23),
    .gpio_25(gpio_25),
    .gpio_26(gpio_26),
    .gpio_27(gpio_27),
    .gpio_32(gpio_32),
    .gpio_35(gpio_35),
    .gpio_31(gpio_31),
    .gpio_37(gpio_37),
    .gpio_34(gpio_34),
    .gpio_43(gpio_43),
    .gpio_36(gpio_36),
    .gpio_42(gpio_42),
    .gpio_38(gpio_38),
    .gpio_28(gpio_28),
`ifndef OSC
    .gpio_20(gpio_20),
`endif
    .gpio_10(gpio_10),
    .gpio_12(gpio_12),
    .gpio_21(gpio_21),
    .gpio_13(gpio_13),
    .gpio_19(gpio_19),
    .gpio_18(gpio_18),
    .gpio_11(gpio_11),
    .gpio_9(gpio_9),
    .gpio_6(gpio_6),
    .gpio_44(gpio_44),
    .gpio_4(gpio_4),
    .gpio_3(gpio_3),
    .gpio_48(gpio_48),
    .gpio_45(gpio_45),
    .gpio_47(gpio_47),
    .gpio_46(gpio_46),
    .gpio_2(gpio_2),
    .clk(clk)
);
// initial block (run once at startup)
initial begin
    $timeformat(-9, 0, " ns", 9);
    $dumpfile("logs/gpiotest_tb.fst");
    $dumpvars(0, uut);
    $display("Simulation started");
`ifdef OSC
    gpio_20 = 1'b0;
`endif

    clk = 1'b0; // set initial value for clk

    $monitor("seq = %x\ngpio_23 = %x gpio_25 = %x gpio_26 = %x gpio_27 = %x gpio_32 = %x gpio_35 = %x gpio_31 = %x gpio_37 = %x\ngpio_34 = %x gpio_43 = %x gpio_36 = %x gpio_42 = %x gpio_38 = %x gpio_28 = %x gpio_20 = %x gpio_10 = %x\ngpio_12 = %x gpio_21 = %x gpio_13 = %x gpio_19 = %x gpio_18 = %x gpio_11 = %x gpio_9  = %x gpio_6  = %x\ngpio_44 = %x gpio_4  = %x gpio_3  = %x gpio_48 = %x gpio_45 = %x gpio_47 = %x gpio_46 = %x gpio_2 = %x", uut.seq, gpio_23, gpio_25, gpio_26, gpio_27, gpio_32, gpio_35, gpio_31, gpio_37, gpio_34, gpio_43, gpio_36, gpio_42, gpio_38, gpio_28, gpio_20, gpio_10, gpio_12, gpio_21, gpio_13, gpio_19, gpio_18, gpio_11, gpio_9, gpio_6, gpio_44, gpio_4, gpio_3, gpio_48, gpio_45, gpio_47, gpio_46, gpio_2);

    #10ms;

    $display("Ending simulation at %0t", $realtime);
    $finish;
end

// ns for 12 Mhz / 2 (delay for clk toggle)
localparam NS_12M   =   (1_000_000_000 / 12_000_000) / 2;

// toggle clock at 12 Mhz frequency
always begin
    #(NS_12M)   clk <= !clk;
end

endmodule

`default_nettype wire               // restore default
