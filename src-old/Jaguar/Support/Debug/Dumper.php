<?php

namespace Jaguar\Support\Debug;

class Dumper
{

  /**
   * Dump a value, later incorporate into Symfony
   * @param  mixed $value
   * @return void        
   */
  public function dump($value)
  {
    var_dump($value);
  }
}
