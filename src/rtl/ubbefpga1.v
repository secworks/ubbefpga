//======================================================================
//
// ubbefpga.v
// -----------
// Very simple Verilog core for performing blinkenlights.
//
// (c) 2016, 2017 Joachim Strömbergson.
//
//======================================================================

module ubbefpga(
                input wire          clk,
                input wire          reset_n,

                input wire          led_inc,
                output wire [7 : 0] led
                );


  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  parameter DELAY = 32'h0100000;


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  reg [31 : 0] delay_ctr_reg;
  reg [31 : 0] delay_ctr_new;

  reg [7 : 0]  led_reg;
  reg [7 : 0]  led_new;
  reg          led_we;


  //----------------------------------------------------------------
  // assignments to connect register to port.
  //----------------------------------------------------------------
  assign led = led_reg;


  //----------------------------------------------------------------
  // reg_update
  //----------------------------------------------------------------
  always @ (posedge clk or negedge reset_n)
    begin : reg_update
      if (!reset_n)
        begin
          delay_ctr_reg <= 32'h0;
          led_reg       <= 8'h0;
        end
      else
        begin
          delay_ctr_reg <= delay_ctr_new;

          if (led_we)
            led_reg <= led_new;
        end
    end // reg_update


  //----------------------------------------------------------------
  // delay counter logic
  //----------------------------------------------------------------
  always @*
    begin : delay_ctr
      if (delay_ctr_reg == DELAY)
        begin
          delay_ctr_new = 32'h0;
        end
      else
        delay_ctr_new = delay_ctr_reg + 1'b1;
    end


  //----------------------------------------------------------------
  // led_toggle
  //----------------------------------------------------------------
  always @*
    begin : led_toggle
      led_new = 8'h00;
      led_we  = 0;

      if (delay_ctr_reg == 32'h0)
        begin
          if (led_inc)
            begin
              led_new = led_reg + 1'b1;
              led_we  = 1;
            end
        end
    end

endmodule // ubbefpga

//======================================================================
// EOF ubbefpga.v
//======================================================================
