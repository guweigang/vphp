module main

@[php_interface]
interface ContentContract {
	save() bool
	get_formatted_title() string
}
