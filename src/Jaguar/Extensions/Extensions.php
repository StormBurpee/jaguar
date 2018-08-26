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

    public static function registerCompilerAlias($alias, $original)
    {
        Jaguar::getInstance()->getCompiler()->alias($alias, $original);
    }

    public static function registerCompilerHtmlAlias($alias, $original)
    {
        Jaguar::getInstance()->getCompiler()->htmlAlias($alias, $original);
    }

    /**
     * Registers a custom block processor for HTML.
     * @param  string   $name
     * @param  callable $handler
     * @return void
     */
    public static function registerHtmlBlockProcessor($name, callable $handler)
    {
        Jaguar::getInstance()->getCompiler()->htmlBlockProcessor($name, $handler);
    }

    /**
     * Registers a custom conditional directive
     * @param  string   $name
     * @param  callable $handler
     * @return void
     */
    public static function registerIf($name, callable $handler)
    {
        Jaguar::getInstance()->getCompiler()->if($name, $handler);
    }
}
