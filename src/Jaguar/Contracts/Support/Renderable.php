<?php

namespace Jaguar\Contracts\Support;

interface Renderable
{
  /**
   * Get the evaluated contents of this object.
   * @return string
   */
  public function render();
}
