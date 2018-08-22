<?php

namespace Jaguar\Compiler\View;

use Exception;
use Throwable;
use ArrayAccess;
use BadMethodCallException;
use Jaguar\Support\Str;
use Jaguar\Support\MessageBag;
use Jaguar\Contracts\Compiler\View\Engine;
use Jaguar\Support\Traits\Macroable;
use Jaguar\Contracts\Support\Arrayable;
use Jaguar\Contracts\Support\Renderable;
use Jaguar\Contracts\Support\MessageProvider;
use Jaguar\Contracts\Compiler\View\View as ViewContract;

class View implements ArrayAccess, ViewContract
{
    use Macroable {
    _call as macroCall;
  }

    /**
     * The view factory instance
     * @var \Jaguar\View\Factory
     */
    protected $factory;

    /**
     * The engine implementation
     * @var \Jaguar\Contracts\Compiler\View\Engine
     */
    protected $engine;


    /**
     * The name of the view
     * @var string
     */
    protected $view;

    /**
     * The array of view data.
     * @var array
     */
    protected $data;

    /**
     * The path to the view file
     * @var string
     */
    protected $path;

    public function __construct(Factory $factory, Engine $engine, $view, $path, $data = [])
    {
        $this->view = $view;
        $this->path = $path;
        $this->engine = $engine;
        $this->factory = $factory;

        $this->data = $data instanceof Arrayable ? $data->toArray() : (array) $data;
    }

    public function render(callable $callback = null)
    {
        try {
            $contents = $this->renderContents();

            $response = isset($callback) ? call_user_func($callback, $this, $contents) : null;

            $this->factory->flushStateIfDoneRendering();

            return ! is_null($response) ? $response : $contents;
        } catch (Exception $e) {
            $this->factory->flushState();

            throw $e;
        } catch (Throwable $e) {
            $this->factory->flushState();

            throw $e;
        }
    }

    protected function renderContents()
    {
        $this->factory->incrementRender();

        $this->factory->callComposer($this);

        $contents = $this->getContents();

        $this->factory->decrementRender();

        return $contents;
    }

    protected function getContents()
    {
        return $this->engine->get($this->path, $this->gatherData());
    }

    protected function gatherData()
    {
        $data = array_merge($this->factory->getShared(), $this->data);

        foreach ($data as $key => $value) {
            if ($value instanceof Renderable) {
                $data[$key] = $value->render();
            }
        }

        return $data;
    }

    public function renderSections()
    {
        return $this->render(function () {
            return $this->factory->getSections();
        });
    }

    public function with($key, $value = null)
    {
        if (is_array($key)) {
            $this->data = array_merge($this->data, $key);
        } else {
            $this->data[$key] = $value;
        }

        return $this;
    }

    public function nest($key, $view, array $data = [])
    {
        return $this->with($key, $this->factory->make($view, $data));
    }

    public function withErrors($provider)
    {
        $this->with('errors', $this->formatErrors($provider));
        return $this;
    }

    protected function formatErrors($provider)
    {
        return $provider instanceof MessageProvider
                      ? $provider->getMessageBag() : new Messagebag((array) $provider);
    }

    public function name()
    {
      return $this->getName();
    }

    public function getName()
    {
      return $this->view;
    }

    public function getData()
    {
      return $this->data;
    }

    public function getPath()
    {
      return $this->path;
    }

    public function setPath($path)
    {
      $this->path = $path;
    }

    public function getFactory()
    {
      return $this->factory;
    }

    public function getEngine()
    {
      return $this->engine;
    }

    public function offsetExists($key) {
      return array_key_exists($key, $this->data);
    }

    public function offsetGet($key)
    {
      return $this->data[$key];
    }

    public function offsetSet($key, $value)
    {
      $this->with($key, $value);
    }

    public function offsetUnset($key)
    {
      unset($this->data[$key]);
    }

    public function &__get($key)
    {
      return $this->data[$key];
    }

    public function __set($key, $value)
    {
      $this->with($key, $value);
    }

    public function __isset($key)
    {
      return isset($this->data[$key]);
    }

    public function __unset($key)
    {
      unset($this->data[$key]);
    }

    public function __call($method, $parameters)
    {
      if(static::hasMacro($method)) {
        return $this->macroCall($method, $parameters);
      }

      if(! Str::startsWith($method, 'with')) {
        throw new BadMethodCallException(sprintf(
              'Method %s::%s does not exist.', static::class, $method
          ));
      }

      return $this->with(Str::camel(substr($method, 4)), $parameters[0]);
    }

    public function __toString()
    {
      return $this->render();
    }
}
