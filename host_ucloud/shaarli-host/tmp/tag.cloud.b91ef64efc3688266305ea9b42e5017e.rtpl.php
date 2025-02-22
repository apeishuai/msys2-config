<?php if(!class_exists('raintpl')){exit;}?><!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>
<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.header") . ( substr("page.header",-1,1) != "/" ? "/" : "" ) . basename("page.header") );?>


<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("tag.sort") . ( substr("tag.sort",-1,1) != "/" ? "/" : "" ) . basename("tag.sort") );?>


<div class="pure-g">
  <div class="pure-u-lg-1-6 pure-u-1-24"></div>
  <div class="pure-u-lg-2-3 pure-u-22-24 page-form page-visitor">
    <?php $countTags=$this->var['countTags']=count($tags);?>

    <h2 class="window-title"><?php echo t( 'Tag cloud' );?> - <?php echo $countTags;?> <?php echo t( 'tags' );?></h2>
    <?php if( !empty($search_tags) ){ ?>

    <p class="center">
      <a href="<?php echo $base_path;?>/?searchtags=<?php echo $search_tags_url;?>" class="pure-button pure-button-shaarli">
        <?php echo t( 'List all links with those tags' );?>

      </a>
    </p>
    <?php } ?>


    <div id="search-tagcloud" class="pure-g">
      <div class="pure-u-lg-1-4"></div>
      <div class="pure-u-1 pure-u-lg-1-2">
        <form method="GET">
          <input type="hidden" name="do" value="tagcloud">
          <input type="text" name="searchtags" aria-label="<?php echo t( 'Filter by tag' );?>" placeholder="<?php echo t( 'Filter by tag' );?>"
                 <?php if( !empty($search_tags) ){ ?>

                    value="<?php echo $search_tags;?>"
                 <?php } ?>

          autocomplete="off" data-multiple data-autofirst data-minChars="1"
          data-list="<?php $counter1=-1; if( isset($tags) && is_array($tags) && sizeof($tags) ) foreach( $tags as $key1 => $value1 ){ $counter1++; ?><?php echo $key1;?>, <?php } ?>"
          class="autofocus"
          >
          <button type="submit" class="search-button" aria-label="<?php echo t( 'Search' );?>"><i class="fa fa-search" aria-hidden="true"></i></button>
        </form>
      </div>
      <div class="pure-u-lg-1-4"></div>
    </div>

    <div id="plugin_zone_start_tagcloud" class="plugin_zone">
      <?php $counter1=-1; if( isset($plugin_start_zone) && is_array($plugin_start_zone) && sizeof($plugin_start_zone) ) foreach( $plugin_start_zone as $key1 => $value1 ){ $counter1++; ?>

        <?php echo $value1;?>

      <?php } ?>

    </div>

    <div id="cloudtag" class="cloudtag-container">
      <?php $counter1=-1; if( isset($tags) && is_array($tags) && sizeof($tags) ) foreach( $tags as $key1 => $value1 ){ $counter1++; ?>

        <a href="<?php echo $base_path;?>/?searchtags=<?php echo $tags_url["$key1"];?><?php echo urlencode( $tags_separator );?><?php echo $search_tags_url;?>" style="font-size:<?php echo $value1["size"];?>em;"><?php echo $key1;?></a
        ><a href="<?php echo $base_path;?>/add-tag/<?php echo $tags_url["$key1"];?>" title="<?php echo t( 'Filter by tag' );?>" class="count"><?php echo $value1["count"];?></a>
        <?php $counter2=-1; if( isset($value1["tag_plugin"]) && is_array($value1["tag_plugin"]) && sizeof($value1["tag_plugin"]) ) foreach( $value1["tag_plugin"] as $key2 => $value2 ){ $counter2++; ?>

          <?php echo $value2;?>

        <?php } ?>

      <?php } ?>

    </div>

    <div id="plugin_zone_end_tagcloud" class="plugin_zone">
      <?php $counter1=-1; if( isset($plugin_end_zone) && is_array($plugin_end_zone) && sizeof($plugin_end_zone) ) foreach( $plugin_end_zone as $key1 => $value1 ){ $counter1++; ?>

        <?php echo $value1;?>

      <?php } ?>

    </div>
  </div>
</div>

<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("tag.sort") . ( substr("tag.sort",-1,1) != "/" ? "/" : "" ) . basename("tag.sort") );?>


<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

</body>
</html>

