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
		}
	}

	for i in 0 .. elements.len {
		mut el := elements[i]
		if mut el is repr.PhpClassRepr {
			mut all_ifaces := []string{}
			for iface_name in el.implements_v {
				if iface_name !in interface_map {
					return error('class `${el.name}` implements unknown PHP interface `${iface_name}`')
				}
				all_ifaces << interface_map[iface_name]
			}
			for iface_name in el.implements_attr {
				if iface_name in interface_map {
					all_ifaces << interface_map[iface_name]
				} else {
					// Treat attribute strings as PHP-side interface names directly.
					all_ifaces << iface_name
				}
			}
			el.implements = uniq_non_empty(all_ifaces)
			elements[i] = el
		}
	}
}
