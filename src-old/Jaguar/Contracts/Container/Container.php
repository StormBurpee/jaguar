<?php

namespace Jaguar\Contracts\Container;

use Closure;
use Psr\Container\ContainerInterface;

interface Container extends ContainerInterface
{
  /**
  * Determine if the given abstract type has been bound to a HTML Template Function.
  *
  * @param string $abstract
  * @return bool
  */
  public function boundHtml($abstract);

  /**
  * Determine if the given abstract type has been bound to a PHP Template Function.
  *
  * @param string $abstract
  * @return bool
  */
  public function boundPhp($abstract);

  public function aliasHtml($abstract, $alias);

  public function aliasPhp($abstract, $alias);

  public function tagHtml($abstracts, $tags);

  public function tagPhp($abstracts, $tags);

  public function taggedHtml($tag);

  public function taggedPhp($tag);

  public function bindHtml($abstract, $concrete = null, $shared = false);

  public function bindPhp($abstract, $concrete = null, $shared = false);

  public function bindHtmlIf($abstract, $concrete = null, $shared = false);

  public function bindPhpIf($abstract, $concrete = null, $shared = false);

  public function htmlSingleton($abstract, $concrete = null);

  public function phpSingleton($abstract, $concrete = null);

  public function htmlExtend($abstract, Closure $closure);

  public function phpExtend($abstract, Closure $closure);

  public function htmlInstance($abstract, $instance);

  public function phpInstance($abstract, $instance);

  public function htmlWhen($concrete);

  public function phpWhen($concrete);

  public function htmlFactory($abstract);

  public function phpFactory($abstract);

  public function htmlMake($abstract, array $parameters = []);

  public function phpMake($abstract, array $parameters = []);

  public function htmlCall($callback, array $parameters = [], $defaultMethod = null);

  public function phpCall($callback, array $parameters = [], $defaultMethod = null);

  public function htmlResolved($abstract);

  public function phpResolved($abstract);

  public function htmlResolving($abstract, Closure $callback = null);

  public function phpResolving($abstract, Closure $callback = null);

  public function afterHtmlResolving($abstract, Closure $callback = null);

  public function afterPhpResolving($abstract, Closure $callback = null);

}
