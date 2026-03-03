module compiler

pub struct GlobalConstantBuilder {
pub:
	name  string
	type_ string
	value string
}

pub fn new_global_constant_builder(name string, type_ string, value string) GlobalConstantBuilder {
	return GlobalConstantBuilder{
		name: name
		type_: type_
		value: value
	}
}

pub fn (b GlobalConstantBuilder) render_register() string {
	match b.type_ {
		'string' {
			return '    REGISTER_STRING_CONSTANT("${b.name}", "${b.value}", CONST_CS | CONST_PERSISTENT);'
		}
		'double', 'f64' {
			return '    REGISTER_DOUBLE_CONSTANT("${b.name}", ${b.value}, CONST_CS | CONST_PERSISTENT);'
		}
		'bool' {
			return '    REGISTER_BOOL_CONSTANT("${b.name}", ${b.value}, CONST_CS | CONST_PERSISTENT);'
		}
		else {
			return '    REGISTER_LONG_CONSTANT("${b.name}", ${b.value}, CONST_CS | CONST_PERSISTENT);'
		}
	}
}

pub fn (b GlobalConstantBuilder) export_fragments() ExportFragments {
	return ExportFragments{
		minit_lines: [b.render_register()]
	}
}
