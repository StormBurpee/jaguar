<?php

namespace Jaguar\Contracts\Compiler\View;

interface Engine
{
    /**
     * Get the evaluated contents of the view
     * @param  string $path
     * @param  array  $data
     * @return string
     */
    public function get($path, array $data = []);
}
