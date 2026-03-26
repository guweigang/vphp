module linker

import compiler.repr

fn uniq_non_empty(values []string) []string {
	mut out := []string{}
	mut seen := map[string]bool{}
	for v in values {
		name := v.trim_space()
		if name == '' || name in seen {
			continue
		}
		seen[name] = true
		out << name
	}
	return out
}

pub fn link_class_interfaces(mut elements []repr.PhpRepr) ! {
	mut interface_map := map[string]string{}
	for el in elements {
		if el is repr.PhpInterfaceRepr {
			interface_map[el.name] = el.php_name
			interface_map[el.php_name] = el.php_name
		}
	}

	for i in 0 .. elements.len {
		mut el := elements[i]
		if mut el is repr.PhpClassRepr {
			mut all_ifaces := []string{}
			mut internal_ifaces := []string{}
			mut auto_ifaces := []string{}
			for iface_name in el.implements_v {
				if iface_name !in interface_map {
					return error('class `${el.name}` implements unknown PHP interface `${iface_name}`')
				}
				php_iface := interface_map[iface_name]
				all_ifaces << php_iface
				internal_ifaces << php_iface
			}
			for iface_name in el.implements_attr {
				if iface_name in interface_map {
					php_iface := interface_map[iface_name]
					all_ifaces << php_iface
					internal_ifaces << php_iface
				} else {
					// Treat attribute strings as PHP-side interface names directly.
					all_ifaces << iface_name
					auto_ifaces << iface_name
				}
			}
			el.implements = uniq_non_empty(all_ifaces)
			el.internal_implements = uniq_non_empty(internal_ifaces)
			el.auto_interface_bindings = uniq_non_empty(auto_ifaces)
			elements[i] = el
		}
	}
}

pub fn link_interface_parents(mut elements []repr.PhpRepr) ! {
	mut interface_map := map[string]string{}
	for el in elements {
		if el is repr.PhpInterfaceRepr {
			interface_map[el.name] = el.php_name
		}
	}

	for i in 0 .. elements.len {
		mut el := elements[i]
		if mut el is repr.PhpInterfaceRepr {
			mut all_parents := []string{}
			for parent_name in el.extends_attr {
				if parent_name in interface_map {
					all_parents << interface_map[parent_name]
				} else {
					all_parents << parent_name
				}
			}
			el.extends = uniq_non_empty(all_parents)
			elements[i] = el
		}
	}
}
