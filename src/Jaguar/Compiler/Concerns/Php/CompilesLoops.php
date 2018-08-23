<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesLoops
{
  protected $forElseCounter = 0;

  protected function compileFor($expression)
  {
    return "<?php for{$expression}: ?>";
  }

  protected function compileForeach($expression)
  {
    return "<?php foreach{$expression}: ?>";
  }

  protected function compileBreak($expression)
  {
    if($expression) {
      preg_match('/\(\s*(-?\d+)\s*\)$/', $expression, $matches);

      return $matches ? '<?php break '.max(1, $matches[1]).'; ?>' : "<?php if{$expression} break; ?>";
    }

    return '<?php break; ?>';
  }

  protected function compileContinue($expression)
  {
    if ($expression) {
        preg_match('/\(\s*(-?\d+)\s*\)$/', $expression, $matches);

        return $matches ? '<?php continue '.max(1, $matches[1]).'; ?>' : "<?php if{$expression} continue; ?>";
    }

    return '<?php continue; ?>';
  }

  protected function compileEndfor()
  {
    return '<?php endfor; ?>';
  }

  protected function compileEndforeach()
  {
    return '<?php endforeach; ?>';
  }

  protected function compileWhile($expression)
  {
    return "<?php while{$expression}: ?>";
  }

  protected function compileEndwhile()
  {
    return '<?php endwhile; ?>';
  }
}
