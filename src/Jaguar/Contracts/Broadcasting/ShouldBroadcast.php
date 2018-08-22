<?php

namespace Jaguar\Contracts\Broadcasting;

interface ShouldBroadcast
{
  /**
   * Get the channels the event should broadcast on.
   * @return \Jaguar\Broadcasting\Channel|\Jaguar\Broadcasting\Channel[]
   */
  public function broadcastOn();
}
