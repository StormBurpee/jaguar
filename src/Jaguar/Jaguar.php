<?php

namespace Jaguar;

use InvalidArgumentException;
use Jaguar\Compiler\JaguarCompiler;
use Jaguar\Extensions\Extensions;
use Jaguar\Support\Filesystem\Filesystem;
use Leafo\ScssPhp\Compiler;

class Jaguar
{
    const VERSION = '0.1.0';

    protected static $instance;

    /**
     * The reference to the JaguarCompiler
     * @var \Jaguar\Compiler\JaguarCompiler
     */
    protected static $compiler;

    /**
     * The path where views will be compiled too.
     * @var string
     */
    protected $compiledOutput;

    protected $basepath;

    protected $autoload;

    protected $filesystem;

    public function __construct($basepath = null, $compiledOutput = null, $autoload = null)
    {
        if ($basepath) {
            $this->basepath = $basepath;
        } else {
            $this->basepath = realpath('./');
        }
        if (! $compiledOutput) {
            $compiledOutput = $this->basepath.'/build';
        }
        if (! $autoload) {
            $autoload = realpath($this->basepath.'/../vendor/autoload.php');
        }

        $this->autoload = $autoload;
        $this->compiledOutput = $compiledOutput;
        $this->filesystem = new Filesystem();

        if (! static::$instance) {
            static::$instance = $this;
            static::$compiler = new JaguarCompiler($this->filesystem, $this->compiledOutput);
            $this->registerCoreCompilerExtensions();
        } else {
            $this->setCompiledPath($this->compiledOutput);
        }

        static::$compiler->setAutoload($this->autoload);
    }

    protected function registerCoreCompilerExtensions()
    {
        Extensions::registerCompilerHtmlDirective('doc5', function ($expression) {
            return "<!DOCTYPE html>";
        });

        Extensions::registerCompilerHtmlDirective('meta', function($expression, $properties) {
          return "<meta $properties/>";
        });

        Extensions::registerCompilerAlias('e', 'eval');

        Extensions::registerHtmlBlockProcessor("scss", function($lines, $indent) {
          $output = "<style>\n";
          $scsslines = implode("\n", $lines);
          $scss = new Compiler();
          $output .= $scss->compile($scsslines) . "\n";
          $output .= "</style>\n";
          return "$output";
        });
    }

    /**
     * Sets the path of compiled views.
     * @param string $path
     * @return void
     */
    public function setCompiledPath($path)
    {
        $this->compiledOutput = $path;
        static::$compiler->setCompilePath($path);
    }

    /**
     * Sets the Autoload path for the Composer Autoloader.
     * @param string $path
     * @return void
     */
    public function setAutoload($path)
    {
        $this->autoload = $path;
        static::$compiler->setAutoload($this->autoload);
    }

    /**
     * Gets the path of compiled views.
     * @return string
     */
    public function getCompiledPath()
    {
        return $this->compiledOutput;
    }

    /**
     * Compiles a view at given path.
     * If output is not given, it defaults to './build'
     * @param  string $path   Path of view to compile.
     * @param  string $output Path of output directory. Defaults to './build'
     * @return void
     */
    public function compile($path)
    {
        static::$compiler->compile($path);
    }

    /**
     * Compiles all views in a given path.
     * @param  string $path
     * @param  bool $recursive
     * @return void
     */
    public function compileDirectory($path, $recursive = true)
    {
        if (! $this->filesystem->isDirectory($path)) {
            throw new InvalidArgumentException("Path given is not a directory.");
        }

        $files = $this->filesystem->allFiles($path);

        foreach ($files as $file) {
            $extension = $this->filesystem->extension($file);
            if ($extension == "jaguar" || $extension == "jag") {
                static::$compiler->compile($file);
            }
        }
    }

    /**
     * Gets the Jaguar Compiler
     * @return \Jaguar\Compiler\JaguarCompiler
     */
    public function getCompiler()
    {
        return static::$compiler;
    }

    public static function getVersion()
    {
        return static::VERSION;
    }

    public static function getVersionString()
    {
        return 'v' . static::VERSION;
    }

    /**
     * Gets the Jaguar Instance
     * @return \Jaguar\Jaguar
     */
    public static function getInstance()
    {
        if (! static::$instance) {
            static::$instance = new static;
        }
        return static::$instance;
    }
}
