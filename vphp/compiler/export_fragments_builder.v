module compiler

pub struct ExportFragments {
pub mut:
	declarations    []string
	implementations []string
	minit_lines     []string
	function_table  []FuncBuilder
}

pub fn (mut f ExportFragments) merge(other ExportFragments) {
	f.declarations << other.declarations
	f.implementations << other.implementations
	f.minit_lines << other.minit_lines
	f.function_table << other.function_table
}
