<?php

namespace Jaguar\Compiler;

use InvalidArgumentException;
use Jaguar\Support\Filesystem\Filesystem;

abstract class Compiler
{
  /**
   * The filesystem instance
   * @var \Jaguar\Support\Filesystem\Filesystem
   */
  protected $files;

  /**
   * The path for the compiled view.
   * @var string
   */
  protected $compilePath;

  /**
   * Create a new compiler instance.
   * @param \Jaguar\Support\Filesystem\Filesystem $files
   * @param string     $compilePath
   */
  public function __construct(Filesystem $files, $compilePath)
  {
    $this->files = $files;
    $this->compilePath = $compilePath;
  }
}
