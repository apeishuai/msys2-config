<?php if(!class_exists('raintpl')){exit;}?><!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>
<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.header") . ( substr("page.header",-1,1) != "/" ? "/" : "" ) . basename("page.header") );?>

<div class="pure-g">
  <div class="pure-u-lg-1-3 pure-u-1-24"></div>
  <div id="addlink-form" class="page-form  page-form-light pure-u-lg-1-3 pure-u-22-24">
    <h2 class="window-title"><?php echo t( "Shaare a new link" );?></h2>
    <form method="GET" action="<?php echo $base_path;?>/admin/shaare" name="addform" class="addform">
      <div>
        <label for="shaare"><?php echo t( 'URL or leave empty to post a note' );?></label>
        <input type="text" name="post" id="shaare" class="autofocus">
      </div>
      <div>
        <input type="submit" value="<?php echo t( 'Add link' );?>">
      </div>
    </form>
  </div>
</div>

<div class="pure-g addlink-batch-show-more-block pure-u-0">
  <div class="pure-u-lg-1-3 pure-u-1-24"></div>
  <div class="pure-u-lg-1-3 pure-u-22-24 addlink-batch-show-more">
    <a href="#"><?php echo t( 'BULK CREATION' );?>&nbsp;<i class="fa fa-plus-circle" aria-hidden="true"></i></a>
  </div>
</div>

<div class="addlink-batch-form-block">
  <?php if( empty($async_metadata) ){ ?>

    <div class="pure-g pure-alert pure-alert-warning pure-alert-closable">
      <div class="pure-u-2-24"></div>
      <div class="pure-u-20-24">
        <p>
          <?php echo t( 'Metadata asynchronous retrieval is disabled.' );?>

          <?php echo t( 'We recommend that you enable the setting <em>general > enable_async_metadata</em> in your configuration file to use bulk link creation.' );?>

        </p>
      </div>
      <div class="pure-u-2-24">
        <i class="fa fa-times pure-alert-close"></i>
      </div>
    </div>
  <?php } ?>


  <div class="pure-g">
    <div class="pure-u-lg-1-3 pure-u-1-24"></div>
    <div id="batch-addlink-form" class="page-form  page-form-light pure-u-lg-1-3 pure-u-22-24">
      <h2 class="window-title"><?php echo t( "Shaare multiple new links" );?></h2>
      <form method="POST" action="<?php echo $base_path;?>/admin/shaare-batch" name="batch-addform" class="batch-addform">
        <div>
          <label for="urls"><?php echo t( 'Add one URL per line to create multiple bookmarks.' );?></label>
          <textarea name="urls" id="urls"></textarea>

          <div>
            <label for="tags"><?php echo t( 'Tags' );?></label>
          </div>
          <div>
            <input type="text" name="tags" id="tags" class="lf_input"
                   data-list="<?php $counter1=-1; if( isset($tags) && is_array($tags) && sizeof($tags) ) foreach( $tags as $key1 => $value1 ){ $counter1++; ?><?php echo $key1;?>, <?php } ?>" data-multiple data-autofirst autocomplete="off">
          </div>

          <div>
            <input type="hidden" name="private" value="0">
            <input type="checkbox" name="private" <?php if( $default_private_links ){ ?> checked="checked"<?php } ?>>
          &nbsp; <label for="lf_private"><?php echo t( 'Private' );?></label>
          </div>
        </div>
        <div>
          <input type="hidden" name="token" value="<?php echo $token;?>">
          <input type="submit" value="<?php echo t( 'Add links' );?>">
        </div>
      </form>
    </div>
  </div>
</div>

<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

</body>
</html>
