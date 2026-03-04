module config

pub fn get_flag(args []string, name string, default_value string) string {
	for i, a in args {
		if a == name && i + 1 < args.len {
			return args[i + 1]
		}
		prefix := '${name}='
		if a.starts_with(prefix) {
			return a.all_after(prefix)
		}
	}
	return default_value
}

pub fn has_flag(args []string, name string) bool {
	for a in args {
		if a == name || a.starts_with('${name}=') {
			return true
		}
	}
	return false
}

