module vphp

// 这里可以放 ExtensionConfig 等定义
pub struct ExtensionConfig {
pub:
	name        string
	version     string
	description string
	ini_entries map[string]string
}
