<?php

namespace Jaguar\Container;

use Closure;
use ArrayAccess;
use LogicException;
use ReflectionClass;
use ReflectionParameter;

use Jaguar\Contacts\Container\Container as ContainerContract;

class Container implements ArrayAccess, ContainerContract
{

  protected static $instance;

  protected $htmlResolved = [];

  protected $phpResolved = [];

  protected $htmlBindings = [];

  protected $phpBindings = [];

  protected $htmlMethodBindings = [];

  protected $phpMethodBindings = [];

  protected $htmlInstances = [];

  protected $phpInstances = [];

  protected $htmlAliases = [];

  protected $phpAliases = [];

  protected $abstractHtmlAliases = [];

  protected $abstractPhpAliases = [];

  protected $htmlExtenders = [];

  protected $phpExtenders = [];

  protected $htmlTags = [];

  protected $phpTags = [];

  protected $htmlBuildStack = [];

  protected $phpBuildStack = [];

  protected $htmlWith = [];

  protected $phpWith = [];

  public $htmlContextual = [];

  public $phpContextual = [];

  protected $htmlReboundCallbacks = [];

  protected $phpReboundCallbacks = [];

  protected $htmlGlobalResolvingCallbacks = [];

  protected $phpGlobalResolvingCallbacks = [];

  protected $htmlGlobalAfterResolvingCallbacks = [];

  protected $phpGlobalAfterResolvingCallbacks = [];

  protected $htmlResolvingCallbacks = [];

  protected $phpResolvingCallbacks = [];

  protected $afterHtmlResolvingCallbacks = [];

  protected $afterPhpResolvingCallbacks = [];

  public function htmlWhen($concrete)
  {
    return new ContextualBindingBuilder($this, $this->getHtmlAlias($concrete));
  }

  public function phpWhen($concrete)
  {
    return new ContextualBindingBuilder($this, $this->getPhpAlias($concrete));
  }

  public function boundHtml($abstract)
  {
    return isset($this->htmlBindings[$abstract]) ||
           isset($this->htmlInstances[$abstract]) ||
           $this->isHtmlAlias($abstract);
  }

  public function boundPhp($abstract)
  {
    return isset($this->phpBindings[$abstract]) ||
           isset($this->phpInstances[$abstract]) ||
           $this->isPhpAlias($abstract);
  }

  public function has($id)
  {
    return $this->boundHtml($id) ||
           $this->boundPhp($id);
  }

  public function htmlResolved($abstract)
  {
    if($this->isHtmlAlias($abstract)) {
      $abstract = $this->getHtmlAlias($abstract);
    }

    return isset($this->htmlResolved[$abstract]) ||
           isset($this->htmlInstances[$abstract]);
  }

  public function phpResolved($abstract)
  {
    if($this->isPhpAlias($abstract)) {
      $abstract = $this->getPhpAlias($abstract);
    }

    return isset($this->phpResolved[$abstract]) ||
           isset($this->phpInstances[$abstract]);
  }

  public function isHtmlShared($abstract)
  {
    return isset($this->htmlInstances[$abstract]) ||
           (isset($this->htmlBindings[$abstract]['shared']) &&
           $this->htmlBindings[$abstract]['shared'] === true);
  }

  public function isPhpShared($abstract)
  {
    return isset($this->phpInstances[$abstract]) ||
           (isset($this->phpBindings[$abstract]['shared']) &&
           $this->phpBindings[$abstract]['shared'] === true);
  }

  public function isHtmlAlias($name)
  {
    return isset($this->htmlAliases[$name]);
  }

  public function isPhpAlias($name)
  {
    return isset($this->phpAliases[$name]);
  }

  public function bindHtml($abstract, $concrete = null, $shared = false)
  {
    $this->dropStaleHtmlInstances($abstract);

    if(is_null($concrete)) {
      $concrete = $abstract;
    }

    if(! $concrete instanceof Closure) {
      $concrete = $this->getHtmlClosure($abstract, $concrete);
    }

    $this->htmlBindings[$abstract] = compact('concrete', 'shared');

    if($this->htmlResolved($abstract)) {
      $this->htmlRebound($abstract);
    }
  }

  public function bindPhp($abstract, $concrete = null, $shared = false)
  {
    $this->dropStalePhpInstances($abstract);

    if(is_null($concrete)) {
      $concrete = $abstract;
    }

    if(! $concrete instanceof Closure) {
      $concrete = $this->getPhpClosure($abstract, $concrete);
    }

    $this->phpBindings[$abstract] = compact('concrete', 'shared');

    if($this->phpResolved($abstract)) {
      $this->phpRebound($abstract);
    }
  }

