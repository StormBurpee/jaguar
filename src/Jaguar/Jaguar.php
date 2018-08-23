<?php

namespace Jaguar;

use InvalidArgumentException;
use Jaguar\Compiler\JaguarCompiler;
use Jaguar\Support\Filesystem\Filesystem;

class Jaguar
{
    const VERSION = '0.1.0';

    /**
     * The reference to the JaguarCompiler
     * @var \Jaguar\Compiler\JaguarCompiler
     */
    protected $compiler;

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
        $this->compiler = new JaguarCompiler($this->filesystem, $this->compiledOutput);
        $this->compiler->setAutoload($this->autoload);
    }

    /**
     * Sets the path of compiled views.
     * @param string $path
     * @return void
     */
    public function setCompiledPath($path)
    {
        $this->compiledOutput = $path;
        $this->compiler->setCompilePath($path);
    }

    /**
     * Sets the Autoload path for the Composer Autoloader.
     * @param string $path
     * @return void
     */
    public function setAutoload($path)
    {
        $this->autoload = $path;
        $this->compiler->setAutoload($this->autoload);
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
        $this->compiler->compile($path);
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
          $this->compiler->compile($file);
        }
    }

    public static function getVersion()
    {
        return static::VERSION;
    }

    public static function getVersionString()
    {
        return 'v' . static::VERSION;
    }
}
