# Jaguar Quick Start

## Installation

Jaguar is installed using composer, to simply include Jaguar in your project, run the following.
```bash
composer require jaguar-language/jaguar
```

## Import the Jaguar Compiler

Because Jaguar is installed using Composer, you can Autoload the files.
```php
use Jaguar\Jaguar;

$jaguar = new Jaguar();
```

## Compile a single file

By default, Jaguar will create a build folder in the current directory and output the compiled php there. This can be changed by specifying an output directory to the compiler. This is explained in the [Jaguar](jaguar.md) section.
```php
$jaguar->compile('./src/index.jaguar');
```

## Compile a directory

By default, Jaguar will create a build folder in the current directory and output the compiled php there. This can be changed by specifying an output directory to the compiler. This is explained in the [Jaguar](jaguar.md) section. Furthemore, the compile a directory automatically recursively compiled the folder, if you don't want this you can pass `false` as the second parameter.
```php
$jaguar->compileDirectory('./src/'); // Compiles recursively
$jaguar->compileDirectory('./src/'); // Compiles only files in ./src/*.(jaguar|jag)
```

## Basic CLI Usage
**Implement this when the CLI is created.**

## Hello World - Basic
```jaguar
@doc5
@html
  @head
    @title Hello, World!
  @body
    @h1 Hello, World!
```
Which would compile to,
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello, World!</title>
  </head>
  <body>
    <h1>Hello, World!</h1>
  </body>
</html>
```

## Hello World - With PHP Compiler
```jaguar
@doc5
@html
  @head
    @title Hello, World!
  @body
    %set($name, "John")
    <h1>Hello, {{ $name }}</h1>
```
Which would compile to,
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello, World!</title>
  </head>
  <body>
    <?php $name = "John"; ?>
    <h1>Hello, <?php echo $name; ?></h1>
  </body>
</html>
```
