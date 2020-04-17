// sincos_if.sv
interface sincos_if (input bit iclk);
    bit                             iphase_v;
    bit[11:0]                       iphase;
    bit                             osincos_v;
    bit[15:0]                       osin;
    bit[15:0]                       ocos;
endinterface