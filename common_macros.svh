`ifndef uvm_object_new
    `define uvm_object_new \
        function new (string name=""); \
            super.new(name); \
        endfunction
`endif

`ifndef uvm_object_create
    `define uvm_object_create(_type_name_, _inst_name_, _id_ = 0) \
        _inst_name_ = _type_name_::type_id::create($sformatf({`"_inst_name_`", "_%0d"}, _id_));
`endif

`ifndef uvm_component_new
    `define uvm_component_new \
        function new (string name="", uvm_component parent=null); \
            super.new(name, parent); \
        endfunction
`endif

`ifndef uvm_component_create
    `define uvm_component_create(_type_name_, _inst_name_, _id_ = 0) \
        _inst_name_ = _type_name_::type_id::create($sformatf({`"_inst_name_`", "_%0d"}, _id_), this);
`endif