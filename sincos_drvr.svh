// sincos_drvr.svh
class sincos_drvr extends uvm_driver #(sincos_seqi);        // [UVM] class
    `uvm_component_utils(sincos_drvr)                       // [UVM] macro

    extern function new(string name, uvm_component parent);
    extern task run_phase(uvm_phase phase);                 // [UVM] run phase

    virtual sincos_if sincos_if_h;                          // our interface
    sincos_seqi sincos_seqi_h;                              // handler for transactions
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function sincos_drvr::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

task sincos_drvr::run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(sincos_seqi_h);         // [UVM] request new transaction

            foreach(sincos_seqi_h.phase_v[i]) begin
                @(posedge sincos_if_h.iclk)
                sincos_if_h.iphase_v <= sincos_seqi_h.phase_v[i];
                if (sincos_seqi_h.phase_v[i] == 1'b1)
                    sincos_if_h.iphase <= sincos_seqi_h.phase[11:0];
            end

        seq_item_port.item_done();                          // [UVM] finish transaction
    end
endtask