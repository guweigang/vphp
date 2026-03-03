module linker

import compiler.repr

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
			el.implements = []string{}
			for iface_name in el.implements_v {
				if iface_name !in interface_map {
					return error('class `${el.name}` implements unknown PHP interface `${iface_name}`')
				}
				el.implements << interface_map[iface_name]
			}
			elements[i] = el
		}
	}
}
