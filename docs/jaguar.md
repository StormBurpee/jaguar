# Jaguar Class

## Overview

The `Jaguar` class is the base class that is used to interact with the Jaguar Compiler. This class handles all access to the compiler, and configuring the compiler. In cases where Jaguar doesn't implement needed functionality you can get the compiler with `$jaguar->getCompiler()`.

## Initialization
The Jaguar Class takes 3 optional parameters.
* `$basepath` - The base path, defaults to './'
* `$compiledOutput` - The compile path, defaults to `$basepath + 'build/'`
* `$autoload` - The path to the `autoload.php` file, defaults to `$basepath + '../vendor/autoload.php'`   

```php
use Jaguar\Jaguar;

$jaguar = new Jaguar(); // Creates new Jaguar instance with default options.
$jaguar = new Jaguar('./'); // Sets the base path to the current directory.
$jaguar = new Jaguar('./', './build'); // Sets the output path to './build'
$jaguar = new Jaguar('./', './build', '../vendor/autoload.php'); // Sets the path to the autoload.php file
```

## Change The Output Folder
From time to time, you might want to change the output path of the Jaguar instance. For this you can use the `setCompiledPath($path)` function.
```php
use Jaguar\Jaguar;

$jaguar = new Jaguar();
$jaguar->setCompiledPath('./output'); // Sets output to './output'
```

## Change the Autoload Path
From time to time, you might want to change the path to the `autoload.php` file. For this you can use the `setAutoload($path)` function.
```php
use Jaguar\Jaguar;

$jaguar = new Jaguar();
$jaguar->setAutoload('../vendor/autoload.php');
```

## Get The Output Folder
To access the compiler's output folder you can use the `getCompiledPath()` function.
```php
use Jaguar\Jaguar;

$jaguar = new Jaguar();
echo $jaguar->getCompiledPath(); // Outputs '/path/to/output/folder'
```

## Compile a file
To compile a Jaguar file, Jaguar provides the `compile($path)` function. This function only takes one parameter, and that's a string of the path to the file to compile. The compiled output is sent to the output folder.
```php
use Jaguar\Jaguar;

$jaguar = new Jaguar();
$jaguar->compile('./path/to/file.jaguar');
```

## Compile a directory
To compile all Jaguar files in a directory, Jaguar provides the `compileDirectory($path, [$recursive = true])` function. The second parameter, `$recursive` is optional and defaults to true. When this is set to true, Jaguar will compile all sub folders as well.
```php
use Jaguar\Jaguar;

$jaguar = new Jaguar();
$jaguar->compileDirectory('./src/'); // Compiles all files and subdirs in `./src/`
$jaguar->compileDirectory('./src/' false); // Compiles all files in './src/'
```

## Get the JaguarCompiler class
For use cases where the Jaguar class doesn't provide what you need, you can access the `JaguarCompiler` class. This is provided using the `getCompiler()` function.
```php
use Jaguar\Jaguar;

$jaguar = new Jaguar();
$jaguar->getCompiler(); // Returns `Jaguar\Compiler\JaguarCompiler` class.
```
