# Jaguar Lang

**THIS IS THE DECOUPLED JAGUAR COMPILER**   
**IMPORTANT:** This branch will be moving to it's own repo in the near future.  
Work in this branch is no longer active, and will be picked up again when the 'jaguar/decoupled' branch is created.   

This repo is for the new open source Jaguar Language.   
Jaguar is a fast templating engine for generating PHP And/Or HTML.    
Jaguar can be implemented and extended easily as well, in order to suit your needs. This is explained in the **Expanding Jaguar** section.   

Jaguar comes implemented with a few handy modules as well, for example compiling inline styles written in SCSS. These modules can be found in the   
[Modules](src/modules) folder. These extensions should also be a good learning platform for extending Jaguar to your needs, as everything is injected as a module.  

## Overview  
Jaguar when compiled is split into two main 'Templates'. There's the 'PHP' Templates and the 'HTML' templates.   
PHP Templates all start with a '%' sign, whereas HTML Templates all start with a '@'.
There is also the '{{ expression }}' template, which automatically echos the expression.  
For example,   
```jaguar
%e $name = "World"
@h1 {{ "Hello, $name!" }}
```   
Would compile too   
```html
<?php $name = "World"; ?>
<h1><?php echo "Hello, $name!"; ?></h1>
```  

It is important to note that, the word immediately following the template start sign ('%' or '@') is known as the 'Template Function'.   
In the PHP Template functions, if a template is not defined, an error will be thrown when compiling to inform the user that the function is not implemented.   
However with the HTML Template Functions, if a custom template function is not defined, it will be compiled to a html block, for example   
```jaguar
@test 'This is a test'
```   
Would become
```html
<test>This is a test</test>
```   

The next key important feature of Jaguar, is that white space **is important**, blocks are defined and closed through indents and dedents. (These can also be represented as two spaces.)   
For example,
```jaguar
@ul
  @li 'List Item 1'
  @li 'List Item 2'

@div
  @div 'Hello'
```   
Would become,  
```html
<ul>
  <li>List Item 1</li>
  <li>List Item 2</li>
</ul>
<div>
  <div>Hello</div>
</div>
```

**More Key Features of Jaguar, are listed below, and described in the wiki.**

## Examples  
For more indepth examples, please see the [Examples](examples/) folder.   

**Basic Hello, World!**
```jaguar
@html
  @head
    @title 'Hello, World!'
  @body
    @h1 'Hello, World!'
```


## Common Core PHP Template Functions
It is important to note that wherever a `[block]` is written here, it means either a single line immediately following the template function, or a new line that is indented. The block is terminated when there is a dedent.   
For example,  
```jaguar
%p [block] {{-- Single Line, no new lines. New lines won't be evaluated --}}
{{-- Or --}}
%p
  [block] {{-- Block starts here --}}
  [block continued]
  [block continued]
{{-- Block ends here, because of dedent --}}
```  

**THIS IS NOT DECIDED YET, IT IS HERE FOR ME TO CONSIDER...**   
_The main argument I have against this, is that for a for loop the semi colons_   
I think that we might do a cheaty for loop similar to lua for loops? We'll see...

Another important thing to note, is that PHP Template functions **do not** need braces.
```jaguar
%foreach($arr as $val)          {{-- wrong --}}
%foreach $arr as $val           {{-- right --}}
%for($i = 0; $i <= 10; $i++)    {{-- wrong --}}
%for $i, 0, 10                  {{-- right --}}
%for($i = 10; $i >= 0; $i--)    {{-- wrong --}}
%for $i, 10, 0                  {{-- right --}}
```

| Template       | Definition     | Example        |
| :------------- | :------------- | :------------- |
| `%eval [expression]` | Evaluates a single line of PHP `[expression]`, for multiple lines use `%php` | `%e $name = 'jeff'` |
| `%e [expression]` | Alias of `%eval` | `%e $name = 'Jeff'` |
| `%php [block]` | Evaluates a block of PHP | `%php $name = 'Jeff'` |
| `%foreach [array] as [var] [block]` | Alias of PHP foreach function. | `%foreach $arr as $val echo($val)` |
| `%for [var], [start], [end] [block]` | Alias of PHP for loop. All for loops are inclusive of the end. (i.e. <=, >=) | `%for $i, 0, 10 echo($i)`|

## Common Core HTML Template Functions   


## Passing Objects to HTML Template Functions
Jaguar allows you to pass objects through to the compiler to be process before being compiled. This is more useful when expanding Jaguar and adding custom HTML Templates.   
This is discussed in detail in the **Expadning Jaguar** section.  
However, when being sent to a non-custom HTML Template, it will be added to the html block, this is also true for custom templates that allow _'PassThrough'_, for example   
```jaguar
@a{href: "https://google.com", target: "_blank"} 'Google'
```
Would compile too   
```html
<a href="https://google.com" target="_blank">Google</a>
```  

For the sake of giving a custom template example before the expanding jaguar section, lets imagine we have a custom HTML Template Function named `Hello`.   
`Hello` takes an object with a key of 'name', and compiles to a div saying `Hello, [name]`, this would look like   
```jaguar
@hello{name: "Jeff"}
```
And would compile too,  
```html
<div>Hello, Jeff</div>
```
Examples on implementing custom HTML Template Functions like this, are in the **Expanding Jaguar** section below, and discussed in more detail in the wiki.


## Expanding Jaguar  


## Etc   


## Etc  
