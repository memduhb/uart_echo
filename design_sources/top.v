`timescale 1ns / 1ps

module top(
        input wire          CLK100MHZ, 
        input wire          RsRx,
        output wire         RsTx,
        output wire [6:0]   seg,
        output wire [3:0]   an,
        output wire         dp
    );
    
    wire [7:0] data_received;
    wire data_ready;               
    wire [31:0] extended_data = {24'b0, data_received}; // FOR MSSD
    
    // UART receiver to get data from PC
    uart_rx uart_rx_inst (
        .clk(CLK100MHZ),
        .rx(RsRx),
        .data_out(data_received),
        .data_ready(data_ready)
    );
    
    // UART transmitter to transmit data to PC
    uart_tx uart_tx_inst (
        .clk(CLK100MHZ),
        .tx(RsTx),
        .data_in(data_received),
        .tx_en(data_ready),
        .busy()
    );
    
    // seven segment display for the received ascii values
    mssd mssd_inst (
        .clk(CLK100MHZ),
        .value(extended_data),
        .dpValue(8'b00000000),
        .display(seg),
        .DP(dp),
        .AN(an)
    );
    
endmodule