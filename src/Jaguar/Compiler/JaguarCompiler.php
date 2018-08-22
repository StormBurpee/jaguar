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

    /**
     * The file currently being compiled
     * @var string
     */
    protected $path;

    /**
     * All of the available compiler functions
     * @var array
     */
    protected $compilers = [
      'Comments',
      'Extensions',
      'Statements',
      'Echos',
    ];

    /**
     * Array of openeing and closing tags for raw echos
     * @var array
     */
    protected $rawTags = ['{!!', '!!}'];

    /**
     * Array of opening and closing tags for echos
     * @var array
     */
    protected $contentTags = ['{{', '}}'];

    /**
     * Array of opening and closing tags for escaped echos
     * @var array
     */
    protected $escapedTags = ['{{{', '}}}'];

    /**
     * the regular echo string format.
     * @var string
     */
    protected $echoFormat = 'e(%s)';

    /**
     * Array of footer lines to be added to the tamplate.
     * @var array
     */
    protected $footer = [];

    /**
     * Array to temporarily store the raw blocks found in the template.
     * @var array
     */
    protected $rawBlocks = [];

    /**
     * Compiles the jaguar view at the given path.
     * @param  string $path
     * @return void
     */
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

    /**
     * Gets the path currently being compiled.
     * @return string
     */
    public function getPath()
    {
        return $this->path;
    }

    /**
     * Sets the path currently being compiled.
     * @param string $path
     * @return void
     */
    public function setPath($path)
    {
        $this->path = $path;
    }

    /**
     * Compile the given Jaguar template contents.
     * @param  string $value
     * @return string
     */
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

    /**
     * Stores the raw PHP blocks and replaces them with a temporary placeholder
     * @param  string $value
     * @return string
     * @todo remove 'endphp' directive and change it to a dedent.
     */
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
        foreach ($this->extensions as $compiler) {
            $value = call_user_func($compiler, $value, $this);
        }

        return $value;
    }

    protected function compileStatements($value)
    {
        return preg_replace_callback(
          '/\B%(%?\w+(?:::\w+)?)([ \t]*)(\( ( (?>[^()]+) | (?3) )* \))?/x',
            function ($match) {
                return $this->compileStatement($match);
            },
            $value
        );
    }

    protected function compileStatement($match)
    {
        if (Str::contains($match[1], '%')) {
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
        if (Str::startsWith($value, '(') && Str::endsWith($value, ')')) {
            $value = Str::substr($value, 1, -1);
        }

        return call_user_func($this->customDirectives[$name], trim($value));
    }

    protected function callCustomHtmlDirective($name, $value)
    {
        if (Str::startsWith($value, '(') && Str::endsWith($value, ')')) {
            $value = Str::substr($value, 1, -1);
        }

        return call_user_func($this->customDirectives[$name], trim($value));
    }

    public function stripParentheses($expression)
    {
        if (Str::startsWith($expression, '(')) {
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
     * @todo remove the 'end' directives and change to dedent.
     */
    public function if($name, callable $callback)
    {
        $this->conditions[$name] = $callback;

        $this->directive($name, function ($expression) use ($name) {
            return $expression !== ''
                ? "<?php if (\Jaguar\Support\Facades\Jaguar::check('{$name}', {$expression})): ?>"
                : "<?php if (\Jaguar\Support\Facades\Jaguar::check('{$name}')): ?>";
        });

        $this->directive('else'.$name, function ($expression) use ($name) {
            return $expression !== ''
                ? "<?php elseif (\Jaguar\Support\Facades\Jaguar::check('{$name}', {$expression})): ?>"
                : "<?php elseif (\Jaguar\Support\Facades\Jaguar::check('{$name}')): ?>";
        });

        $this->directive('end'.$name, function () {
            return '<?php endif; ?>';
        });
    }

    /**
     * Check the result of a condition
     * @param  string $name
     * @param  array $parameters
     * @return bool
     */
    public function check($name, ...$parameters)
    {
        return call_user_func($this->conditions[$name], ...$parameters);
    }

    /**
     * Register a component alis directives
     * @param  string $path
     * @param  string $alias
     * @return void
     *
     * @todo Remove the 'end' directive in favor of dedent.
     */
    public function component($path, $alias = null)
    {
        $alias = $alias ?: array_last(explode('.', $path));

        $this->directive($alias, function ($expression) use ($path) {
            return $expression
                ? "<?php \$__env->startComponent('{$path}', {$expression}); ?>"
                : "<?php \$__env->startComponent('{$path}'); ?>";
        });

        $this->directive('end'.$alias, function ($expression) {
            return '<?php echo $__env->renderComponent(); ?>';
        });
    }

    /**
     * Register an include alias directives
     * @param  string  $path
     * @param  string  $alias
     * @return void
     */
    public function include($path, $alias = null)
    {
        $alias = $alias ?: array_last(explode('.', $path));

        $this->directive($alias, function ($expression) use ($path) {
            $expression = $this->stripParentheses($expression) ?: '[]';

            return "<?php echo \$__env->make('{$path}', {$expression}, array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>";
        });
    }

    /**
     * Register a handler for custom php directives.
     * @param  string   $name
     * @param  callable $handler
     * @return void
     */
    public function directive($name, callable $handler)
    {
        $this->customDirectives[$name] = $handler;
    }

    /**
     * Register a handler for custom html directives.
     * @param  string   $name
     * @param  callable $handler
     * @return void
     */
    public function htmlDirective($name, callable $handler)
    {
        $this->customHtmlDirectives[$name] = $handler;
    }

    /**
     * Get the list of custom php directives
     * @return array
     */
    public function getCustomDirectives()
    {
        return $this->getCustomDirectives;
    }

    /**
     * Get the list of custom html directives
     * @return array
     */
    public function getCustomHtmlDirectives()
    {
        return $this->customHtmlDirectives;
    }

    /**
     * Sets the echo format to be used by the Jaguar Compiler
     * @param string $format
     */
    public function setEchoFormat($format)
    {
        $this->echoFormat = $format;
    }

    /**
     * Sets the echo fromat to double encode entities.
     * @return void
     */
    public function withDoubleEncoding()
    {
        $this->setEchoFormat('e(%s, true)');
    }

    /**
     * Sets the echo format to not double encode entities.
     * @return void
     */
    public function withoutDoubleEncoding()
    {
        $this->setEchoFormat('e(%s, false)');
    }
}
