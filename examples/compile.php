<?php

require __DIR__.'/../vendor/autoload.php';

use Jaguar\Jaguar;

$jaguar = new Jaguar(realpath(__dir__.'./'));

$jaguar->compileDirectory(__DIR__.'/views');
