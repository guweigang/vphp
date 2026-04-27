module vphp

pub struct PhpNull {
	value RequestBorrowedZBox
}

pub struct PhpBool {
	value RequestBorrowedZBox
}

pub struct PhpInt {
	value RequestBorrowedZBox
}

pub struct PhpDouble {
	value RequestBorrowedZBox
}

pub struct PhpString {
	value RequestBorrowedZBox
}

pub struct PhpScalar {
	value RequestBorrowedZBox
}

pub fn PhpNull.from_zval(z ZVal) ?PhpNull {
	if !z.is_null() && !z.is_undef() {
		return none
	}
	return PhpNull{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpNull.must_from_zval(z ZVal) !PhpNull {
	value := PhpNull.from_zval(z) or { return error('zval is not null') }
	return value
}

pub fn PhpNull.value() PhpNull {
	return PhpNull{
		value: RequestBorrowedZBox.from_zval(ZVal.new_null())
	}
}

pub fn (v PhpNull) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpNull) to_request_owned() RequestOwnedZBox {
	return RequestOwnedZBox.new_null()
}

pub fn (v PhpNull) to_persistent() PersistentPhpValue {
	return PersistentPhpValue.null_value()
}

pub fn (v PhpNull) to_dyn() DynValue {
	return DynValue.null()
}

pub fn PhpBool.from_zval(z ZVal) ?PhpBool {
	if !z.is_bool() {
		return none
	}
	return PhpBool{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpBool.must_from_zval(z ZVal) !PhpBool {
	value := PhpBool.from_zval(z) or { return error('zval is not bool') }
	return value
}

pub fn PhpBool.coerce(z ZVal) PhpBool {
	result := php_fn('boolval').call([z])
	return PhpBool{
		value: RequestBorrowedZBox.from_zval(result)
	}
}

pub fn PhpBool.of(value bool) PhpBool {
	return PhpBool{
		value: RequestBorrowedZBox.from_zval(ZVal.new_bool(value))
	}
}

pub fn PhpBool.true_value() PhpBool {
	return PhpBool.of(true)
}

pub fn PhpBool.false_value() PhpBool {
	return PhpBool.of(false)
}

pub fn (v PhpBool) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpBool) value() bool {
	return v.to_zval().to_bool()
}

pub fn (v PhpBool) to_dyn() DynValue {
	return DynValue.of_bool(v.value())
}

pub fn PhpInt.from_zval(z ZVal) ?PhpInt {
	if !z.is_long() {
		return none
	}
	return PhpInt{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpInt.must_from_zval(z ZVal) !PhpInt {
	value := PhpInt.from_zval(z) or { return error('zval is not int') }
	return value
}

pub fn PhpInt.coerce(z ZVal) PhpInt {
	result := php_fn('intval').call([z])
	return PhpInt{
		value: RequestBorrowedZBox.from_zval(result)
	}
}

pub fn PhpInt.of(value i64) PhpInt {
	return PhpInt{
		value: RequestBorrowedZBox.from_zval(ZVal.new_int(value))
	}
}

pub fn PhpInt.zero() PhpInt {
	return PhpInt.of(0)
}

pub fn (v PhpInt) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpInt) value() i64 {
	return v.to_zval().to_i64()
}

pub fn (v PhpInt) to_int() int {
	return v.to_zval().to_int()
}

pub fn (v PhpInt) to_dyn() DynValue {
	return DynValue.of_int(v.value())
}

pub fn PhpDouble.from_zval(z ZVal) ?PhpDouble {
	if !z.is_double() {
		return none
	}
	return PhpDouble{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpDouble.must_from_zval(z ZVal) !PhpDouble {
	value := PhpDouble.from_zval(z) or { return error('zval is not double') }
	return value
}

pub fn PhpDouble.coerce(z ZVal) PhpDouble {
	result := php_fn('floatval').call([z])
	return PhpDouble{
		value: RequestBorrowedZBox.from_zval(result)
	}
}

pub fn PhpDouble.of(value f64) PhpDouble {
	return PhpDouble{
		value: RequestBorrowedZBox.from_zval(ZVal.new_float(value))
	}
}

pub fn PhpDouble.zero() PhpDouble {
	return PhpDouble.of(0.0)
}

pub fn (v PhpDouble) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpDouble) value() f64 {
	return v.to_zval().to_f64()
}

pub fn (v PhpDouble) to_dyn() DynValue {
	return DynValue.of_float(v.value())
}

pub fn PhpString.from_zval(z ZVal) ?PhpString {
	if !z.is_string() {
		return none
	}
	return PhpString{
		value: RequestBorrowedZBox.from_zval(z)
	}
}

pub fn PhpString.must_from_zval(z ZVal) !PhpString {
	value := PhpString.from_zval(z) or { return error('zval is not string') }
	return value
}

pub fn PhpString.coerce(z ZVal) PhpString {
	return PhpString{
		value: RequestBorrowedZBox.from_zval(ZVal.new_string(z.to_string()))
	}
}

pub fn PhpString.of(value string) PhpString {
	return PhpString{
		value: RequestBorrowedZBox.from_zval(ZVal.new_string(value))
	}
}

pub fn PhpString.empty() PhpString {
	return PhpString.of('')
}

pub fn (v PhpString) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpString) value() string {
	return v.to_zval().to_string()
}

pub fn (v PhpString) len() int {
	return v.value().len
}

pub fn (v PhpString) to_dyn() DynValue {
	return DynValue.of_string(v.value())
}

pub fn PhpScalar.from_zval(z ZVal) ?PhpScalar {
	if !z.is_valid() || z.is_undef() || z.is_null() || z.is_bool() || z.is_long() || z.is_double()
		|| z.is_string() {
		return PhpScalar{
			value: RequestBorrowedZBox.from_zval(z)
		}
	}
	return none
}

pub fn PhpScalar.must_from_zval(z ZVal) !PhpScalar {
	value := PhpScalar.from_zval(z) or { return error('zval is not scalar') }
	return value
}

pub fn (v PhpScalar) to_zval() ZVal {
	return v.value.to_zval()
}

pub fn (v PhpScalar) type_name() string {
	return v.to_zval().type_name()
}

pub fn (v PhpScalar) is_null() bool {
	return v.to_zval().is_null() || v.to_zval().is_undef()
}

pub fn (v PhpScalar) is_bool() bool {
	return v.to_zval().is_bool()
}

pub fn (v PhpScalar) is_int() bool {
	return v.to_zval().is_long()
}

pub fn (v PhpScalar) is_double() bool {
	return v.to_zval().is_double()
}

pub fn (v PhpScalar) is_string() bool {
	return v.to_zval().is_string()
}

pub fn (v PhpScalar) to_bool() bool {
	return PhpBool.coerce(v.to_zval()).value()
}

pub fn (v PhpScalar) to_i64() i64 {
	return PhpInt.coerce(v.to_zval()).value()
}

pub fn (v PhpScalar) to_int() int {
	return int(v.to_i64())
}

pub fn (v PhpScalar) to_f64() f64 {
	return PhpDouble.coerce(v.to_zval()).value()
}

pub fn (v PhpScalar) to_string() string {
	return v.to_zval().to_string()
}

pub fn (v PhpScalar) to_dyn() DynValue {
	z := v.to_zval()
	if !z.is_valid() || z.is_undef() || z.is_null() {
		return DynValue.null()
	}
	if z.is_bool() {
		return DynValue.of_bool(z.to_bool())
	}
	if z.is_long() {
		return DynValue.of_int(z.to_i64())
	}
	if z.is_double() {
		return DynValue.of_float(z.to_f64())
	}
	return DynValue.of_string(z.to_string())
}
