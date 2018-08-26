# Templating

## Overview
When compiling, Jaguar is split into two sections.
- Jaguar PHP Compiler
- Jaguar HTML Compiler

Jaguar breaks each of the sections into two sub sections as well,
- Jaguar Directives
  - These are commonly referred in the documentation as 'Templating Functions'
- Jaguar Extensions
  - A custom compilerExtension, for advanced use cases.

## Jaguar Directives
Directives are the most commonly used functions in Jaguar. When compiling, the core `JaguarCompiler` class breaks directives down into 'PHP' directives, and 'HTML' directives. When custom directives are registered, they are given higher precedence and are compiled before core compiler directives.  
[`HTML Directives`](html-templating.md) all start with a `@` symbol.   
[`PHP/Core Directives`](php-templating.md) all start with a `%` symbol.

## Jaguar Extensions
Jaguar extensions are used more when [Extending Jaguar](basic-expanding.md), however a Jaguar Extension can be seen similar to directives, but are often used to create a new 'section' of Jaguar, therefore being able to define custom diretives that don't need to comply to the 'Html' or 'PHP' directives imposed by Jaguar.  
For example, creating custom directives that don't need to start with `% or @`   
Extensions are also used for cases when you need a custom 'compile' script running on the jaguar source code. Extensions allow you to modify the entire functionality of the `JaguarCompiler`

More on Jaguar extensions are found at [Extending Jaguar](basic-expanding.md)
