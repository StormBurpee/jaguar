<?php

namespace Jaguar\Extensions;

use Jaguar\Jaguar;

class Extensions
{
    /**
     * Registers a custom Compiler Directive.
     * @param  string   $name
     * @param  callable $handler
     * @return void
     */
    public static function registerCompilerDirective($name, callable $handler)
    {
        Jaguar::getInstance()->getCompiler()->directive($name, $handler);
    }

    /**
     * Registers a custom compiler html directive.
     * @param  string   $name
     * @param  callable $handler
     * @param  boolean  $block
     * @return void            
     */
    public static function registerCompilerHtmlDirective($name, callable $handler, $block = false)
    {
      Jaguar::getInstance()->getCompiler()->htmlDirective($name, $handler, $block);
    }
}
