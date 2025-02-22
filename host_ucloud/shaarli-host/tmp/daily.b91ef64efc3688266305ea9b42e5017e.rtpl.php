<?php if(!class_exists('raintpl')){exit;}?><!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>
<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.header") . ( substr("page.header",-1,1) != "/" ? "/" : "" ) . basename("page.header") );?>


<div class="pure-g">
  <div class="pure-u-1 pure-alert pure-alert-success tag-sort">
    <a href="<?php echo $base_path;?>/daily?day"><?php echo t( 'Daily' );?></a>
    <a href="<?php echo $base_path;?>/daily?week"><?php echo t( 'Weekly' );?></a>
    <a href="<?php echo $base_path;?>/daily?month"><?php echo t( 'Monthly' );?></a>
  </div>
</div>


<div class="pure-g">
  <div class="pure-u-lg-1-6 pure-u-1-24"></div>
  <div class="pure-u-lg-2-3 pure-u-22-24 page-form page-visitor" id="daily">
    <h2 class="window-title">
      <?php echo $localizedType;?> Shaarli
      <a href="<?php echo $base_path;?>/daily-rss?<?php echo $type;?>"
         title="<?php echo t('1 RSS entry per :type', '', 1, 'shaarli', [':type' => t($type)]); ?>"
      >
        <i class="fa fa-rss"></i>
      </a>
    </h2>

    <div id="plugin_zone_start_daily" class="plugin_zone">
      <?php $counter1=-1; if( isset($plugin_start_zone) && is_array($plugin_start_zone) && sizeof($plugin_start_zone) ) foreach( $plugin_start_zone as $key1 => $value1 ){ $counter1++; ?>

        <?php echo $value1;?>

      <?php } ?>

    </div>

    <div class="daily-about">

      <div class="pure-g">
        <div class="pure-u-lg-1-3 pure-u-1 center">
          <?php if( $previousday ){ ?>

            <a href="<?php echo $base_path;?>/daily?<?php echo $type;?>=<?php echo $previousday;?>">
              <i class="fa fa-arrow-left"></i>
              <?php echo t('Previous :type', '', 1, 'shaarli', [':type' => t($type)], true); ?>

            </a>
          <?php } ?>

        </div>
        <div class="daily-desc pure-u-lg-1-3 pure-u-1 center">
          <?php echo t('All links of one :type in a single page.', '', 1, 'shaarli', [':type' => t($type)]); ?>

        </div>
        <div class="pure-u-lg-1-3 pure-u-1 center">
          <?php if( $nextday ){ ?>

            <a href="<?php echo $base_path;?>/daily?<?php echo $type;?>=<?php echo $nextday;?>">
              <?php echo t('Next :type', '', 1, 'shaarli', [':type' => t($type)], true); ?>

              <i class="fa fa-arrow-right"></i>
            </a>
          <?php } ?>

        </div>
      </div>
      <div>
        <h3 class="window-subtitle">
          <?php echo $dayDesc;?>

        </h3>

        <div id="plugin_zone_about_daily" class="plugin_zone">
          <?php $counter1=-1; if( isset($daily_about_plugin) && is_array($daily_about_plugin) && sizeof($daily_about_plugin) ) foreach( $daily_about_plugin as $key1 => $value1 ){ $counter1++; ?>

            <?php echo $value1;?>

          <?php } ?>

        </div>
      </div>
    </div>


    <?php if( $linksToDisplay ){ ?>

      <div class="pure-g">
        <?php $counter1=-1; if( isset($cols) && is_array($cols) && sizeof($cols) ) foreach( $cols as $key1 => $value1 ){ $counter1++; ?>

          <?php if( isset($value1["0"]) ){ ?>

            <div class="pure-u-lg-1-3 pure-u-1">
              <?php $counter2=-1; if( isset($value1) && is_array($value1) && sizeof($value1) ) foreach( $value1 as $key2 => $value2 ){ $counter2++; ?>

                <?php $link=$this->var['link']=$value2;?>

                <div class="daily-entry">
                  <div class="daily-entry-title center">
                    <a href="<?php echo $base_path;?>/shaare/<?php echo $link["shorturl"];?>" title="<?php echo t( 'Permalink' );?>">
                      <i class="fa fa-link"></i>
                    </a>
                    <a href="<?php echo $link["real_url"];?>"><?php echo $link["title"];?></a>
                  </div>
                  <?php if( $thumbnails_enabled && !empty($link["thumbnail"]) ){ ?>

                    <div class="daily-entry-thumbnail">
                      <img data-src="<?php echo $root_path;?>/<?php echo $link["thumbnail"];?>" class="b-lazy"
                           src=""
                           alt="thumbnail" width="<?php echo $thumbnails_width;?>" height="<?php echo $thumbnails_height;?>" />
                    </div>
                  <?php } ?>

                  <div class="daily-entry-description"><?php echo $link["formatedDescription"];?></div>
                  <?php if( $link["tags"] ){ ?>

                    <div class="daily-entry-tags center">
                      <?php $counter3=-1; if( isset($link["taglist"]) && is_array($link["taglist"]) && sizeof($link["taglist"]) ) foreach( $link["taglist"] as $key3 => $value3 ){ $counter3++; ?>

                        <span class="label label-tag">
                          <?php echo $value3;?>

                        </span>
                      <?php } ?>

                    </div>
                  <?php } ?>

                  <div class="dailyEntryFooter clear">
                    <?php $counter3=-1; if( isset($link["link_plugin"]) && is_array($link["link_plugin"]) && sizeof($link["link_plugin"]) ) foreach( $link["link_plugin"] as $key3 => $value3 ){ $counter3++; ?>

                      <?php echo $value3;?>

                    <?php } ?>

                  </div>
                </div>
              <?php } ?>

            </div>
          <?php } ?>

        <?php } ?>

      </div>
    <?php }else{ ?>

      <div class="dailyNoEntry">No articles on this day.</div>
    <?php } ?>


    <div class="clear"></div>

    <div id="plugin_zone_end_picwall" class="plugin_zone">
      <?php $counter1=-1; if( isset($plugin_end_zone) && is_array($plugin_end_zone) && sizeof($plugin_end_zone) ) foreach( $plugin_end_zone as $key1 => $value1 ){ $counter1++; ?>

        <?php echo $value1;?>

      <?php } ?>

    </div>
  </div>
</div>
<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

<script src="<?php echo $asset_path;?>/js/thumbnails.min.js?v=<?php echo $version_hash;?>"></script>
</body>
</html>

