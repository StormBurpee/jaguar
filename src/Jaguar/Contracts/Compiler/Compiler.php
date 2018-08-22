<?php

namespace Jaguar\Contracts\Compiler;

interface Compiler
{

  /**
  * Gets the path of a compiled view
  *
  * @param string $path
  * @return string
  */
  public function getCompiledPath($path);

  /**
  * Gets if a given view has expired
  *
  * @param string $path
  * @return bool
  */
  public function isExpired($path);

  /**
  * Compiles a view at the given path
  *
  * @param string $path
  * @return void
  */
  public function compile($path);

}
