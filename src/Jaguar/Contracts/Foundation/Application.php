<?php

namespace Jaguar\Contracts\Foundation;

use Jaguar\Contracts\Container\Container;

interface Application extends Container
{
  public function version();

  public function basePath();

  public function environment();

  public function runningInConsole();

  public function runningUnitTests();

  public function isDownForMaintenance();

  public function registerConfiguredProviders();


}
