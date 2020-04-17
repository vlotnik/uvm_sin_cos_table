// sincos_seqc_default.svh
class sincos_seqc_default extends uvm_sequence #(sincos_seqi); // [UVM] class
    `uvm_object_utils(sincos_seqc_default);                 // [UVM] macro

    extern function new(string name = "sincos_seqc_default");
    extern task body();

    sincos_seqi sincos_seqi_h;
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function sincos_seqc_default::new(string name = "sincos_seqc_default");
    super.new(name);
endfunction

task sincos_seqc_default::body();
    repeat(100) begin
        sincos_seqi_h = sincos_seqi::type_id::create("sincos_seqi_h");
        start_item(sincos_seqi_h);                          // [UVM] start transaction
            assert(sincos_seqi_h.randomize());
        finish_item(sincos_seqi_h);                         // [UVM] finish transaction
    end
endtask