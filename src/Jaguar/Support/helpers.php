<?php

use Jaguar\Contracts\Support\Htmlable;

if (! function_exists('e')) {
    /**
     * Escape HTML Special characters in a string
     * @param  \Jaguar\Contracts\Support\Htmlable|string  $value
     * @param  bool $doubleEncode
     * @return string
     */
    function e($value, $doubleEncode = true)
    {
        if ($value instanceof Htmlable) {
            return $value->toHtml();
        }

        return htmlspecialchars($value, ENT_QUOTES, 'UTF-8', $doubleEncode);
    }
}
if(! function_exists('value')) {
  /**
   * Return the default value of the given value.
   *
   * @param  mixed  $value
   * @return mixed
   */
  function value($value)
  {
      return $value instanceof Closure ? $value() : $value;
  }
}