  protected function getHtmlClosure($abstract, $concrete)
  {
    return function($container, $parameters = []) use ($abstract, $concrete) {
      if($abstract == $concrete) {
        return $container->htmlBuild($concrete);
      }

      return $container->htmlMake($concrete, $parameters);
    };
  }

  protected function getPhpClosure($abstract, $concrete)
  {
    return function($container, $parameters = []) use ($abstract, $concrete) {
      if($abstract == $concrete) {
        return $container->phpBuild($concrete);
      }

      return $container->phpMake($concrete, $parameters);
    };
  }

  public function hasHtmlMethodBinding($method)
  {
    return isset($this->htmlMethodBindings[$method]);
  }

  public function hasPhpMethodBinding($method)
  {
    return isset($this->phpMethodBindings[$method]);
  }

  public function bindHtmlMethod($method, $callback)
  {
    $this->htmlMethodBindings[$this->parseBindMethod($method)] = $callback;
  }

  public function bindPhpMethod($method, $callback)
  {
    $this->phpMethodBindings[$this->parseBindMethod($method)] = $callback;
  }

  protected function parseBindMethod($method)
  {
    if(is_array($method)) {
      return $method[0].'@'.$method[1];
    }

    return $method;
  }

  public function callHtmlMethodBinding($method, $instance)
  {
    return call_user_func($this->htmlMethodBindings[$method], $instance, $this);
  }

  public function callPhpMethodBinding($method, $instance)
  {
    return call_user_func($this->phpMethodBindings[$method], $instance, $this);
  }

  public function addContextualHtmlBinding($concrete, $abstract, $implementation)
  {
    $this->htmlContextual[$concrete][$this->getHtmlAlias($abstract)] = $implementation;
  }

  public function addContextualPhpBinding($concrete, $abstract, $implementation)
  {
    $this->phpContextual[$concrete][$this->getPhpAlias($abstract)] = $implementation;
  }

  public function bindHtmlIf($abstract, $concrete = null, $shared = false)
  {
    if(! $this->boundHtml($abstract)) {
      $this->bindHtml($abstract, $concrete, $shared);
    }
  }

  public function bindPhpIf($abstract, $concrete = null, $shared = false)
  {
    if(! $this->boundPhp($abstract)) {
      $this->bindPhp($abstract, $concrete, $shared);
    }
  }

  public function htmlSingleton($abstract, $concrete = null)
  {
    $this->bindHtml($abstract, $concrete, true);
  }

  public function phpSingleton($abstract, $concrete = null)
  {
    $this->bindPhp($abstract, $concrete, true);
  }

  public function htmlExtend($abstract, Closure $closure)
  {
    $abstract = $this->getHtmlAlias($abstract);

    if(isset($this->htmlInstances[$abstract])) {
      $this->htmlInstances[$abstract] = $closure($this->htmlInstances[$abstract], $this);

      $this->htmlRebound($abstract);
    } else {
      $this->htmlExtenders[$abstract][] = $closure;

      if($this->htmlResolved($abstract)) {
        $this->htmlRebound($abstract);
      }
    }
  }

  public function phpExtend($abstract, Closure $closure)
  {
    $abstract = $this->getPhpAlias($abstract);

    if(isset($this->phpInstances[$abstract])) {
      $this->phpInstances[$abstract] = $closure($this->phpInstances[$abstract], $this);

      $this->phpRebound($abstract);
    } else {
      $this->phpExtenders[$abstract][] = $closure;

      if($this->phpResolved($abstract)) {
        $this->phpRebound($abstract);
      }
    }
  }

  public function htmlInstance($abstract, $instance)
  {
    $this->removeHtmlAbstractAlias($abstract);

    $isBound = $this->boundHtml($abstract);

    unset($this->htmlAliases[$abstract]);

    $this->htmlInstances[$abstract] = $instance;

    if($isBound) {
      $this->htmlRebound($abstract);
    }

    return $instance;
  }

  public function phpInstance($abstract, $instance)
  {
    $this->removePhpAbstractAlias($abstract);

    $isBound - $this->boundPhp($abstract);

    unset($this->phpAliases[$abstract]);

    $this->phpInstances[$abstract] = $instance;

    if($isBound) {
      $this->phpRebound($abstract);
    }

    return $instance;
  }

