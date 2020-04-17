// sincos_seqi.svh
class sincos_seqi extends uvm_sequence_item;                // [UVM] class
    `uvm_object_utils(sincos_seqi);                         // [UVM] macro

    extern function new(string name = "sincos_seqi");

    rand int phase_v[];
    rand int phase;
    int sin;
    int cos;

    constraint c_phase_v {
        foreach(phase_v[i])
            phase_v[i] inside {[0:1]};
        phase_v.size inside {[5:5]};
        phase_v.sum == 1;
    }

    constraint c_phase {
        phase inside{[0:4095]};
    }

    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string convert2string();
endclass

//----------------------------------------------------------------------------------
// IMPLEMENTATION
//----------------------------------------------------------------------------------
function sincos_seqi::new(string name = "sincos_seqi");
    super.new(name);
endfunction

function bit sincos_seqi::do_compare(uvm_object rhs, uvm_comparer comparer);
    sincos_seqi RHS;
    bit same;

    same = super.do_compare(rhs, comparer);                 // [UVM] call papa

    $cast(RHS, rhs);
    same = (phase == RHS.phase && sin == RHS.sin && cos == RHS.cos) && same;
    return same;
endfunction

function string sincos_seqi::convert2string();
    string s;
    s = $sformatf("phase = %6d; sin = %6d, cos = %6d", phase, sin, cos);
    return s;
endfunction
