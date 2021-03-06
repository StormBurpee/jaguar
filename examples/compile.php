<?php

require __DIR__.'/../vendor/autoload.php';

use Jaguar\Jaguar;
use Jaguar\Extensions\Extensions;

$jaguar = new Jaguar(realpath(__DIR__.'/'));

// Register Custom Extension.
Extensions::registerCompilerDirective("jaguar", function ($expression) {
    return "Jaguar " . Jaguar::getVersionString();
});

Extensions::registerCompilerHtmlDirective("tbl", function($expression, $properties) {
  return strlen($properties) > 0 ? "<table $properties>" : "<table>";
}, true);

Extensions::registerCompilerHtmlAlias('tb', 'tbl');

Extensions::registerIf('env', function($environment) {
  $env = 'local';
  return $env == $environment;
});

$jaguar->compileDirectory(__DIR__.'/views');
