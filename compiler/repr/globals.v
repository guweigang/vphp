module repr

pub struct PhpGlobalsRepr {
pub mut:
	name   string
	fields []PhpGlobalField
}

pub struct PhpGlobalField {
pub:
	name   string
	v_type string
}
