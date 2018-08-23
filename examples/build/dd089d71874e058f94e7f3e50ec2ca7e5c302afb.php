<!-- Compiled by the Jaguar Compiler v0.1.0. -->
<?php require_once 'C:\Users\Storm\Desktop\Development\Jaguar\vendor\autoload.php'; ?>

@html
  @head
    @title 'Indepth Example'
    @meta{name: 'description', content: 'content here'}
    
    
    @style
      .title
        font-size: 26px
        color: #ff0000

  @body
    @h1.title 'Indepth Example'
    <?php ($name = "World"); ?>
    <?php echo e("Hello, $name!"); ?>


    <?php if(1 == 1): ?>
      @h2 '1 == 1'
    <?php endif; ?> 

    <?php if (! (1 == 2)): ?>
      @h2 '1 != 1'
    <?php endif; ?>

    <?php 
      $name = "Jeff"
     ?>

    %p  '<?php echo e("Bye, $name"); ?>'

    %json
    %notjson
