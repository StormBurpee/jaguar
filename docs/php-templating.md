# PHP Templating Functions

## Overview
PHP (Also referred to as 'Core') Templating Functions are any functions defined in a `Jaguar` source file that start with the `%` symbol. When the compiler doesn't have a compiler for a templating function, it returns the the plain text of what was written, i.e
```jaguar
%set($name, "Jeff")
%notafunction
```
Would return the following php file.
```html
<?php $name = "Jeff"; ?>
%notafunction
```

[Custom Templating Functions](extending-php.md) are compiled **before** any of the compilers core templating functions.

## Comments
Comments in Jaguar are not passed back to the compiled php file.  
Comments are defined using the `{-- COMMENT HERE --}` tags.
#### Examples
```jaguar
{-- comment here --}
@div
```
Compiles to
```html
<div></div>
```

## Conditionals
Conditionals are templating functions that provide an easy access to cases like `if, else, switch, etc`
Each base conditional implemented into Jaguar is listed below.

#### If
```jaguar
%if(1 == 1)
  @h1 1 equals 1
%endif

%if(1 == 2)
  @h1 1 equals 2?
%endif
```
Compiles to
```html
<?php if(1 == 1): ?>
  <h1>1 equals 1</h1>
<?php endif; ?>
<?php if(1 == 2): ?>
  <h1>1 equals 2?</h1>
<?php endif; ?>
```
In this case, the user would only ever see `<h1>1 equals 1</h1>`.

#### Unless
Jaguar provides an easy way to do an unless, which simply compiles down to an `if(! {statement})`
```jaguar
%unless($signedin)
  @h1 You aren't signed in.
%endunless {-- You can also use %endif. --}
```
Compiles to,
```html
<?php if(! ($signedin)): ?>
  <h1>You aren't signed in.</h1>
<?php endif; ?>
```

#### Else and Else If
Jaguar provides the `else` and `elseif` statements as well.
```jaguar
%if($name == "Jeff")
  @h1 Welcome back, Jeff!
%elseif($name == "Bob")
  @h1 Hi there, Bob!
%else
  @h1 Hello!
%endif
```
Compiles to,
```html
<?php if($name == "Jeff"): ?>
  <h1>Welcome back, Jeff!</h1>
<?php elseif($name == "Bob"): ?>
  <h1>Hi there, Bob!</h1>
<?php else: ?>
  <h1>Hello!</h1>
<?php endif; ?>
```

#### Switches
Jaguar provides the `switch, break, case and default` directives for handling switches.
```jaguar
%switch($name)
  %case("Jeff")
    @h1 Hi Jeff!
    %break
  %case("Bob")
    @h1 Hi Bob!
    %break
  %default
    @h1 Default case
    %break
%endswitch
```
Compiles to,
```html
<?php switch($name):
  case ("Jeff"): ?>
    <h1>Hi Jeff!</h1>
    <?php break; ?>
  <?php case ("Bob"): ?>
    <h1>Hi Bob!</h1>
    <?php break; ?>
  <?php default: ?>
    <h1>Default case</h1>
    <?php break; ?>
<?php endswitch; ?>
```

#### Isset
Jaguar provides a quick way to check if a variable is set, using `%isset`.
```jaguar
%isset($name)
  @h1 Name is set!
%endisset {-- You can also use, %endif --}
```
Compiles to,
```html
<?php if(isset($name)): ?>
  <h1>Name is set!</h1>
<?php endif; ?>
```

## Echos
Jaguar provides a few ways of displaying data, however data is mainly echoed through the `{{ }}` tags.  
For displaying unsecaped data, you can use the `{!! !!}` tags, however use **caution** when using these with user parsed data.  
Finally, for double escaped echos, you can use the `{{{ }}}` tags.

#### Echo Usage
```jaguar
@h1 Hello, {{ $name }} {-- Regular Echo --}
@h1 Hello, {!! $name !!} {-- Raw Echos, unescaped data --}
@h1 Hello, {{{ $name }}} {-- Double escaped echos. --}
```

#### Jaguar and Javascript Frameworks
As the `{{ }}` tags are commonly used in Javascript frameworks for displaying data, you can simply add the `%` symbol before the tags, `%{{ data }}` and the compiler will leave the tag for the Javascript framework to parse.

## Json
Jaguar implements a core directive for converting an array to json using `json_encode`. the function then echo's the given result.
```jaguar
%set($names, [["first"=>"Jeff", "last"=>"Johns"], ["first"=>"Bob", "last"=>"Dylan"]])
%json($names)
```
The respective JSON output would be,
```json
[{"first":"Jeff","last":"Johns"},{"first":"Bob","last":"Dylan"}]
```

## Loops
Jaguar provides base directives for the `for, foreach and while` loops. Jaguar also has functionality for `break and continue`. The `break` and `continue` functions also can be conditional, which stops you from having to write your own `if` functions.

#### For loops
```jaguar
%for($i = 0; $i < 10; $i++)
  @p {{ $i }}
%endfor
```
Compiles to,
```html
<?php for($i = 0; $i < 10; $i++): ?>
  <p><?php echo $i; ?></p>
<?php endfor; ?>
```

#### Foreach loops
```jaguar
%set($names, [["first"=>"Jeff", "last"=>"Johns"], ["first"=>"Bob", "last"=>"Dylan"]])
%foreach($names as $name)
  @p Hello, {{ $name["first"] }}
%endforeach
```
compiles to,
```html
<?php $names = [["first"=>"Jeff", "last"=>"Johns"], ["first"=>"Bob", "last"=>"Dylan"]]; ?>
<?php foreach($names as $name): ?>
  <p>Hello, <?php echo $name["first"]; ?></p>
<?php endforeach; ?>
```

#### While loops
While loops are also implemented into a jaguar directive.
```jaguar
%while(true)
  @p looping forever!
%endwhile
```

#### Break and Continue
Break and continue are implemented into Jaguar as core directives. These can also be conditional, meaning that when the condition is true, it will break or continue.
```jaguar
%for($i = 0; $i < 10; $i++)
  %continue($i == 3)
  @p {{ $i }}
  %break($i == 5)
%endfor
%for($i = 0; $i < 10; $i++)
  %continue
$endfor
%for($i = 0; $i < 10; $i++)
  %break
%endfor
```

## Raw Php
For cases when you need to write just pure PHP code, Jaguar has two directives implemented into the core. The `%php` directive is used for when you need to write multiple lines of PHP code, and the `%eval` directive is used for evaluating one line of php code.

#### Php
```jaguar
%php
  $name = "Jeff";
  $name .= " Doe";
  echo $name;
%endphp
```
Compiles to,
```html
<?php
  $name = "Jeff";
  $name .= " Doe";
  echo $name;
 ?>
```

#### Eval and E
Jaguar provides the `%eval` and it's alias `%e` directive to eval one line of php code.
```jaguar
%e($name = "Jeff")
{-- is the same as --}
%eval($name = "Jeff")
```

## Variables
To quickly assign, and unassign variables, jaguar provides the `%set` and `%unset` directives, so that you don't need to keep writing `%eval or %php`

#### Set
```jaguar
%set($name, "Jeff")
%set($names, ["Bob", "Jeff", "John", "Samantha", "Chloe", "Louise"])
```

#### Unset
```jaguar
%unset($name)
%unset($names)
```
