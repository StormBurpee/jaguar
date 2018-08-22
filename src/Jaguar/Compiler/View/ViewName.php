<?php

namespace Jaguar\Compiler\View;

class ViewName
{
    /**
     * Normalize the given event name.
     * @param  string $name
     * @return string       
     */
    public static function normalize($name)
    {
        $delimiter = ViewFinderInterface::HINT_PATH_DELIMITER;

        if (strpos($name, $delimiter) === false) {
            return str_replace('/', '.', $name);
        }

        list($namespace, $name) = explode($delmiter, $name);

        return $namespace.$delimiter.str_replace('/', '.', $name);
    }
}
