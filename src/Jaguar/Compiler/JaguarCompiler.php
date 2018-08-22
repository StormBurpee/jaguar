<?php

namespace Jaguar\Compiler;

use Jaguar\Support\Arr;
use Jaguar\Support\Str;
use Jaguar\Contracts\Compiler\Compiler as CompilerContract;

class JaguarCompiler extends Compiler implements CompilerContract
{
    protected $extensions = [];
    protected $htmlExtensions = [];

    /**
    * All custom Html Template Functions
    *
    * @var array
    */
    protected $customHtmlDirectives = [];

    /**
    * All custom Php Template Functions
    *
    * @var array
    */
    protected $customDirectives = [];

    /**
    * All custom Php condition handlers
    *
    * @var array
    */
    protected $conditions = [];

    protected $path;

    protected $compilers = [
      'Comments',
      'Extensions',
      'Statements',
      'Echos',
    ];

    protected $rawTags = ['{!!', '!!}'];

    protected $contentTags = ['{{', '}}'];

    protected $escapedTags = ['{{{', '}}}'];

    protected $footer = [];

    protected $rawBlocks = [];

    public function compile($path = null)
    {
        if ($path) {
            $this->setPath($path);
        }

        if (! is_null($this->cachePath)) {
            $contents = $this->compileString($this->files->get($this->getPath()));

            $this->files->put($this->getCompiledPath($this->geTPath()), $contents);
        }
    }

    public function getPath()
    {
        return $this->path;
    }

    public function setPath($path)
    {
        $this->path = $path;
    }

    public function compileString($value)
    {
        $this->footer = [];

        if (strpos($value, '%php') !== false) {
            $value = $this->storePhpBlocks($value);
        }

        $result = '';

        foreach (token_get_all($value) as $token) {
            $result .= is_array($token) ? $this->parseToken($token) : $token;
        }

        if (! empty($this->rawBlocks)) {
            $result = $this->restoreRawContent($result);
        }

        if (count($this->footer) > 0) {
            $result = $this->addFooters($result);
        }

        return $result;
    }

    // TODO: remove '%endphp' and change it to a dedent.
    protected function storePhpBlocks($value)
    {
        return preg_replace_callback('/(?<!%|@)%php(.*?)%endphp/s', function ($matches) {
            return $this->storeRawBlock("<?php{$matches[1]}?>");
        }, $value);
    }

    protected function storeRawBlock($value)
    {
        return $this->getRawPlaceholder(
          array_push($this->rawBlocks, $value) - 1
        );
    }

    protected function restoreRawContent($result)
    {
        $result = preg_replace_callback('/'.$this->getRawPlaceholder('(\d+)').'/', function ($matches) {
            return $this->rawBlocks[$matches[1]];
        }, $result);

        $this->rawBlocks = [];

        return $result;
    }

    protected function getRawPlaceholder($replace)
    {
        return str_replace('#', $replace, '%__raw_block_#__%');
    }

    protected function addFooters($result)
    {
        return ltrim($result, PHP_EOL)
              .PHP_EOL.implode(PHP_EOL, array_reverse($this->footer));
    }

    protected function parseToken($token)
    {
        list($id, $content) = $token;

        if ($id == T_INLINE_HTML) {
            foreach ($this->compilers as $type) {
                $content = $this->{"compile{$type}"}($content);
            }
        }

        return $content;
    }

    // TODO: Come back to here when you implement html extensions
    protected function compileExtensions($value)
    {
      foreach($this->extensions as $compiler) {
        $value = call_user_func($compiler, $value, $this);
      }

      return $value;
    }

    protected function compileStatements($value)
    {
        return preg_replace_callback(
          '/\B%(%?\w+(?:::\w+)?)([ \t]*)(\( ( (?>[^()]+) | (?3) )* \))?/x', function($match) {
            return $this->compileStatement($match);
          }, $value
        );
    }

    protected function compileStatement($match)
    {
      if(Str::contains($match[1], '%')) {
        $match[0] = isset($match[3]) ? $match[1].$match[3] : $match[1];
      } elseif (isset($this->customDirectives[$match[1]])) {
        $match[0] = $this->callCustomDirective($match[1], Arr::get($match, 3));
      } elseif (method_exists($this, $method = 'compile'.ucfirst($match[1]))) {
        $match[0] = $this->$method(Arr::get($match, 3));
      }

      return isset($match[3]) ? $match[0] : $match[0].$match[2];
    }

    protected function callCustomDirective($name, $value)
    {
      if(Str::startsWith($value, '(') && Str::endsWith($value, ')')) {
        $value = Str::substr($value, 1, -1);
      }

      return call_user_func($this->customDirectives[$name], trim($value));
    }

    protected function callCustomHtmlDirective($name, $value)
    {
      if(Str::startsWith($value, '(') && Str::endsWith($value, ')')) {
        $value = Str::substr($value, 1, -1);
      }

      return call_user_func($this->customDirectives[$name], trim($value));
    }

    public function stripParentheses($expression)
    {
      if(Str::startsWith($expression, '(')) {
        $expression = substr($expression, 1, -1);
      }

      return $expression;
    }

    /**
     * Register a custom Jaguar PHP Compiler
     * @param  callable $compiler Custom PHP Compiler
     * @return void
     */
    public function extend(callable $compiler)
    {
      $this->extensions[] = $compiler;
    }

    /**
     * Register a custom Jaguar HTML Compiler
     * @param  callable $compiler Custom HTML Compiler
     * @return void
     */
    public function extendHtml(callable $compiler)
    {
      $this->htmlExtensions[] = $compiler;
    }

    /**
     * Get all Jaguar PHP Extensions used by the Jaguar Compiler
     * @return array
     */
    public function getExtensions()
    {
      return $this->extensions;
    }

    /**
     * Get all Jaguar HTML Extensions used by the Jaguar Compiler
     * @return array
     */
    public function getHtmlExtensions()
    {
      return $this->htmlExtensions;
    }

    /**
     * Register an "if" conditional statement directive
     * @param  string   $name     name of directive
     * @param  callable $callback Callback function
     * @return void
     */
    public function if($name, callable $callback)
    {
      $this->conditions[$name] = $callback;

      $this->directive($name, function($expression) use ($name) {
        return $expression !== ''
                ? "<?php if(): ?>"
                : "<?php if(): ?>";
      });
    }

}
