// sincos_mont.svh
class sincos_mont extends uvm_monitor;                      // [UVM] class
    `uvm_component_utils(sincos_mont);                      // [UVM] macro
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);      // [UVM] build phase
    extern task run_phase(uvm_phase phase);                 // [UVM] run phase

    virtual sincos_if               sincos_if_h;           // our interface

    sincos_aprt                     sincos_aprt_i;          // analysis port, input
    sincos_seqi                     sincos_seqi_i;          // transaction, input
    sincos_aprt                     sincos_aprt_o;          // analysis port, output
    sincos_seqi                     sincos_seqi_o;          // transaction, output
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function void sincos_mont::build_phase(uvm_phase phase);
    // build analysis ports
    sincos_aprt_i = new("sincos_aprt_i", this);
    sincos_aprt_o = new("sincos_aprt_o", this);
endfunction

task sincos_mont::run_phase(uvm_phase phase);
    forever @(posedge sincos_if_h.iclk) begin
        if (sincos_if_h.iphase_v == 1) begin
            `uvm_object_create(sincos_seqi, sincos_seqi_i)
            sincos_seqi_i.phase = sincos_if_h.iphase;
            sincos_aprt_i.write(sincos_seqi_i);             // [UVM] write to aprt
        end

        if (sincos_if_h.osincos_v == 1) begin
            `uvm_object_create(sincos_seqi, sincos_seqi_o)
            sincos_seqi_o.sin = $signed(sincos_if_h.osin);
            sincos_seqi_o.cos = $signed(sincos_if_h.ocos);
            sincos_aprt_o.write(sincos_seqi_o);             // [UVM] write to aprt
        end
    end
endtask