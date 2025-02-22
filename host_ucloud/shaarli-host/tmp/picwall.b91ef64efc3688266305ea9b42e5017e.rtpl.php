<?php if(!class_exists('raintpl')){exit;}?><!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>
<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.header") . ( substr("page.header",-1,1) != "/" ? "/" : "" ) . basename("page.header") );?>


<?php if( count($linksToDisplay)===0 && $is_logged_in ){ ?>

  <div class="pure-g pure-alert pure-alert-warning page-single-alert">
    <div class="pure-u-1 center">
      <?php echo t( 'There is no cached thumbnail.' );?>

      <a href="<?php echo $base_path;?>/admin/thumbnails"><?php echo t( 'Try to synchronize them.' );?></a>
    </div>
  </div>
<?php } ?>


<div class="pure-g">
  <div class="pure-u-lg-1-6 pure-u-1-24"></div>
  <div class="pure-u-lg-2-3 pure-u-22-24 page-form page-visitor">
    <?php $countPics=$this->var['countPics']=count($linksToDisplay);?>

    <h2 class="window-title"><?php echo t( 'Picture Wall' );?> - <?php echo $countPics;?> <?php echo t( 'pics' );?></h2>

    <div id="plugin_zone_start_picwall" class="plugin_zone">
      <?php $counter1=-1; if( isset($plugin_start_zone) && is_array($plugin_start_zone) && sizeof($plugin_start_zone) ) foreach( $plugin_start_zone as $key1 => $value1 ){ $counter1++; ?>

        <?php echo $value1;?>

      <?php } ?>

    </div>

    <div id="picwall-container" class="picwall-container" role="list">
      <?php $counter1=-1; if( isset($linksToDisplay) && is_array($linksToDisplay) && sizeof($linksToDisplay) ) foreach( $linksToDisplay as $key1 => $value1 ){ $counter1++; ?>

        <div class="picwall-pictureframe" role="listitem">
          
          <img data-src="<?php echo $root_path;?>/<?php echo $value1["thumbnail"];?>" class="b-lazy"
               src=""
               alt="" width="<?php echo $thumbnails_width;?>" height="<?php echo $thumbnails_height;?>" />
          <a href="<?php echo $value1["real_url"];?>"><span class="info"><?php echo $value1["title"];?></span></a>
          <?php $counter2=-1; if( isset($value1["picwall_plugin"]) && is_array($value1["picwall_plugin"]) && sizeof($value1["picwall_plugin"]) ) foreach( $value1["picwall_plugin"] as $key2 => $value2 ){ $counter2++; ?>

            <?php echo $value2;?>

          <?php } ?>

        </div>
      <?php } ?>

      <div class="clear"></div>
    </div>

    <div id="plugin_zone_end_picwall" class="plugin_zone">
      <?php $counter1=-1; if( isset($plugin_end_zone) && is_array($plugin_end_zone) && sizeof($plugin_end_zone) ) foreach( $plugin_end_zone as $key1 => $value1 ){ $counter1++; ?>

        <?php echo $value1;?>

      <?php } ?>

    </div>
  </div>
  <div class="pure-u-lg-1-6 pure-u-1-24"></div>
</div>

<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

<script src="<?php echo $asset_path;?>/js/thumbnails.min.js?v=<?php echo $version_hash;?>"></script>
</body>
</html>

