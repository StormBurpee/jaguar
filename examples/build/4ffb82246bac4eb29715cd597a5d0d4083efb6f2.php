<!-- Compiled by the Jaguar Compiler v0.1.0. -->
<?php require_once '/Users/stormburpee/Desktop/Development/Jaguar/vendor/autoload.php'; ?>

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
    @p '<?php echo e("Bye, $name"); ?>'
    <?php ($arr = ["first" => "Jeff", "last" => "Bridges"]); ?>
    <?php echo json_encode($arr, 15, 512) ?>
    <?php foreach($arr as $key => $value): ?>
      @p '<?php echo e("$key: $value"); ?>'
    <?php endforeach; ?>
    <?php for($i = 0; $i < 10; $i++): ?>
      <?php if($i == 3) continue; ?>
      @p '<?php echo e($i); ?>'
      <?php if($i == 5) break; ?>
    <?php endfor; ?>
