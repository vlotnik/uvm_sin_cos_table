// sincos_scrb.svh
`uvm_analysis_imp_decl(_i)                                  // [UVM] macro
`uvm_analysis_imp_decl(_o)                                  // [UVM] macro

class sincos_scrb extends uvm_scoreboard;                   // [UVM] class
    `uvm_component_utils(sincos_scrb)                       // [UVM] macro
    `uvm_component_new

    extern function void build_phase(uvm_phase phase);      // [UVM] build phase

    uvm_analysis_imp_i #(sincos_seqi, sincos_scrb) sincos_aprt_i;
    uvm_analysis_imp_o #(sincos_seqi, sincos_scrb) sincos_aprt_o;

    sincos_seqi sincos_seqi_queue_i[$];
    sincos_seqi sincos_seqi_queue_o[$];

    extern virtual function void write_i(sincos_seqi sincos_seqi_h);
    extern virtual function void write_o(sincos_seqi sincos_seqi_h);

    extern function void processing();

    extern virtual function int get_ideal_sin(int phase, int max = (2 ** 15 - 1));
    extern virtual function int get_ideal_cos(int phase, int max = (2 ** 15 - 1));
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function void sincos_scrb::build_phase(uvm_phase phase);
    sincos_aprt_i = new("sincos_aprt_i", this);
    sincos_aprt_o = new("sincos_aprt_o", this);
endfunction

function void sincos_scrb::write_i(sincos_seqi sincos_seqi_h);
    sincos_seqi_queue_i.push_back(sincos_seqi_h);
endfunction

function void sincos_scrb::write_o(sincos_seqi sincos_seqi_h);
    sincos_seqi_queue_o.push_back(sincos_seqi_h);
    processing();
endfunction

function void sincos_scrb::processing();
    sincos_seqi sincos_seqi_i;
    sincos_seqi sincos_seqi_o;
    string data_str;

    sincos_seqi_i = sincos_seqi_queue_i.pop_front();
    sincos_seqi_i.sin = get_ideal_sin(sincos_seqi_i.phase);
    sincos_seqi_i.cos = get_ideal_cos(sincos_seqi_i.phase);

    sincos_seqi_o = sincos_seqi_queue_o.pop_front();
    sincos_seqi_o.phase = sincos_seqi_i.phase;

    data_str = {
            "\n", "actual:    ", sincos_seqi_o.convert2string(),
            "\n", "predicted: ", sincos_seqi_i.convert2string()
        };

    if (!sincos_seqi_i.compare(sincos_seqi_o))
        `uvm_error("FAIL", data_str)
    else
        `uvm_info("PASS", data_str, UVM_NONE)
endfunction

function int sincos_scrb::get_ideal_sin(int phase, int max = (2 ** 15 - 1));
    real c_pi = 3.1415926535897932384626433832795;
    real phase_r;
    real sin_r, sin_i, sin_floor;
    int sin_int;
    phase_r = $itor(phase) * 2.0 * c_pi / 4096.0;
    sin_r = $sin(phase_r);
    sin_i = sin_r * $itor(max);
    sin_floor = $floor(sin_i + 0.5);
    sin_int = $rtoi(sin_floor);
    return sin_int;
endfunction

function int sincos_scrb::get_ideal_cos(int phase, int max = (2 ** 15 - 1));

    real c_pi = 3.1415926535897932384626433832795;
    real phase_r;
    real cos_r, cos_i, cos_floor;
    int cos_int;
    phase_r = $itor(phase) * 2.0 * c_pi / 4096.0;
    cos_r = $cos(phase_r);
    cos_i = cos_r * $itor(max);
    cos_floor = $floor(cos_i + 0.5);
    cos_int = $rtoi(cos_floor);
    return cos_int;
endfunction