<?php

namespace Jaguar\Contracts\Events;

interface Dispatcher
{
    /**
     * Register an event listener with the dispatcher.
     * @param  string|array $events
     * @param  mixed $listener
     * @return void
     */
    public function listen($events, $listener);

    /**
     * Determine if a given event has listeners.
     * @param  string  $eventName
     * @return bool
     */
    public function hasListeners($eventName);

    /**
     * Subscribe an event to the Dispatcher
     * @param  object|string $subscriber
     * @return void
     */
    public function subscribe($subscriber);

    /**
     * Dispatch an event until the first non-null response is returned
     * @param  string|object $event
     * @param  mixed  $payload
     * @return array|null
     */
    public function until($event, $payload = []);

    /**
     * Dispatch an event and call the listeners.
     * @param  object|string  $event
     * @param  mixed   $payload
     * @param  bool $halt
     * @return array|null
     */
    public function dispatch($event, $payload = [], $halt = false);


    /**
     * register an event and a payload that will be fired later.
     * @param  string $event
     * @param  array  $payload
     * @return void
     */
    public function push($event, $payload = []);

    /**
     * flush a set of events that are pushed
     * @param  string $event
     * @return void
     */
    public function flush($event);

    /**
     * Removes a set of listeners from the dispatcher
     * @param  string $event
     * @return void
     */
    public function forget($event);

    /**
     * Forgets all queued listeners.
     * @return void
     */
    public function forgetPushed();
}
