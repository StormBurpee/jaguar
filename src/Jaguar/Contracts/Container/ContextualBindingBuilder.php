<?php

namespace Jaguar\Contracts\Container;

interface ContextualBindingBuilder
{
  public function needs($abstract);

  public function give($implementation);
}
