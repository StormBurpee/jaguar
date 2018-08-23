<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesComponents
{
    protected function compileComponent($expression)
    {
        return "<?php \$__enc->startComponent{$expression}; ?>";
    }

    protected function compileEndComponent()
    {
        return '<?php echo $__env->renderComponent(); ?>';
    }

    protected function compileSlot($expression)
    {
        return "<?php \$__env->slot{$expression}; ?>";
    }

    protected function compileEndSlot()
    {
        return '<?php $__env->endSlot(); ?>';
    }
}
