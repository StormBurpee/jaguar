<?php

namespace Jaguar\Compiler\View;

use Jaguar\Support\Arr;
use Jaguar\Support\Str;
use InvalidArgumentException;
use Jaguar\Contracts\Events\Dispatcher;
use Jaguar\Contracts\Support\Arrayable;
use Jaguar\Compiler\View\Engines\EngineResolver;
use Jaguar\Contracts\Container\Container;
use Jaguar\Contracts\Compiler\View\Factory as FactoryContract;

class Factory implements FactoryContract
{
  protected $engines;

  protected $finder;

  protected $events;

  protected $container;

  protected $shared = [];

  protected $extensions = [
    '.jaguar' => 'jaguar',
    '.jag' => 'jaguar',
    'php' => 'php',
    'css' => 'file',
  ];

  protected $composers = [];

  protected $renderCount = 0;

  public function __construct(EngineResolver $engines, ViewFinderInterface $finder, Dispatcher $events)
  {
    $this->finder = $finder;
    $this->events = $events;
    $this->engines = $engines;

    $this->share('__env', $this);
  }

  public function file($path, $data = [], $mergeData = [])
  {
    $data = array_merge($mergeData, $this->parseData($data));

    return tap($this->viewInstance($path, $path, $data), function($view) {
      $this->callCreator($view);
    });
  }
}
