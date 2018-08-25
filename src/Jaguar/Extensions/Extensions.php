<?php

namespace Jaguar\Extensions;

use Jaguar\Jaguar;

class Extensions
{
    public static function registerCompilerDirective($name, callable $handler)
    {
        Jaguar::getInstance()->getCompiler()->directive($name, $handler);
    }
}
