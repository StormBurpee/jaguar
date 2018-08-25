<?php

namespace Jaguar\Compiler;

use Jaguar\Jaguar;
use Jaguar\Support\Arr;
use Jaguar\Support\Str;
use Jaguar\Contracts\Compiler\Compiler as CompilerContract;

class JaguarCompiler extends Compiler implements CompilerContract
{
    use Concerns\Php\CompilesComments,
        Concerns\Php\CompilesConditionals,
        Concerns\Php\CompilesEchos,
        Concerns\Php\CompilesJson,
        Concerns\Php\CompilesLoops,
        Concerns\Php\CompilesRawPhp;

    /**
     * All registered Jaguar PHP Extensions.
     * @var array
     */
    protected $extensions = [];

    /**
     * All registered Jaguar HTML Extensions.
     * @var array
     */
    protected $htmlExtensions = [];

    /**
     * All registered custom Jaguar PHP directives.
     * @var array
     */
    protected $customDirectives = [];

    /**
     * All registered custom Jaguar HTML Extensions.
     * @var array
     */
    protected $customHtmlDirectives = [];

    /**
     * All registered custom Jaguar PHP condition handlers.
     * @var array
     */
    protected $conditions = [];

    /**
     * The file that is currently being compiled.
     * @var string
     */
    protected $path;

    /**
     * All of the available functions the Jaguar compiler can parse.
     * @var array
     */
    protected $compilers = [
      'Comments',
      'Extensions',
      'HtmlExtensions',
      'Statements',
      'HtmlStatements',
      'Echos',
    ];

    /**
     * Array of opening and closing tags for raw echos.
     * @var array
     */
    protected $rawTags = ['{!!', '!!}'];

    /**
     * Array of opening and closing tags for echos.
     * @var array
     */
    protected $contentTags = ['{{', '}}'];

    /**
     * Array of opening and closing tags for Jaguar comments.
     * @var array
     */
    protected $commentTags = ['{--', '--}'];

    /**
     * Array of opening and closing tags for escaped echos.
     * @var array
     */
    protected $escapedTags = ['{{{', '}}}'];

    /**
     * The regular echo string format.
     * @var string
     */
    protected $echoFormat = 'e(%s)';

    /**
     * Array of header lines that will be added to the template.
     * @var array
     */
    protected $header = [];

    /**
     * Array of footer lines that will be added to the template.
     * @var array
     */
    protected $footer = [];

    /**
     * Array to temporarily store raw blocks that are found in the template.
     * @var array
     */
    protected $rawBlocks = [];

    /**
     * Array to temporarily store blocks that are indented
     * @var array
     */
    protected $tabBlocks = [];

    /**
     * Current indent in code.
     * @var int
     */
    protected $currentIndent = -1;

    /**
     * Current line that's being processed
     * @var int
     */
    protected $currentLine = 0;

    /**
     * Lines of code being compiled
     * @var array
     */
    protected $lines =  [];

