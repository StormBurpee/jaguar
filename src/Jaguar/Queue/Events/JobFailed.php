<?php

namespace Jaguar\Queue\Events;

class JobFailed
{
  public $connectioName;

  public $job;

  public $exception;

  public function __construct($connectionName, $job, $exception)
  {
    $this->job = $job;
    $this->exception = $exception;
    $this->connectionName = $connectionName;
  }
}
