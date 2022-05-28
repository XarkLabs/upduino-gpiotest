// gpiotest_main.sv
//
// vim: set et ts=4 sw=4
//
// Simple main module of for gpiotest design (above is either FPGA top or
// testbench).
//
// This module has the gpiotest LED control logic, counter and buttons
//
`default_nettype none             // mandatory for Verilog sanity
`timescale 1ns/1ps

module gpiotest_main (
    // all 32 normal GPIO pins output
    output  logic       gpio_23,
    output  logic       gpio_25,
    output  logic       gpio_26,
    output  logic       gpio_27,
    output  logic       gpio_32,
    output  logic       gpio_35,
    output  logic       gpio_31,
    output  logic       gpio_37,
    output  logic       gpio_34,
    output  logic       gpio_43,
    output  logic       gpio_36,
    output  logic       gpio_42,
    output  logic       gpio_38,
    output  logic       gpio_28,
`ifndef OSC // skip gpio_20 if OSC jumper shorted (used as 12MHz clock input)
    output  logic       gpio_20,
`endif
    output  logic       gpio_10,
    output  logic       gpio_12,
    output  logic       gpio_21,
    output  logic       gpio_13,
    output  logic       gpio_19,
    output  logic       gpio_18,
    output  logic       gpio_11,
    output  logic       gpio_9,
    output  logic       gpio_6,
    output  logic       gpio_44,
    output  logic       gpio_4,
    output  logic       gpio_3,
    output  logic       gpio_48,
    output  logic       gpio_45,
    output  logic       gpio_47,
    output  logic       gpio_46,
    output  logic       gpio_2,
    // clock input
    input wire logic    clk         // clock for module input
);

// counter increment block
`ifdef SYNTHESIS
localparam      CNT_BITS = 28;              // constant for number of bits in counter in FPGA (human speed)
`else
localparam      CNT_BITS = 6;               // constant for number of bits in counter in simulation (super fast)
`endif
logic [CNT_BITS-1:0] counter;               // CNT_BITS bit counter with default FPGA reset value

// initialize signals (in simulation, or on FPGA reconfigure)
initial begin
    counter =  '0;
end

always_ff @(posedge clk) begin
    counter <= counter + 1'b1;
end

// gpiotest button logic block (sets LEDs based on counter bits XOR'd with
// corresponding button)
logic [4:0]     seq;    // 0 - 0x1f
assign          seq = counter[CNT_BITS-6+:5]; // use top 5 bits for gpio number
// NOTE: notation [r+:w] (r for right-most bit, w for bit width) means bits
// [r+w-1:r] e.g. [0+:8] is the same as [7:0]

always_ff @(posedge clk) begin
    gpio_23     <= 1'b0;
    gpio_25     <= 1'b0;
    gpio_26     <= 1'b0;
    gpio_27     <= 1'b0;
    gpio_32     <= 1'b0;
    gpio_35     <= 1'b0;
    gpio_31     <= 1'b0;
    gpio_37     <= 1'b0;
    gpio_34     <= 1'b0;
    gpio_43     <= 1'b0;
    gpio_36     <= 1'b0;
    gpio_42     <= 1'b0;
    gpio_38     <= 1'b0;
    gpio_28     <= 1'b0;
`ifndef OSC
    gpio_20     <= 1'b0;
`endif
    gpio_10     <= 1'b0;
    gpio_12     <= 1'b0;
    gpio_21     <= 1'b0;
    gpio_13     <= 1'b0;
    gpio_19     <= 1'b0;
    gpio_18     <= 1'b0;
    gpio_11     <= 1'b0;
    gpio_9      <= 1'b0;
    gpio_6      <= 1'b0;
    gpio_44     <= 1'b0;
    gpio_4      <= 1'b0;
    gpio_3      <= 1'b0;
    gpio_48     <= 1'b0;
    gpio_45     <= 1'b0;
    gpio_47     <= 1'b0;
    gpio_46     <= 1'b0;
    gpio_2      <= 1'b0;

    case (seq)
        5'h00:  gpio_23     <= 1'b1;
        5'h01:  gpio_25     <= 1'b1;
        5'h02:  gpio_26     <= 1'b1;
        5'h03:  gpio_27     <= 1'b1;
        5'h04:  gpio_32     <= 1'b1;
        5'h05:  gpio_35     <= 1'b1;
        5'h06:  gpio_31     <= 1'b1;
        5'h07:  gpio_37     <= 1'b1;
        5'h08:  gpio_34     <= 1'b1;
        5'h09:  gpio_43     <= 1'b1;
        5'h0A:  gpio_36     <= 1'b1;
        5'h0B:  gpio_42     <= 1'b1;
        5'h0C:  gpio_38     <= 1'b1;
        5'h0D:  gpio_28     <= 1'b1;
`ifndef OSC
        5'h0E:  gpio_20     <= 1'b1;
`endif
        5'h0F:  gpio_10     <= 1'b1;
        5'h10:  gpio_12     <= 1'b1;
        5'h11:  gpio_21     <= 1'b1;
        5'h12:  gpio_13     <= 1'b1;
        5'h13:  gpio_19     <= 1'b1;
        5'h14:  gpio_18     <= 1'b1;
        5'h15:  gpio_11     <= 1'b1;
        5'h16:  gpio_9      <= 1'b1;
        5'h17:  gpio_6      <= 1'b1;
        5'h18:  gpio_44     <= 1'b1;
        5'h19:  gpio_4      <= 1'b1;
        5'h1A:  gpio_3      <= 1'b1;
        5'h1B:  gpio_48     <= 1'b1;
        5'h1C:  gpio_45     <= 1'b1;
        5'h1D:  gpio_47     <= 1'b1;
        5'h1E:  gpio_46     <= 1'b1;
        5'h1F:  gpio_2      <= 1'b1;
        default:    ;
    endcase
end

endmodule
`default_nettype wire               // restore default for other modules
