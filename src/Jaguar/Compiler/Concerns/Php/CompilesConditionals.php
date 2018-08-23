<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesConditionals
{
    protected $firstCaseInSwitch = true;

    protected function compileIf($expression)
    {
        return "<?php if{$expression}: ?>";
    }

    protected function compileUnless($expression)
    {
        return "<?php if (! {$expression}): ?>";
    }

    protected function compileElseif($expression)
    {
        return "<?php elseif{$expression}: ?>";
    }

    protected function compileElse($expression)
    {
        return "<?php else: ?>";
    }

    protected function compileEndif()
    {
        return "<?php endif; ?>";
    }

    protected function compileEndunless()
    {
        return '<?php endif; ?>';
    }

    protected function compileIsset($expression)
    {
        return "<?php if(isset{$expression}): ?>";
    }

    protected function compileEndIsset()
    {
        return '<?php endif; ?>';
    }

    protected function compileSwitch($expression)
    {
        $this->firstCaseInSwitch = true;

        return "<?php switch{$expression}:>";
    }

    protected function compileCase($expression)
    {
        if ($this->firstCaseInSwitch) {
            $this->firstCaseInSwitch = false;

            return "case {$expression}: ?>";
        }

        return "<?php case {$expression}: ?>";
    }

    protected function compileDefault()
    {
        return '<?php default: ?>';
    }

    protected function compileEndSwitch()
    {
        return '<?php endswitch; ?>';
    }
}
