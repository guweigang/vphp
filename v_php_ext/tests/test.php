<?php
echo v_reverse_string("Hello World") . PHP_EOL;
try {
    v_reverse_string("");
} catch (Exception $e) {
    echo "Caught: " . $e->getMessage();
}
