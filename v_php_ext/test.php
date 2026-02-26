<?php
try {
    v_string_reverse("");
} catch (Exception $e) {
    echo "Caught: " . $e->getMessage();
}
