<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesRawPhp
{
    protected function compilePhp($expression)
    {
        if ($expression) {
            return "<?php {$expression}; ?>";
        }

        return '%php';
    }

    protected function compileEval($expression)
    {
        if ($expression) {
            return "<?php {$expression}; ?>";
        }

        return '%eval';
    }

    protected function compileUnset($expression)
    {
        return "<?php unset{$expression}; ?>";
    }
}
