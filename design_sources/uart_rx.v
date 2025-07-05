`timescale 1ns / 1ps

module uart_rx(
        input clk,
        input rx,       //uart rx input
        output reg[7:0] data_out,
        output reg data_ready
    );
    
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 100000000;                       // 100 MHZ
    
    localparam CLOCK_PER_BIT = CLOCK_FREQ / BAUD_RATE;      
    
    localparam STATE_IDLE = 2'b00,
               STATE_START = 2'b01,
               STATE_DATA = 2'b10,
               STATE_STOP = 2'b11;
    
    reg [1:0] state;                                        // state register
    reg [13:0] counter;                                     
    reg [2:0] bit_index;                    
    reg [7:0] shift_reg;
    
    // STATE MACHINE
    
    always@(posedge clk) begin
            case (state)
                STATE_IDLE: begin
                    data_ready <= 0;                        // data not ready since idle state
                    if (rx == 0) begin                      // rx = 0 indicates start (since bit 1 means idle)
                        counter <= CLOCK_PER_BIT >> 1;      // to sample from middle
                        state <= STATE_START;               // next state
                        end  
                end
                STATE_START: begin
                    if (counter > 0) begin                  // wait for the middle to sample
                        counter <= counter - 1;
                    end else begin
                        if (rx == 0) begin                  // if still rx = 0
                            counter <= CLOCK_PER_BIT - 1;   // set counter to max for next clock cycle sample
                            bit_index <= 0;                 // bit index = 0
                            state <= STATE_DATA;            // go to data state
                        end else begin
                            state <=  STATE_IDLE;           // FALSE START
                        end
                    end
                end
                STATE_DATA: begin
                    if (counter > 0) begin                  // one clock cycle wait
                        counter <= counter - 1;
                    end else begin                          // wait ends
                        shift_reg[bit_index] <= rx;         // put the incoming bit in shift register
                        counter <= CLOCK_PER_BIT - 1;       // set counter back to max
                        if (bit_index < 7)                  // if bit index not yet max increment
                            bit_index <= bit_index + 1;
                        else                                // last bit of the data is received =>move to stop state
                            state <= STATE_STOP;
                        end
                end
                STATE_STOP: begin
                    if (counter > 0) begin                  // wait one clock cycle
                        counter <= counter - 1;
                    end else begin
                        state <= STATE_IDLE;                // time for idle state
                        if (rx == 1) begin                     
                            data_out <= shift_reg;          // data out is given here
                            data_ready <= 1;                // data_ready flag is also set to 1
                        end  
                    end
                end   
            endcase
        end 
    
endmodule