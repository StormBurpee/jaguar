<?php

namespace Jaguar\Events;

use Jaguar\Container\Container;
use Jaguar\Contracts\Queue\Job;
use Jaguar\Queue\InteractsWithQueue;
use Jaguar\Contracts\Queue\ShouldQueue;

class CallQueuedListener implements ShouldQueue
{
  use InteractsWithQueue;
}
