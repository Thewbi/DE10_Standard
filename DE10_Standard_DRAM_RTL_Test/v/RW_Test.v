module RW_Test (

    // input
    iCLK,
    iRST_n,
    iBUTTON,
    readdata,    
    
    // output
    write,
    writedata,
    read,    
    drv_status_pass,
    drv_status_fail,
    drv_status_test_complete,
    c_state,
    same
    
);

    parameter      ADDR_W             =     25;
    parameter      DATA_W             =     16;

    input                   iCLK;
    input                   iRST_n;
    input                   iBUTTON;

    output                  write;
    output [DATA_W-1:0]     writedata;
    output                  read;
    input  [DATA_W-1:0]     readdata;

    output                  drv_status_pass;
    output                  drv_status_fail;
    output                  drv_status_test_complete;
    output                  same;
    output [3:0]            c_state;

    //=======================================================
    //  Signal declarations
    //=======================================================

    reg  [1:0]              pre_button;
    reg                     trigger;
    reg  [3:0]              c_state;
    reg                     write, read;
    reg  [ADDR_W-1:0]       address;
    reg  [DATA_W-1:0]       writedata;
    reg  [4:0]              write_count;
    wire                    max_address;
    wire                    same;

    // max_address is the reduction of address. (Reduction means that the individual cells of the array are combined using the prefixed operator)
    assign max_address      = &address;
    assign same             = readdata == writedata;

    wire [31:0]             y0, y1, y2;
    wire [7:0]              z;
    wire [DATA_W-1:0]       y;
    reg  [31:0]             cal_data, clk_cnt;

    assign y0               = cal_data + {7'b0, address};
    assign y1               = { y0[15:0], y0[31:16] } ^ cal_data;
    assign y2               = y1 + cal_data;
    assign z                = y1[7:0] + y2[7:0];
    assign y                = { y2[28:22], z[7:5], y1[10:5] };

    // increment clock count
    always@(posedge iCLK)
      if (!iRST_n)
        clk_cnt <= 32'b0;
      else  
        clk_cnt <= clk_cnt + 32'b1;

    // This is the state machine for the test
    always @(posedge iCLK)
    begin
        if (!iRST_n)
            begin 
                pre_button <= 2'b11;
                trigger <= 1'b0;
                write_count <= 5'b0;
                c_state <= 4'b0;
                write <= 1'b0;
                read <= 1'b0;
                writedata <= 16'b0;
            end
        else
        begin
        
            // insert module input iBUTTON into pre_button[0]
            // override pre_button[1] by the old pre_button[0]
            pre_button <= {pre_button[0], iBUTTON};
            
            // trigger when the button goes from low (0) to high (1)
            // the button is inverted logic so this means trigger when the button is depressed
            trigger <= !pre_button[0] && pre_button[1];

            case (c_state)

                // idle - waiting for button press
                0 : begin
                        address <= {ADDR_W{1'b0}};

                        // trigger is 1 when the push button is pressed
                        if (trigger)
                            begin
                                // store the clk_cnt value at the button press into cal_data
                                // cal_data data is the basis for the computation of the value y0, y1, y2, z and y
                                cal_data <= clk_cnt;
                            
                                // to "write"
                                c_state  <= 1;                                
                            end
                    end

                // write
                1 : begin
                        // 8 cycles of write data??? 1000 == 8
                        if (write_count[3])
                            begin
                                write_count <= 5'b0;
                                
                                write <= 1'b1; // perform a write operation
                                
                                // here the testdata y is written into the SDRAM
                                // y is generated from the clock count during the button press 
                                // and some random computation formula
                                writedata <= y;
                                
                                // to "finish write one data"
                                c_state <= 2;
                            end
                        else
                            write_count <= write_count + 1'b1;
                    end
                
                // finish write one data
                2 : begin
                        write <= 1'b0;
                        
                        // to "finish write all (burst)"
                        c_state <= 3;
                    end

                // finish write all (burst) 
                3 : begin
                    // max_address is the AND-reduction of address.
                    // When the address has been incremented over all addresses, it arrives at 111111111...1
                    // and then max_address is AND-reduced to zero.
                    if (max_address)
                        begin
                            address     <= { ADDR_W{1'b0} };
                            
                            // to 10
                            c_state     <= 10;
                        end     
                    else // write the next data
                        begin
                            address     <= address + 1'b1;
                            c_state     <= 1;
                        end
                    end

                // to 11
                10 : c_state <= 11;

                // to 4
                11 : c_state <= 4;

                // read (read data back that was written earlier)
                4 : begin 
                        read <= 1;

                        if (!write_count[3])
                            write_count <= write_count + 1'b1;
                    
                        // to "latch read data"
                        c_state <= 5;
                    end
                
                // latch read data
                5 : begin
                        read <= 0;      // turn of read
                        writedata <= y; // write y

                        if (!write_count[3])
                            write_count <= write_count + 5'b1;

                        // to "finish compare one data"
                        c_state <= 6;
                    end
               
                // finish compare one data
                6 : begin
                        if (write_count[3])
                            begin
                                write_count <= 5'b0;
                                if (same)
                                    // data matches, to "finish compare all"
                                    c_state <= 7;
                                else
                                    // to endless loop in 8
                                    c_state <= 8;
                            end
                    else
                        write_count <= write_count + 1'b1;
                    end

                // finish compare all - increment the address
                7 : begin
                        if (max_address)
                            begin
                                address <= {ADDR_W{1'b0}};
                                
                                // to endless loop
                                c_state <= 9;
                            end
                        else // compare the next data
                            begin
                                address <= address + 1'b1;
                                
                                // to "read"
                                c_state <= 4;
                            end
                    end

                // endless loop in 8 ????????
                8 : c_state <= 8;

                // endless loop in 9 ????????
                9 : c_state <= 9;

                // back to idle
                default : c_state <= 0;

            endcase
        end
    end

    // test result
    assign drv_status_pass = (c_state == 9) ? 1 : 0;
    assign drv_status_fail = (c_state == 8) ? 1 : 0;
    assign drv_status_test_complete = drv_status_pass || drv_status_fail;

endmodule 