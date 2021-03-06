<?php

namespace Jaguar\Compiler;

use InvalidArgumentException;
use Jaguar\Support\Filesystem\Filesystem;

abstract class Compiler
{
    /**
     * The filesystem instance
     * @var \Jaguar\Support\Filesystem\Filesystem
     */
    protected $files;

    /**
     * The path for the compiled view.
     * @var string
     */
    protected $compilePath;

    /**
     * The path to the Composer autoload file.
     * @var string
     */
    protected $autoload;

    /**
     * Create a new compiler instance.
     * @param \Jaguar\Support\Filesystem\Filesystem $files
     * @param string     $compilePath
     */
    public function __construct(Filesystem $files, $compilePath)
    {
        $this->files = $files;
        $this->compilePath = $compilePath;
    }

    /**
     * Sets the Autoload path for the Composer Autoloader.
     * @param string $path
     * @return void
     */
    public function setAutoload($path)
    {
        $this->autoload = $path;
    }

    public function setFilesystem(Filesystem $files)
    {
        $this->files = $files;
    }

    /**
     * Gets the compiled path of a view at $path.
     * @param  string $path
     * @return string
     */
    public function getCompiledPath($path)
    {
        $name = $this->files->name($path);
        return $this->compilePath.'/'.$name.'.php';
    }

    /**
     * Sets the base compile path of compiled views.
     * @param string $path
     * @return void
     */
    public function setCompilePath($path)
    {
        $this->compilePath = $path;
    }

    /**
     * Gets if the compiled version of the view at path is expired.
     * @param  string  $path
     * @return boolean
     */
    public function isExpired($path)
    {
        $compiled = $this->getCompiledPath($path);

        if (! $this->files->exists($compiled)) {
            return true;
        }

        return $this->files->lastModified($path) >=
                $this->files->lastModified($compiled);
    }
}
