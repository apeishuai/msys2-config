<?php if(!class_exists('raintpl')){exit;}?><div class="pure-g">
  <div class="pure-u-1 pure-alert pure-alert-success tag-sort">
    <?php echo t( 'Sort by:' );?>

    <a href="<?php echo $base_path;?>/tags/cloud"><?php echo t( 'Cloud' );?></a>
    <a href="<?php echo $base_path;?>/tags/list?sort=usage"><?php echo t( 'Most used' );?></a>
    <a href="<?php echo $base_path;?>/tags/list?sort=alpha"><?php echo t( 'Alphabetical' );?></a>
  </div>
</div>
