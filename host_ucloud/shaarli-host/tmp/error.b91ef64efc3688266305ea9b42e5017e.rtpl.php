<?php if(!class_exists('raintpl')){exit;}?><!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>
<div id="pageheader">
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.header") . ( substr("page.header",-1,1) != "/" ? "/" : "" ) . basename("page.header") );?>

<div id="pageError" class="page-error-container center">
  <h2><?php echo $message;?></h2>

  <img src="<?php echo $asset_path;?>/img/sad_star.png" alt="">

  <?php if( !empty($text) ){ ?>

  <p><?php echo $text;?></p>
  <?php } ?>


  <?php if( !empty($stacktrace) ){ ?>

      <pre>
        <?php echo $stacktrace;?>

      </pre>
  <?php } ?>

</div>
<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

</body>
</html>
