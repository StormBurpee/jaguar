<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesComments
{
    protected function compileComments($value)
    {
        $pattern = sprintf('/%s(.*?)%s/s', $this->commentTags[0], $this->commentTags[1]);

        return preg_replace($pattern, '', $value);
    }
}
