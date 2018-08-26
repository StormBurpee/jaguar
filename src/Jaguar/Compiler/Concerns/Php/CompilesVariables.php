<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesVariables
{
    protected function compileSet($value)
    {
        $pattern = '/(?<!\w)(\s*)\(\s*\${0,1}[\'"\s]*(.*?)[\'"\s]*,\s*([\W\w^]*?)\)\s*$/m';
        return preg_replace_callback($pattern, function ($matches) {
            return "<?php $".$matches[2]." = " . $matches[3] . "; ?>";
        }, $value);
    }

    protected function compileUnset($value)
    {
        $pattern = '/(?<!\w)(\s*)\s*\(\s*\${0,1}[\'"\s]*(.*?)\)\s*/';
        return preg_replace_callback($pattern, function($matches) {
          return "<?php unset($".$matches[2]."); ?>";
        }, $value);
    }
}
