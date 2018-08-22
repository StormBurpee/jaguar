<?php

namespace Jaguar\Foundation\Filesystem;

use ErrorException;
use FilesystemIterator;
use Symfony\Component\Finder\Finder;
use Jaguar\Support\Traits\Macroable;
use Jaguar\Contracts\Foundation\Filesystem\FileNotFoundException;

class Filesystem
{
  use Macroable;

  public function exists($path)
  {
    return file_exists($path);
  }

  public function get($path, $lock = false)
  {
    if($this->isFile($path)) {
      return $lock ? $this->sharedGet($path) : file_get_contents($path);
    }

    throw new FileNotFoundException("File does not exist at path {$path}");
  }

  public function sharedGet($path)
  {
    $contents = '';

    $handle = fopen($path, 'rb');

    if($handle) {
      try {
        if(flock($handle, LOCK_SH)) {
          clearstatcache(true, $path);

          $contents = fread($handle, $this->size($path) ?: 1);

          flock($handle, LOCK_UN);
        }
      } finally {
        fclose($handle);
      }
    }

    return $contents;
  }

  public function getRequire($path)
  {
    if($this->isFile($path)) {
      return require $path;
    }

    throw new FileNotFoundException("File does not exist at path {$path}");
  }

  public function requireOnce($file)
  {
    require_once $file;
  }

  public function hash($path)
  {
    return md5_file($path);
  }

  public function put($path, $contents, $lock = false)
  {
    return file_put_contents($path, $contents, $lock ? LOCK_EX : 0);
  }

  public function prepend($path, $data)
  {
    if($this->exists($path)) {
      return $this->put($path, $data.$this->get($path));
    }

    return $this->put($path, $data);
  }

  public function append($path, $data)
  {
    return file_put_contents($path, $data, FILE_APPEND);
  }

  public function chmod($path, $mode = null)
  {
    if($mode) {
      return chmod($path, $mode);
    }

    return substr(sprintf('%o', fileperms($path)), -4);
  }

  public function delete($paths)
  {
    $paths = is_array($paths) ? $paths : func_get_args();

    $success = true;

    foreach($paths as $path) {
      try {
        if(! @unlink($path)) {
          $success = false;
        }
      } catch (ErrorException $e) {
        $success = false;
      }
    }

    return $success;
  }

  public function move($path, $target)
  {
    return rename($path, $target);
  }

  public function copy($path, $target)
  {
    return copy($path, $target);
  }

  public function link($target, $link)
  {
    if(! window_os()) {
      return symlink($target, $link);
    }

    $mode = $this->isDirectory($target) ? 'J' : 'H';
    exec("mklink /{$mode} \"{$link}\" \"{$target}\"");
  }
}
