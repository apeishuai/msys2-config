<?php if(!class_exists('raintpl')){exit;}?><!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>
<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.header") . ( substr("page.header",-1,1) != "/" ? "/" : "" ) . basename("page.header") );?>


<div class="pure-g">
  <div class="pure-u-lg-1-3 pure-u-1-24"></div>
  <div class="pure-u-lg-1-3 pure-u-22-24 page-form page-form-light">
    <h2 class="window-title"><?php echo t( 'Settings' );?></h2>
    <div class="tools-item">
      <a href="<?php echo $base_path;?>/admin/configure" title="<?php echo t( 'Change Shaarli settings: title, timezone, etc.' );?>">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4"><?php echo t( 'Configure your Shaarli' );?></span>
      </a>
    </div>
    <div class="tools-item">
      <a href="<?php echo $base_path;?>/admin/plugins" title="<?php echo t( 'Enable, disable and configure plugins' );?>">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4"><?php echo t( 'Plugin administration' );?></span>
      </a>
    </div>
    <div class="tools-item">
      <a href="<?php echo $base_path;?>/admin/server"
         title="<?php echo t( 'Check instance\'s server configuration' );?>">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4"><?php echo t( 'Server administration' );?></span>
      </a>
    </div>
    <?php if( !$openshaarli ){ ?>

      <div class="tools-item">
        <a href="<?php echo $base_path;?>/admin/password" title="<?php echo t( 'Change your password' );?>">
          <span class="pure-button pure-u-lg-2-3 pure-u-3-4"><?php echo t( 'Change password' );?></span>
        </a>
      </div>
    <?php } ?>

    <div class="tools-item">
      <a href="<?php echo $base_path;?>/admin/tags" title="<?php echo t( 'Rename or delete a tag in all links' );?>">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4"><?php echo t( 'Manage tags' );?></span>
      </a>
    </div>
    <div class="tools-item">
      <a href="<?php echo $base_path;?>/admin/import"
         title="<?php echo t( 'Import Netscape HTML bookmarks (as exported from Firefox, Chrome, Opera, delicious...)' );?>">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4"><?php echo t( 'Import links' );?></span>
      </a>
    </div>
    <div class="tools-item">
      <a href="<?php echo $base_path;?>/admin/export"
         title="<?php echo t( 'Export Netscape HTML bookmarks (which can be imported in Firefox, Chrome, Opera, delicious...)' );?>">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4"><?php echo t( 'Export database' );?></span>
      </a>
    </div>

    <?php $counter1=-1; if( isset($tools_plugin) && is_array($tools_plugin) && sizeof($tools_plugin) ) foreach( $tools_plugin as $key1 => $value1 ){ $counter1++; ?>

      <div class="tools-item">
        <?php echo $value1;?>

      </div>
    <?php } ?>

  </div>


  <div class="clear"></div>
</div>

<div class="pure-g">
  <div class="pure-u-lg-1-3 pure-u-1-24"></div>
  <div class="pure-u-lg-1-3 pure-u-22-24 page-form page-form-light">
    <h2 class="window-title"><?php echo t( 'Bookmarklets' );?></h2>
    <p>
      <?php echo t( 'Drag one of these button to your bookmarks toolbar or right-click it and "Bookmark This Link"' );?>,
      <?php echo t( 'then click on the bookmarklet in any page you want to share.' );?>

    </p>
    <div class="tools-item">
      <a title="<?php echo t( 'Drag this link to your bookmarks toolbar or right-click it and Bookmark This Link' );?>,
                <?php echo t( 'then click ✚Shaare link button in any page you want to share' );?>"
         class="bookmarklet-link"
         href="javascript:(
          function(){
            var%20url%20=%20location.href;
            var%20title%20=%20document.title%20||%20url;
            var%20desc=document.getSelection().toString();
            if(desc.length>4000){
              desc=desc.substr(0,4000)+'...';
              alert('<?php echo str_replace(' ', '%20', t('The selected text is too long, it will be truncated.')); ?>');
            }
            window.open(
              '<?php echo $pageabsaddr;?>admin/shaare?post='%20+%20encodeURIComponent(url)+
              '&amp;title='%20+%20encodeURIComponent(title)+
              '&amp;description='%20+%20encodeURIComponent(desc)+
              '&amp;source=bookmarklet','_blank','menubar=no,height=800,width=600,toolbar=no,scrollbars=yes,status=no,dialog=1'
            );
          }
        )();">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4">✚ <?php echo t( 'Shaare link' );?></span>
      </a>
    </div>
    <div class="tools-item">
      <a title="<?php echo t( 'Drag this link to your bookmarks toolbar or right-click it and Bookmark This Link' );?>,
                <?php echo t( 'Then click ✚Add Note button anytime to start composing a private Note (text post) to your Shaarli' );?>"
         class="bookmarklet-link"
         href="javascript:(
          function(){
            var%20desc=document.getSelection().toString();
            if(desc.length>4000){
              desc=desc.substr(0,4000)+'...';
              alert('<?php echo str_replace(' ', '%20', t('The selected text is too long, it will be truncated.')); ?>');
            }
            window.open(
              '<?php echo $pageabsaddr;?>admin/shaare?private=1&amp;post='+
              '&amp;description='%20+%20encodeURIComponent(desc)+
              '&amp;source=bookmarklet','_blank','menubar=no,height=800,width=600,toolbar=no,scrollbars=yes,status=no,dialog=1'
            );
          }
        )();">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4">✚ <?php echo t( 'Add Note' );?></span>
      </a>
    </div>
  </div>
</div>

<div class="pure-g">
  <div class="pure-u-lg-1-3 pure-u-1-24"></div>
  <div class="pure-u-lg-1-3 pure-u-22-24 page-form page-form-light">
    <h2 class="window-title"><?php echo t( 'Third-party resources' );?></h2>
    <div class="tools-item">
      <a href="https://shaarli.readthedocs.io/en/master/Community-and-related-software.html">
        <span class="pure-button pure-u-lg-2-3 pure-u-3-4"><?php echo t( 'Community and related software' );?></span>
      </a>
    </div>
  </div>
</div>

<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

<input type="hidden" id="bookmarklet-alert"
       value="<?php echo t( 'Drag this link to your bookmarks toolbar, or right-click it and choose Bookmark This Link' );?>">
</body>
</html>
