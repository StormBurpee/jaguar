<?php

namespace Jaguar\Support;

use Jaguar\Contracts\Support\Htmlable;

class HtmlString implements Htmlable
{
    /**
     * The HTML String
     * @var string
     */
    protected $html;

    /**
     * Create a new HTML string instance
     * @param string $html
     * @return void
     */
    public function __construct($html)
    {
        $this->html = $html;
    }

    /**
     * Get the HTML string
     * @return string
     */
    public function toHtml()
    {
        return $this->html;
    }

    /**
     * Get the HTML String.
     * @return string
     */
    public function __toString()
    {
        return $this->toHtml();
    }
}
