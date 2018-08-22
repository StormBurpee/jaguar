<?php

namespace Jaguar\Compiler\View\Engines;

use Closure;
use InvalidArgumentException;

class EngineResolver
{
  /**
   * The array of engine resolvers
   * @var array
   */
  protected $resolvers = [];

  /**
   * Array of resolved engine instances
   * @var array
   */
  protected $resolved = [];

  /**
   * Register a new engine resolver.
   * The engine string typically corresponds to a file extension.
   * @param  string  $engine
   * @param  \Closure $resolver
   * @return void
   */
  public function register($engine, Closure $resolver)
  {
    unset($this->resolved[$engine]);

    $this->resolvers[$engine] = $resolver;
  }

  /**
   * Resolves an engine by it's instance name
   * @param  string $engine
   * @return \Jaguar\Contracts\Compiler\View\Engine
   * @throws \InvalidArgumentException
   */
  public function resolve($engine)
  {
    if(isset($this->resolved[$engine])) {
      return $this->resolved[$engine];
    }

    if(isset($this->resolvers[$engine])) {
      return $this->resolved[$engine] = call_user_func($this->resolvers[$engine]);
    }

    throw new InvalidArgumentException("Engine [{$engine}] not found.");
  }

}