    public function compile($path = null)
    {
        if ($path) {
            $this->setPath($path);
        }

        if (! is_null($this->compilePath)) {
            $contents = $this->compileString($this->files->get($this->getPath()));

            $this->files->put($this->getCompiledPath($this->getPath()), $contents);
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
        $this->header = [];
        $this->header[] = "<!-- Compiled by the Jaguar Compiler " . Jaguar::getVersionString() . ". -->";
        if ($this->autoload) {
            $this->header[] = "<?php require_once '" . $this->autoload ."'; ?>";
        }

        if (strpos($value, '%php') !== false) {
            $value = $this->storePhpBlocks($value);
        }

        $result = '';
        $result = $this->addHeaders($result);

        $value = $this->stripEmptyLines($value);

        $this->lines = explode("\n", $value);
        //$lines = preg_split("/[\n]+/", $value, -1, PREG_SPLIT_DELIM_CAPTURE);

        $this->currentIndent = -1;
        $this->currentLine = 0;

        foreach ($this->lines as $line) {
            $tabcount = $this->getIndentsBeforeLine($line);
            $needsIndentChange = false;
            $indentAmm = 0;

            if ($this->currentIndent != $tabcount) {
                if ($tabcount < count($this->tabBlocks)) {
                    while ($tabcount < count($this->tabBlocks)) {
                        $result .= $this->closeLastTabBlock($result);
                        $this->currentIndent--;
                    }
                } else {
                    if($tabcount > count($this->tabBlocks)) {
                      $needsIndentChange = true;
                      $indentAmm = count($this->tabBlocks);
                    }
                }

                $this->currentIndent = $tabcount;
            }

            foreach (token_get_all($line) as $token) {
                $result .= is_array($token) ? $this->parseToken($token) : $token;
                $result .= "\n";
            }

            if ($needsIndentChange) {
                if (count($this->tabBlocks) == $indentAmm) {
                    $this->createTabBlock("", "compiler");
                }
            }

            $this->currentLine++;
        }

        if (! empty($this->rawBlocks)) {
            $result = $this->restoreRawContent($result);
        }

        if (count($this->footer) > 0) {
            $result = $this->addFooters($result);
        }

        if(count($this->tabBlocks) > 0) {
          while(count($this->tabBlocks) > 0) {
            $this->closeLastTabBlock($result);
          }
        }

        $result = $this->stripEmptyLines($result);

        return $result;
    }

    protected function stripEmptyLines($value)
    {
      return preg_replace('/\n\s*\n/', "\n", $value);
    }

    /**
     * Stores the raw PHP blocks and replaces them with a temporary placeholder
     * @param  string $value
     * @return string
     * @todo remove 'endphp' directive and change it to a dedent.
     */
    protected function storePhpBlocks($value)
    {
        return preg_replace_callback('/(?<!%)%php(.*?)%endphp/s', function ($matches) {
            return $this->storeRawBlock("<?php {$matches[1]} ?>");
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

    protected function addHeaders($result)
    {
        return implode(PHP_EOL, $this->header) . PHP_EOL . PHP_EOL . ltrim($result, PHP_EOL);
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

    protected function compileExtensions($value)
    {
        foreach ($this->extensions as $compiler) {
            $value = call_user_func($compiler, $value, $this);
        }

        return $value;
    }

    protected function compileHtmlExtensions($value)
    {
        // TODO: this
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

    protected function compileHtmlStatements($value)
    {
        return preg_replace_callback(
          '/\B@(\w+(?:::\w+)?)([ \t]*)(\[ ( (?>[^\[\]]+) | (?3) )* \])?([ \t]*)(.*)?/x',
            function ($match) {
                return $this->compileHtmlStatement($match);
            },
            $value
          );
        return $value;
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

    /**
     * Compiles a HTML Statement
     *
     * @param  array $match Consists of 6 groups. Group 1 is the variable name, Group 4 is the {data}, group 6 is the value.
     * @return [type]        [description]
     */
    protected function compileHtmlStatement($match)
    {
        $tags = [];
        if ($match[3] && $match[3][0] == "[") {
            $data = explode(',', $match[4]);
            foreach ($data as $tag) {
                $rdata = explode(':', $tag);
                if (strlen($tag) > 0) {
                    $tags[] = ltrim($rdata[0])."=".ltrim($rdata[1]);
                }
            }
        }

        $safeTag = implode(" ", $tags);

        if(isset($this->customHtmlDirectives[$match[1]])) {
          return $this->callCustomHtmlDirective($match[1], $match, $safeTag);
        } else {
          if ($this->getIndentsBeforeLine($this->peekNextLine()) > $this->currentIndent) {
              $this->createTabBlock($match[1]);
              return count($tags) > 0 ? "<$match[1] $safeTag>" : "<$match[1]>";
          }

          return count($tags) > 0 ? "<$match[1] $safeTag>$match[6]</$match[1]>" : "<$match[1]>$match[6]</$match[1]>";
        }
    }

    protected function createTabBlock($variable, $type = "html")
    {
        $block = array(
          "block" => $variable,
          "type" => $type,
          "tabs" => $this->currentIndent
        );

        $this->tabBlocks[] = $block;
    }

    protected function closeLastTabBlock($result)
    {
        $lastTabBlock = array_pop($this->tabBlocks);

        if ($lastTabBlock['type'] == "html") {
            $whitespace =  "";
            for ($i = 0; $i < $lastTabBlock["tabs"]; $i++) {
                $whitespace .= "\t";
            }
            return "$whitespace</".$lastTabBlock['block'].">\n";
        } else {
            return "";
        }
    }

    protected function peekNextLine()
    {
        if (count($this->lines) > $this->currentLine + 1) {
            return $this->lines[$this->currentLine + 1];
        }
        return "";
    }

    protected function getIndentsBeforeLine($line)
    {
        return (strlen($line) - strlen(ltrim($line)))/2;
    }

    protected function callCustomDirective($name, $value)
    {
        if (Str::startsWith($value, '(') && Str::endsWith($value, ')')) {
            $value = Str::substr($value, 1, -1);
        }

        return call_user_func($this->customDirectives[$name], trim($value));
    }

    protected function callCustomHtmlDirective($name, $value, $properties)
    {
        $directive = $this->customHtmlDirectives[$name];

        if($directive["block"] == true) {
          $result = call_user_func($directive["handler"], $value, $properties);
          $resultReturn = $this->getTagName($result);
          $this->createTabBlock($resultReturn, "html");
          return $result;
        } else {
          return call_user_func($directive["handler"], $value, $properties);
        }
    }

    protected function getTagName($tag)
    {
      return explode(">", explode(" ", explode("<", $tag)[1])[0])[0];
    }

    public function stripParentheses($expression)
    {
        if (Str::startsWith($expression, '(')) {
            $expression = substr($expression, 1, -1);
        }

        return $expression;
    }

    public function extend(callable $compiler)
    {
        $this->extensions[] = $compiler;
    }

    public function extendHtml(callable $compiler)
    {
        $this->htmlExtensions[] = $compiler;
    }

    public function getExtensions()
    {
        return $this->extensions;
    }

    public function getHtmlExtensions()
    {
        return $this->htmlExtensions;
    }

    /**
     * Register an "if" conditional statement directive.
     * @param  string   $name
     * @param  callable $callback
     * @return void
     * @todo Implement this function, as the Standalone Jaguar Compiler has not got this implemented from the 'Decoupled Laravel' Jaguar Compiler.
     */
    public function if($name, callable $callback)
    {
        // TODO: this
      //
      /*
        How this works in the 'Decoupled Laravel' version of Jaguar
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
      */
    }

    public function check($name, ...$parameters)
    {
        return call_user_func($this->conditions[$name], ...$parameters);
    }

    /**
     * Register a component alias directives
     * @param  string $path
     * @param  string $alias
     * @return void
     *
     * @todo Implement this function, as the Standalone Jaguar Compiler has not got this implemented from the 'Decoupled Laravel' Jaguar Compiler.
     */
    public function component($path, $alias = null)
    {
        /*
        'Decoubled Laravel' Jaguar version handles components in this way
        $alias = $alias ?: array_last(explode('.', $path));

        $this->directive($alias, function ($expression) use ($path) {
            return $expression
                ? "<?php \$__env->startComponent('{$path}', {$expression}); ?>"
                : "<?php \$__env->startComponent('{$path}'); ?>";
        });

        $this->directive('end'.$alias, function ($expression) {
            return '<?php echo $__env->renderComponent(); ?>';
        });
         */
    }

    /**
     * Register an include alias directives
     * @param  string  $path
     * @param  string  $alias
     * @return void
     * @todo Implement this function, as the Standalone Jaguar Compiler has not got this implemented from the 'Decoupled Laravel' Jaguar Compiler.
     */
    public function include($path, $alias = null)
    {
        /*
        $alias = $alias ?: array_last(explode('.', $path));

        $this->directive($alias, function ($expression) use ($path) {
            $expression = $this->stripParentheses($expression) ?: '[]';

            return "<?php echo \$__env->make('{$path}', {$expression}, array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>";
        });
        */
    }

    public function directive($name, callable $handler)
    {
        $this->customDirectives[$name] = $handler;
    }

    public function htmlDirective($name, callable $handler, $block = false)
    {
        $this->customHtmlDirectives[$name] = ["handler" => $handler, "block" => $block];
    }

    public function getCustomDirectives()
    {
        return $this->getCustomDirectives;
    }

    public function getCustomHtmlDirectives()
    {
        return $this->customHtmlDirectives;
    }

    public function setEchoFormat($format)
    {
        $this->echoFormat = $format;
    }

    public function withDoubleEncoding()
    {
        $this->setEchoFormat('e(%s, true)');
    }

    public function withoutDoubleEncoding()
    {
        $this->setEchoFormat('e(%s, false)');
    }
}
