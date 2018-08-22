<?php

namespace Jaguar\Queue;

use Jaguar\Contracts\Queue\Job as JobContract;

trait InteractsWithQueue
{
  /**
   * The underlying queue job instance
   * @var \Jaguar\Contracts\Queue\Job
   */
  protected $job;

  public function attempts()
  {
    return $this->job ? $this->job->attempts() : 1;
  }

  public function delete()
  {
    if($this->job) {
      return $this->job->delete();
    }
  }

  public function fail($exception = null)
  {
    if($this->job) {
      FailingJob::handle($this->job->getConnectionName(), $this->job, $exception);
    }
  }

  public function release($delay = 0)
  {
    if($this->job) {
      return $this->job->release($delay);
    }
  }

  public function setJob(JobContract $job)
  {
    $this->job = $job;

    return $this;
  }
}
