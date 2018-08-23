<?php

namespace Jaguar\Contracts\Support;

interface MessageProvider
{
    /**
     * Get the messages for the instance.
     * @return \Jaguar\Contracts\Support\MessageBag
     */
    public function getMessageBag();
}
