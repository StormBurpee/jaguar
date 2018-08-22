<?php
use Jaguar\Support\Debug\Dumper;

if (! function_exists('dd')) {
    function dd(...$args)
    {
        foreach ($args as $x) {
            (new Dumper)->dump($x);
        }

        die(1);
    }
}
