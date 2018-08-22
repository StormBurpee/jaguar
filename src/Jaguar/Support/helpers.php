<?php
use Jaguar\Support\Arr;
use Jaguar\Support\Str;
use Jaguar\Support\Optional;
use Jaguar\Support\Debug\Dumper;
use Jaguar\Support\HigherOrderTapProxy;

if(! function_exists('e')) {
  /**
   * Escape HTML Special characters in a string
   * @param  \Jaguar\Contracts\Support\Htmlable|string  $value
   * @param  bool $doubleEncode
   * @return string
   */
  function e($value, $doubleEncode = true)
  {
    if($value instanceof Htmlable) {
      return $value->toHtml();
    }

    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8', $doubleEncode);
  }
}
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
