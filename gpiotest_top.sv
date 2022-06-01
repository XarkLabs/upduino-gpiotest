// gpiotest_top.sv
//
// vim: set et ts=4 sw=4
//
// "Top" of the gpiotest design (above is the FPGA hardware)
//
// * setup clock
// * setup inputs
// * setup outputs
// * instantiate main module
//
`default_nettype none             // mandatory for Verilog sanity
`timescale 1ns/1ps

//`define OSC                         // OSC jumper shorted, so skip gpio_20 (12MHz input)

module gpiotest_top (
    // outputs
    output  logic   spi_ssn,    // SPI flash CS, hold high to prevent UART conflict
    output  logic   led_red,    // red RGB led
    output  logic   led_green,  // green RGB led
    output  logic   led_blue,   // blue RGB led
    // all 32 normal GPIO pins
    output  logic   gpio_23,
    output  logic   gpio_25,
    output  logic   gpio_26,
    output  logic   gpio_27,
    output  logic   gpio_32,
    output  logic   gpio_35,
    output  logic   gpio_31,
    output  logic   gpio_37,
    output  logic   gpio_34,
    output  logic   gpio_43,
    output  logic   gpio_36,
    output  logic   gpio_42,
    output  logic   gpio_38,
    output  logic   gpio_28,
`ifndef OSC
    output  logic   gpio_20,
`else
    input wire logic gpio_20,
`endif
    output  logic   gpio_10,
    output  logic   gpio_12,
    output  logic   gpio_21,
    output  logic   gpio_13,
    output  logic   gpio_19,
    output  logic   gpio_18,
    output  logic   gpio_11,
    output  logic   gpio_9,
    output  logic   gpio_6,
    output  logic   gpio_44,
    output  logic   gpio_4,
    output  logic   gpio_3,
    output  logic   gpio_48,
    output  logic   gpio_45,
    output  logic   gpio_47,
    output  logic   gpio_46,
    output  logic   gpio_2
);

always_comb spi_ssn     = 1'b1;     // deselect SPI flash (pins shared with UART)

// clock signals
localparam      CLOCK_HZ    = 12_000_000;   // clock frequency in Hz
logic           clk;                        // clock signal for design

// === clock setup
`ifdef OSC     // if OSC (12MHz connected to gpio_20 or OSC jumper shorted)
logic unused_ext_clk;
assign unused_ext_clk = &{ 1'b0, gpio_20, (CLOCK_HZ == 0 ? 1'b0 : 1'b0) };

always_comb     clk = gpio_20;
`else              // else !OSC
`ifdef SYNTHESIS   // use 48MHz HF_OSC if synthesizing design for FPGA (without OSC)
// Lattice documentation for iCE40UP5K oscillators:
// https://www.latticesemi.com/-/media/LatticeSemi/Documents/ApplicationNotes/IK/iCE40OscillatorUsageGuide.ashx?document_id=50670
/* verilator lint_off PINMISSING */ // suppress warnings about "missing pin" (default okay here)
SB_HFOSC  #(
    .CLKHF_DIV("0b10")  // 12 MHz = ~48 MHz / 4 (divider 0b00=1, 0b01=2, 0b10=4, 0b11=8)
    ) hf_osc (
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(clk)
);
/* verilator lint_on PINMISSING */  // restore warnings about "missing pin"
`else               // else !SYNTHESIS, simulating design in simulator
// simulate hf_osc primitive (since doesn't won't work in simulation)
localparam NS_48M   =   (1_000_000_000 / CLOCK_HZ) / 2;   // delay for CLOCK_HZ frequency clk toggle in ns
// suppress verilog warnings that are okay during simulation
/* verilator lint_off STMTDLY */
logic unused_ext_clk;
assign unused_ext_clk = &{ 1'b0, gpio_20 };

initial begin
    clk = '0;               // set initial value (or it will be 'X', and !'X' is still 'X'...)
end

always begin
    #(NS_48M)   clk = !clk; // delay ns, then toggle clock
end
/* verilator lint_on STMTDLY */
`endif              // end !SYNTHESIS
`endif              // end !OSC

// RGB LED off (negative logic)
always_comb led_red     = ~1'b0;
always_comb led_green   = ~1'b0;
always_comb led_blue    = ~1'b0;

// === instantiate main module

gpiotest_main main(
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

endmodule
`default_nettype wire               // restore default
