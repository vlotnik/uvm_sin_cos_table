// tb_top.sv
`timescale 100ps/100ps

module tb_top;
    bit clk = 0;                                            // simple clock
    always #5 clk = ~clk;                                   // 100 MHz

//----------------------------------------------------------------------------------
// DUT connection
//----------------------------------------------------------------------------------
    sincos_if sincos_if_h(clk);                             // connect iclk to clk

    sin_cos_table #(
    )
    dut(
          .iCLK                     (sincos_if_h.iclk)
        , .iPHASE_V                 (sincos_if_h.iphase_v)
        , .iPHASE                   (sincos_if_h.iphase)
        , .oSINCOS_V                (sincos_if_h.osincos_v)
        , .oSIN                     (sincos_if_h.osin)
        , .oCOS                     (sincos_if_h.ocos)
    );

    import uvm_pkg::*;                                      // [UVM] package
    `include "uvm_macros.svh"                               // [UVM] macroses
    import sincos_package::*;                               // connect our package

    initial begin
        uvm_config_db #(virtual sincos_if)::set(            // [UVM] pass interface
            null, "*", "sincos_if_h", sincos_if_h);         //  to UVM database
        run_test("sincos_test_default");                    // [UVM] run test routine
    end

endmodule