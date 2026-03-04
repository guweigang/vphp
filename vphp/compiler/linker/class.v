module linker

import v.ast
import compiler.repr

fn is_php_trait_class(el repr.PhpRepr) bool {
	return el is repr.PhpClassRepr && el.is_trait
}

fn is_php_exported_class(el repr.PhpRepr) bool {
	return el is repr.PhpClassRepr && !el.is_trait
}

fn has_property_named(props []repr.PhpClassProp, name string) bool {
	return props.any(it.name == name)
}

fn has_method_named(methods []repr.PhpMethodRepr, name string, is_static bool) bool {
	return methods.any(it.name == name && it.is_static == is_static)
}

pub fn link_class_shadows(mut elements []repr.PhpRepr, table &ast.Table) {
	for i in 0 .. elements.len {
		mut el := elements[i]
		if mut el is repr.PhpClassRepr {
			link_class_shadow_statics(mut el, elements, table)
			link_class_shadow_constants(mut el, elements)
			elements[i] = el
		}
	}
}

pub fn link_class_embeds(mut elements []repr.PhpRepr) ! {
	mut class_map := map[string]string{}
	for el in elements {
		if is_php_exported_class(el) {
			cls := el as repr.PhpClassRepr
			class_map[cls.name] = cls.php_name
		}
	}

	for i in 0 .. elements.len {
		mut el := elements[i]
		if mut el is repr.PhpClassRepr {
			if el.is_trait {
				elements[i] = el
				continue
			}
			if el.parent != '' || el.embeds_v.len == 0 {
				elements[i] = el
				continue
			}

			mut embedded_php_classes := []string{}
			for embed_name in el.embeds_v {
				if embed_name in class_map {
					embedded_php_classes << class_map[embed_name]
				}
			}

			if embedded_php_classes.len > 1 {
				return error('class `${el.name}` embeds multiple `@[php_class]` structs; please declare `@[php_extends: ...]` explicitly')
			}

			if embedded_php_classes.len == 1 {
				el.parent = embedded_php_classes[0]
			}

			elements[i] = el
		}
	}
}

pub fn link_class_traits(mut elements []repr.PhpRepr) ! {
	mut trait_map := map[string]repr.PhpClassRepr{}
	for el in elements {
		if is_php_trait_class(el) {
			trait_repr := el as repr.PhpClassRepr
			trait_map[trait_repr.name] = trait_repr
		}
	}

	for i in 0 .. elements.len {
		mut el := elements[i]
		if mut el is repr.PhpClassRepr {
			if el.is_trait || el.embeds_v.len == 0 {
				elements[i] = el
				continue
			}
			for embed_name in el.embeds_v {
				if embed_name !in trait_map {
					continue
				}
				trait_repr := trait_map[embed_name]
				for prop in trait_repr.properties {
					if prop.is_static {
						continue
					}
					// Match PHP trait resolution: the outer class wins on conflicts.
					if has_property_named(el.properties, prop.name) {
						continue
					}
					el.properties << prop
				}
				for method in trait_repr.methods {
					// Match PHP trait resolution: the consuming class keeps its own method.
					if has_method_named(el.methods, method.name, method.is_static) {
						continue
					}
					el.methods << method
				}
			}
			elements[i] = el
		}
	}
}

fn link_class_shadow_statics(mut cls repr.PhpClassRepr, elements []repr.PhpRepr, table &ast.Table) {
	if cls.shadow_static_name == '' {
		return
	}
	for el in elements {
		if el is repr.PhpConstRepr && el.name == cls.shadow_static_name {
			cls.shadow_static_type = el.v_type
			mut typ := table.find_type(cls.shadow_static_type)
			if typ == 0 {
				typ = table.find_type('main.' + cls.shadow_static_type)
			}
			if typ != 0 {
				sym := table.sym(typ)
				sym_info := sym.info
				if sym_info is ast.Struct {
					for field in sym_info.fields {
						cls.properties << repr.PhpClassProp{
							name: field.name
							v_type: table.get_type_name(field.typ)
							visibility: 'public'
							is_static: true
							is_mut: true
						}
					}
				}
			}
			break
		}
	}
}

fn link_class_shadow_constants(mut cls repr.PhpClassRepr, elements []repr.PhpRepr) {
	if cls.shadow_const_name == '' {
		return
	}
	for el in elements {
		if el is repr.PhpConstRepr && el.name == cls.shadow_const_name {
			cls.shadow_const_type = el.v_type
			for f_name, sub_con in el.fields {
				cls.constants << repr.PhpClassConst{
					name: sub_con.name
					v_field_name: f_name
					value: sub_con.value
					const_type: sub_con.const_type
				}
			}
			break
		}
	}
}
