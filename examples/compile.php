<?php

require __DIR__.'/../vendor/autoload.php';

use Jaguar\Jaguar;
use Jaguar\Extensions\Extensions;

$jaguar = new Jaguar(realpath(__dir__.'./'));

// Register Custom Extension.

$jaguar->compileDirectory(__DIR__.'/views');
