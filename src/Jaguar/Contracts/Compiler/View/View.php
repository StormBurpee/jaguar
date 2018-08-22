<?php

namespace Jaguar\Contracts\Compiler\View;

use Jaguar\Contracts\Support\Renderable;

interface View extends Renderable
{
  /**
   * Get the name of the view
   * @return string
   */
  public function name();

  /**
   * Add a piece of data to the view
   * @param  array|string $key
   * @param  mixed $value
   * @return $this        
   */
  public function with($key, $value = null);
}
