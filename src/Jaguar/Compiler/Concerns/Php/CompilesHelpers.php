<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesHelpers
{
  protected function compileDd($arguments)
  {
    return "<?php dd{$arguments}; ?>";
  }

  protected function compileDump($arguments)
  {
    return "<?php dd{$arguments}; ?>";
  }
}
