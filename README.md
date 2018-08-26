# Jaguar Lang

This repo is for the new open source Jaguar Language.   
Jaguar is a fast templating engine for generating PHP And/Or HTML.    
Jaguar can be implemented and extended easily as well, in order to suit your needs. This is explained in the **Expanding Jaguar** section.   

**This is the standalone compiler.**  
Work on the 'Decoupled Laravel' version can be seen in the 'decoupled' branch.  
The decoupled version provides an easy way to intergrate into Laravel, and also to provide an environment similar to laravel, and how it   
serves it's views. This _**standalone**_ version simply compiles the '.jaguar|.jag' files to core PHP.

Jaguar comes implemented with a few handy modules as well, for example compiling inline styles written in SCSS. These modules can be found in the   
[Modules](src/modules) folder. These extensions should also be a good learning platform for extending Jaguar to your needs, as everything is injected as a module.  

## Documentation
For all documentation, please see the [Documentation](https://stormburpee.gitlab.io/jaguar/#/)

## Hello World - Basic Example
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

## Hello World - With PHP Compiler Example
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
