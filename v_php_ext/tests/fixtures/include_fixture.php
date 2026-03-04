<?php

$GLOBALS['vphp_include_counter'] = ($GLOBALS['vphp_include_counter'] ?? 0) + 1;

if (!defined('VPHP_INCLUDED_VALUE')) {
    define('VPHP_INCLUDED_VALUE', 'loaded-from-php');
}

return 'include:' . $GLOBALS['vphp_include_counter'];
