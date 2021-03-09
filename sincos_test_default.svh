// sincos_test_default.svh
class sincos_test_default extends uvm_test;                 // [UVM] class
    `uvm_component_utils(sincos_test_default)               // [UVM] macro
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);      // [UVM] build phase
    extern task run_phase(uvm_phase phase);                 // [UVM] run phase

    virtual sincos_if sincos_if_h;                          // virtual handler

    sincos_agnt                     sincos_agnt_h;
    sincos_seqc_default             sincos_seqc_default_h;
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function void sincos_test_default::build_phase(uvm_phase phase);
    // get bfm from database
    if (!uvm_config_db #(virtual sincos_if)::get(           // [UVM] try to get interface
        this, "", "sincos_if_h", sincos_if_h)               // from uvm database
    ) `uvm_fatal("BFM", "Failed to get bfm");               // otherwise throw error

    `uvm_component_create(sincos_agnt, sincos_agnt_h)
    sincos_agnt_h.sincos_if_h = this.sincos_if_h;

    `uvm_component_create(sincos_seqc_default, sincos_seqc_default_h)
endfunction

task sincos_test_default::run_phase(uvm_phase phase);
    phase.raise_objection(this);                            // [UVM] start sequence
        sincos_seqc_default_h.start(sincos_agnt_h.sincos_seqr_h);
    phase.drop_objection(this);                             // [UVM] finish sequence
endtask