`timescale 1ns / 1ps


module uart_tx(
    input wire      clk,
    input [7:0]     data_in,
    input wire      tx_en, //trigger to send data
    output reg      tx, // uart transmit pin
    output reg      busy
    );
    
    // Parameters for baud rate and clock frequency
    parameter   BAUD_RATE = 9600;
    
    parameter   CLOCK_FREQ = 100000000; // 100 MHz system clock
    
    localparam  CLOCK_PER_BIT = CLOCK_FREQ / BAUD_RATE;
    
    localparam  STATE_IDLE=2'b00,
                STATE_START=2'b01,
                STATE_DATA=2'b10,
                STATE_STOP=2'b11;
           
    reg [13:0]  counter;
    reg [2:0]   bit_index;
    reg [7:0]   data_byte;    
    reg [1:0]   state;
    
    
    always@(posedge clk) begin
        case (state) 
            STATE_IDLE: begin
                tx <= 1'b1;                         //stop bit state, idle
                counter <= CLOCK_PER_BIT >> 1;      // start count from middle of the cycle
                busy <= 0;                          // indicate idle at the moment
                if (tx_en && !busy) begin           // if send trigger comes and not busy at the moment
                    data_byte <= data_in;           // load the input into data register
                    state <= STATE_START;           // proceed to next state
                    busy <= 1;                      // mark busy
                end else
                    state <= STATE_IDLE;            // back to idle state
             end
             STATE_START: begin
                tx <= 0;                            // start bit = 0
                if (counter > 0) begin
                    counter <= counter - 1;         // count until 0 to sample the middle of the cycle
                end else begin                      // when reached to middle 
                    counter <= CLOCK_PER_BIT - 1;   // set to the maximum clock value
                    state <= STATE_DATA;            // go to next state
                end  
             end
             STATE_DATA: begin                      // start data bit transmission
                tx <= data_byte[bit_index];         // put the respective bit in the data byte to the tx pin (transmit)
                if (counter > 0) begin              // wait for next clock cycle sample
                    counter <= counter - 1;
                end else begin 
                    counter <= CLOCK_PER_BIT - 1;   // now time to take sample
                    if (bit_index < 7) begin        // if data bits are not finished yet increment bit index
                        bit_index <= bit_index + 1;
                    end else begin                  // data bits finished 
                        bit_index <= 0;             // set bit index back to 0
                        state <= STATE_STOP;        // stop state
                    end
                end
              end
              STATE_STOP: begin
                tx <= 1;                            // set tx pin to idle or stop state 
                if (counter > 0)                    // wait one cycle
                    counter <= counter - 1;
                else begin
                    counter <= CLOCK_PER_BIT - 1;   // set the count back to max (not really necessary)
                    state <= STATE_IDLE;            // next state = idle
                    end
                end
        endcase
      end   
           
endmodule
