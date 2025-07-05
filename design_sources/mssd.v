`timescale 1ns / 1ps

module mssd(
        input wire clk,
        input wire [31:0] value,
        input wire [7:0] dpValue,
        output wire [6:0] display,
        output wire DP,
        output wire [3:0] AN
    );
    
    reg [1:0] idx;
    reg [31:0] count = 0;
    
    assign AN = ~(4'b0001 << idx);
    assign DP = ~dpValue >> idx;
    
    always@(posedge clk) begin
        if(count == 100000) begin
            count <= 0;
            idx <= idx + 1;
        end else begin
            count <= count + 1;
        end
    end
    
    ssd ssd0(.value(value[idx*4 +: 4]),
        .display(display)
    );

    
    
    
endmodule