  protected function removeHtmlAbstractAlias($searched)
  {
    if(! isset($htis->htmlAliases[$searched])) {
      return;
    }

    foreach($this->abstractHtmlAliases as $abstract => $aliases) {
      foreach($aliases as $index => $alias) {
        if($alias == $searched) {
          unset($this->abstractHtmlAliases[$abstract][$index]);
        }
      }
    }
  }


  protected function removePhpAbstractAlias($searched)
  {
    if(! isset($htis->phpAliases[$searched])) {
      return;
    }

    foreach($this->abstractPhpAliases as $abstract => $aliases) {
      foreach($aliases as $index => $alias) {
        if($alias == $searched) {
          unset($this->abstractPhpAliases[$abstract][$index]);
        }
      }
    }
  }

  public function tagHtml($abstracts, $tags)
  {
    $tags = is_array($tags) ? $tags : array_slice(func_get_args(), 1);

    foreach($tags as $tag) {
      if(! isset($this->htmlTags[$tag])) {
        $this->htmlTags[$tag] = [];
      }

      foreach((array) $abstracts as $abstract) {
        $this->htmlTags[$tag][] = $abstract;
      }
    }
  }

  public function tagPhp($abstracts, $tags)
  {
    $tags = is_array($tags) ? $tags : array_slice(func_get_args(), 1);

    foreach($tags as $tag) {
      if(! isset($this->phpTags[$tag])) {
        $this->phpTags[$tag] = [];
      }

      foreach((array) $abstracts as $abstract) {
        $this->phpTags[$tag][] = $abstract;
      }
    }
  }

  public function taggedHtml($tag)
  {
    $results = [];

    if(isset($this->htmlTags[$tag])) {
      foreach($this->htmlTags[$tag] as $abstract) {
        $results[] = $this->htmlMake($abstract);
      }
    }

    return $results;
  }

  public function taggedPhp($tag)
  {
    $results = [];

    if(isset($this->phpTags[$tag])) {
      foreach($this->phpTags[$tag] as $abstract) {
        $results[] = $this->phpMake($abstract);
      }
    }

    return $results;
  }

  public function aliasHtml($abstract, $alias)
  {
    $this->htmlAliases[$alias] = $abstract;

    $this->abstractHtmlAliases[$abstract][] = $alias;
  }

  public function aliasPhp($abstract, $alias)
  {
    $this->phpAliases[$alias] = $abstract;

    $this->abstractPhpAliases[$abstract][] = $alias;
  }

  public function rebindingHtml($abstract, Closure $callback)
  {
    $this->htmlReboundCallbacks[$abstract = $this->getHtmlAlias($abstract)][] = $callback;

    if($this->boundHtml($abstract)) {
      return $this->htmlMake($abstract);
    }
  }

  public function rebindingPhp($abstract, Closure $callback)
  {
    $this->phpReboundCallbacks[$abstract = $this->getPhpAlias($abstract)][] = $callback;

    if($this->boundPhp($abstract)) {
      return $this->phpMake($abstract);
    }
  }

  public function refreshHtml($abstract, $target, $method)
  {
    return $this->rebindingHtml($abstract, function($app, $instance) use ($target, $method) {
      $target->{$method}($instance);
    });
  }

  public function refreshPhp($abstract, $target, $method)
  {
    return $this->rebindingPhp($abstract, function($app, $instance) use ($target, $method) {
      $target->{$method}($instance);
    });
  }

  public function htmlRebound($abstract)
  {
    $instance = $this->htmlMake($abstract);

    foreach($this->getHtmlReboundCallbacks($abstract) as $callback) {
      call_user_func($callback, $this, $instance);
    }
  }

  public function phpRebound($abstract)
  {
    $instance = $this->phpMake($abstract);

    foreach($this->getPhpReboundCallbacks($abstract) as $callback) {
      call_user_func($callback, $this, $instance);
    }
  }

  protected function getHtmlReboundCallbacks($abstract)
  {
    if(isset($this->htmlReboundCallbacks[$abstract])) {
      return $this->htmlReboundCallbacks[$abstract];
    }

    return [];
  }

  protected function getPhpReboundCallbacks($abstract)
  {
    if(isset($this->phpReboundCallbacks[$abstract])) {
      return $this->phpReboundCallbacks[$abstract];
    }

    return [];
  }

}
