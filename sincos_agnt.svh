// sincos_agnt.svh
class sincos_agnt extends uvm_agent;                        // [UVM] class
    `uvm_component_utils(sincos_agnt)                       // [UVM] macro

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);      // [UVM] build phase
    extern function void connect_phase(uvm_phase phase);    // [UVM] connect phase

    virtual sincos_if sincos_if_h;                          // our interface

    sincos_seqr                     sincos_seqr_h;
    sincos_drvr                     sincos_drvr_h;
    sincos_mont                     sincos_mont_h;
    sincos_scrb                     sincos_scrb_h;
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function sincos_agnt::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void sincos_agnt::build_phase(uvm_phase phase);
    sincos_seqr_h = uvm_sequencer #(sincos_seqi)::type_id::create("sincos_seqr_h", this);
    sincos_drvr_h = sincos_drvr::type_id::create("sincos_drvr_h", this);
    sincos_mont_h = sincos_mont::type_id::create("sincos_mont_h", this);
    sincos_scrb_h = sincos_scrb::type_id::create("sincos_scrb_h", this);

    sincos_drvr_h.sincos_if_h = this.sincos_if_h;
    sincos_mont_h.sincos_if_h = this.sincos_if_h;
endfunction

function void sincos_agnt::connect_phase(uvm_phase phase);
    sincos_drvr_h.seq_item_port.connect(sincos_seqr_h.seq_item_export);
    sincos_mont_h.sincos_aprt_i.connect(sincos_scrb_h.sincos_aprt_i);
    sincos_mont_h.sincos_aprt_o.connect(sincos_scrb_h.sincos_aprt_o);
endfunction