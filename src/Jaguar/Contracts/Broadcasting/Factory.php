<?php

namespace Jaguar\Contracts\Broadcasting;

interface Factory
{
    public function connection($name = null);
}
