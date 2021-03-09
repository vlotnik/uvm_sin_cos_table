// sincos_seqc_default.svh
class sincos_seqc_default extends uvm_sequence #(sincos_seqi); // [UVM] class
    `uvm_object_utils(sincos_seqc_default);                 // [UVM] macro
    `uvm_object_new

    extern task body();

    sincos_seqi sincos_seqi_h;
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
task sincos_seqc_default::body();
    repeat(100) begin
        `uvm_object_create(sincos_seqi, sincos_seqi_h)
        start_item(sincos_seqi_h);                          // [UVM] start transaction
            assert(sincos_seqi_h.randomize());
        finish_item(sincos_seqi_h);                         // [UVM] finish transaction
    end
endtask