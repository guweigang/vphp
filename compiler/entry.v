// vphp/compiler/entry.v
module compiler

import v.ast
import v.pref
import compiler.linker
import compiler.parser as cparser
import v.parser
import compiler.repr

pub struct Compiler {
pub:
	target_files []string
pub mut:
	ext_name        string
	ext_version     string
	ext_description string
	ini_entries     map[string]string
	globals_repr    repr.PhpGlobalsRepr
	elements        []repr.PhpRepr
	params_structs  map[string]repr.PhpParamsStruct
mut:
	table        &ast.Table
	pref_set     &pref.Preferences
	decl_modules map[string]string
}

pub fn new(target_files []string) Compiler {
	return Compiler{
		target_files: target_files
		ext_name:     ''
		table:        ast.new_table()
		pref_set:     pref.new_preferences()
	}
}

pub fn (mut c Compiler) compile() !string {
	mut all_stmts := []ast.Stmt{}

	for file in c.target_files {
		file_ast := parser.parse_file(file, mut c.table, .parse_comments, c.pref_set)
		if file_ast.errors.len > 0 {
			return error('AST 解析失败: ${file_ast.errors[0].message} in ${file}')
		}
		if c.ext_name == '' {
			if name, version, description, ini_entries := cparser.parse_extension_meta(file_ast,
				c.table)
			{
				c.ext_name = name
				c.ext_version = version
				c.ext_description = description
				c.ini_entries = ini_entries.clone()
			}
		}
		c.remember_decl_modules(file_ast.stmts, file_ast.mod.name)
		all_stmts << file_ast.stmts
	}

	if c.ext_name == '' {
		return error('无法在输入的文件中找到 ext_config 配置，请确保定义了 ExtensionConfig')
	}
	println('  - [Compiler] 识别到扩展名: ${c.ext_name}')
	field_types := cparser.collect_struct_field_types(all_stmts, c.table)
	params_structs := cparser.collect_params_structs(all_stmts, c.table, c.decl_modules)
	c.params_structs = params_structs.clone()
	resolved_borrowed := linker.resolve_borrowed_methods(all_stmts, c.table, field_types)
	method_return_types := linker.collect_method_return_types(all_stmts, c.table, field_types)

	// --- 第一阶段：扫描所有 Struct 定义 ---
	c.elements, c.globals_repr = cparser.parse_structural_elements(all_stmts, c.table,
		c.decl_modules)!

	// --- 第二阶段：扫描所有 Fn 定义 ---
	cparser.parse_behavioral_elements(all_stmts, c.table, c.decl_modules, mut c.elements,
		field_types, params_structs, resolved_borrowed, method_return_types)!

	linker.link_class_shadows(mut c.elements, c.table)
	linker.resolve_and_apply_borrow_returns(mut c.elements, all_stmts, c.table, field_types)
	linker.link_class_traits(mut c.elements)!
	linker.link_class_embeds(mut c.elements)!
	linker.link_class_parents(mut c.elements)!
	linker.validate_inherited_object_classes(c.elements)!
	linker.link_interface_parents(mut c.elements)!
	linker.link_class_interfaces(mut c.elements)!

	return c.ext_name
}

fn (mut c Compiler) remember_decl_modules(stmts []ast.Stmt, module_name string) {
	for stmt in stmts {
		key := cparser.decl_key(stmt)
		if key != '' {
			c.decl_modules[key] = module_name
		}
		short_key := cparser.decl_short_key(stmt)
		if short_key != '' {
			c.decl_modules[short_key] = module_name
		}
	}
}
