foreach lib [glob ./*.lib] {
    read_lib $lib
    write_lib -format db -output [get_object_name [get_libs ]].db [get_object_name [get_libs ]]
    remove_lib -all
}