# **FPGA UART Echo System**

This project implements a simple **UART Echo System** using Verilog on the **Basys 3** FPGA board. Receive data from PC via UART, display ASCII value in seven segment display and echo back to Tera Term or PuTTY.

## **Project Components**
- **Verilog Files**:
  - `uart_rx.v`: UART Receiver module to receive data from the PC.
  - `uart_tx.v`: UART Transmitter module to send data back to the PC.
  - `ssd.v` and `mssd.v`: 7-segment display decoder to convert hexadecimal values into signals for the display.
  - `top.v`: Top-level module to instantiate the UART receiver, UART transmitter, and 7-segment decoder.

- **Constraints Files**:
  - `Basys-3-Master.xdc`: The constraint file that maps FPGA pins to the 7-segment display and UART communication. Only seven segment and UART constraints used in this project. 

## **How to Use**
1. **Connect FPGA to PC**: 
   - Use the **USB-to-UART bridge** to connect the **Basys 3** FPGA to your PC.

2. **Setup a Serial Terminal**:
   - Open a **serial terminal** (e.g., **PuTTY** or **Tera Term**) on your PC.
   - Set the terminal to the correct **COM port** and **baud rate** (usually **9600** for this project).

3. **Send Data**:
   - Type any key on the PC's terminal.
   - The corresponding ASCII value of the key will be received by the FPGA, displayed on the 7-segment displays, and then sent back to the terminal (echoed).

## **Project Description**
- **UART Communication**: The FPGA listens for data sent over UART from the PC. Each byte received is processed and then echoed back to the PC.
- **7-Segment Display Output**: The byte received is displayed in its **hexadecimal form** on two **7-segment displays**. The upper nibble is shown on the first display, and the lower nibble is shown on the second display.

The comments in the receiver and transmitter are very explanatory please refer to them to understand the code. 
