module repr

pub struct PhpExtensionMeta {
pub mut:
	name        string
	version     string
	description string
	ini_entries map[string]string
}
