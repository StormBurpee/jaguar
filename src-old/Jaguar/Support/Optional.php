<?php

namespace Jaguar\Support;

use ArrayAccess;
use ArrayObject;

class Optional implements ArrayAccess
{
    use Traits\Macroable {
    __call as macroCall;
  }

    protected $value;

    public function __construct($value)
    {
        $this->value = $value;
    }

    public function __get($key)
    {
        if (is_object($this->value)) {
            return $this->value->{$key} ?? null;
        }
    }

    public function __isset($name)
    {
        if (is_object($this->value)) {
            return isset($this->value->{$name});
        }

        if (is_array($this->value) || $this->value instanceof ArrayObject) {
            return isset($this->value[$name]);
        }

        return false;
    }

    public function offsetExists($key)
    {
        return Arr::accessible($this->value) && Arr::exists($this->value, $key);
    }

    public function offsetGet($key)
    {
        return Arr::get($this->value, $key);
    }

    public function offsetSet($key, $value)
    {
        if (Arr::accessible($this->value)) {
            $this->value[$key] = $value;
        }
    }

    public function offsetUnset($key)
    {
        if (Arr::accessible($this->key)) {
            unset($this->value[$key]);
        }
    }

    public function __call($method, $parameters)
    {
        if (static::hasMacro($method)) {
            return $this->macroCall($method, $parameters);
        }

        if (is_object($this->value)) {
            return $this->value->{$method}(...$parameters);
        }
    }
}
