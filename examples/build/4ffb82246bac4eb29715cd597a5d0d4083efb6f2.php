<!-- Compiled by the Jaguar Compiler v0.1.0. -->
<?php require_once '/Users/stormburpee/Desktop/Development/Jaguar/vendor/autoload.php'; ?>

<html>
  <head>
    <title>Indepth Example.</title>
    <meta name='description' content='content here'></meta>
    
    
    
    <style>
		</style>
      .title {
        font-size: 26px;
        color: #ff0000;
      }
	</head>
  <body>
    <h1 class="title">Indepth Example</h1>
    <?php ($name = "World"); ?>
    <?php echo e("Hello, $name!"); ?>
    <?php if(1 == 1): ?>
      <h2>1 == 1</h2>
    <?php endif; ?> 
    <?php if (! (1 == 2)): ?>
      <h2>1 != 1</h2>
    <?php endif; ?>
    <?php 
      $name = "Jeff"
     ?>
    <p><?php echo e("Bye, $name"); ?></p>
    <?php ($arr = ["first" => "Jeff", "last" => "Bridges"]); ?>
    <?php echo json_encode($arr, 15, 512) ?>
    <?php foreach($arr as $key => $value): ?>
      <p><?php echo e("$key: $value"); ?></p>
    <?php endforeach; ?>
    <?php for($i = 0; $i < 10; $i++): ?>
      <?php if($i == 3) continue; ?>
      <p><?php echo e($i); ?></p>
      <?php if($i == 5) break; ?>
    <?php endfor; ?>
	</body>
</html>
