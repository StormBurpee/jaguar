<?php
use Jaguar\Support\Arr;
use Jaguar\Support\Str;
use Jaguar\Support\Optional;
use Jaguar\Support\Debug\Dumper;
use Jaguar\Support\HigherOrderTapProxy;

if (! function_exists('dd')) {
    function dd(...$args)
    {
        foreach ($args as $x) {
            (new Dumper)->dump($x);
        }

        die(1);
    }
}

if (! function_exists('tap')) {
    /**
     * Call the given closure with the given value, and then return the value
     * @param  mixed $value
     * @param  callable|null $callback
     * @return mixed
     */
    function tap($value, $callback = null)
    {
        if (is_null($callback)) {
            return new HigherOrderTapProxy($value);
        }

        $callback($value);
        return $value;
    }
}
