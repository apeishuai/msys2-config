<?php if(!class_exists('raintpl')){exit;}?><?php $batchId=$this->var['batchId']=isset($batchId) ? $batchId : '';?>

<?php if( empty($batch_mode) ){ ?>

<!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.header") . ( substr("page.header",-1,1) != "/" ? "/" : "" ) . basename("page.header") );?>

<?php }else{ ?>

  
  <?php echo extract($value) ? '' : ''; ?>

<?php } ?>

  <div id="editlinkform<?php echo $batchId;?>" class="edit-link-container" class="pure-g">
    <div class="pure-u-lg-1-5 pure-u-1-24"></div>
    <form method="post"
          name="linkform"
          action="<?php echo $base_path;?>/admin/shaare"
          class="page-form pure-u-lg-3-5 pure-u-22-24 page-form page-form-light"
    >
      <?php $asyncLoadClass=$this->var['asyncLoadClass']=$link_is_new && $async_metadata && empty($link["title"]) ? 'loading-input' : '';?>


      <h2 class="window-title">
        <?php if( !$link_is_new ){ ?><?php echo t( 'Edit Shaare' );?><?php }else{ ?><?php echo t( 'New Shaare' );?><?php } ?>

      </h2>
      <?php if( isset($link["id"]) ){ ?>

        <input type="hidden" name="lf_id" value="<?php echo $link["id"];?>">
      <?php } ?>

      <?php if( !$link_is_new ){ ?><div class="created-date"><?php echo t( 'Created:' );?> <?php echo format_date( $link["created"] );?></div><?php } ?>

      <div>
        <label for="lf_url<?php echo $batchId;?>"><?php echo t( 'URL' );?></label>
      </div>
      <div>
        <input type="text" name="lf_url" id="lf_url<?php echo $batchId;?>" value="<?php echo $link["url"];?>" class="lf_input">
      </div>
      <div>
      <label for="lf_title<?php echo $batchId;?>"><?php echo t( 'Title' );?></label>
      </div>
      <div class="<?php echo $asyncLoadClass;?>">
        <input type="text" name="lf_title" id="lf_title<?php echo $batchId;?>" value="<?php echo $link["title"];?>"
         class="lf_input <?php if( !$async_metadata ){ ?>autofocus<?php } ?>"
        >
        <div class="icon-container">
          <i class="loader"></i>
        </div>
      </div>
      <div>
        <label for="lf_description<?php echo $batchId;?>"><?php echo t( 'Description' );?></label>
      </div>
      <div class="<?php if( $retrieve_description ){ ?><?php echo $asyncLoadClass;?><?php } ?>">
        <textarea name="lf_description" id="lf_description<?php echo $batchId;?>" class="autofocus"><?php echo $link["description"];?></textarea>
        <div class="icon-container">
          <i class="loader"></i>
        </div>
      </div>
      <div>
        <label for="lf_tags<?php echo $batchId;?>"><?php echo t( 'Tags' );?></label>
      </div>
      <div class="<?php if( $retrieve_description ){ ?><?php echo $asyncLoadClass;?><?php } ?>">
        <input type="text" name="lf_tags" id="lf_tags<?php echo $batchId;?>" value="<?php echo $link["tags"];?>" class="lf_input autofocus"
          data-list="<?php $counter1=-1; if( isset($tags) && is_array($tags) && sizeof($tags) ) foreach( $tags as $key1 => $value1 ){ $counter1++; ?><?php echo $key1;?>, <?php } ?>" data-multiple data-autofirst autocomplete="off" >
        <div class="icon-container">
          <i class="loader"></i>
        </div>
      </div>

      <div>
        <input type="checkbox"  name="lf_private" id="lf_private<?php echo $batchId;?>"
        <?php if( $link["private"] === true ){ ?>

          checked="checked"
        <?php } ?>>
        &nbsp;<label for="lf_private<?php echo $batchId;?>"><?php echo t( 'Private' );?></label>
      </div>

      <?php if( $formatter==='markdown' ){ ?>

        <div class="md_help">
          <?php echo t( 'Description will be rendered with' );?>

          <a href="http://daringfireball.net/projects/markdown/syntax" title="<?php echo t( 'Markdown syntax documentation' );?>">
            <?php echo t( 'Markdown syntax' );?>

          </a>.
        </div>
      <?php } ?>


      <div id="editlink-plugins">
        <?php $counter1=-1; if( isset($edit_link_plugin) && is_array($edit_link_plugin) && sizeof($edit_link_plugin) ) foreach( $edit_link_plugin as $key1 => $value1 ){ $counter1++; ?>

          <?php echo $value1;?>

        <?php } ?>

      </div>


      <div class="submit-buttons center">
        <?php if( !empty($batch_mode) ){ ?>

          <a href="#" class="button button-grey" name="cancel-batch-link"
            title="{'Remove this bookmark from batch creation/modification.'}"
          >
            <?php echo t( 'Cancel' );?>

          </a>
        <?php } ?>

        <input type="submit" name="save_edit" class="" id="button-save-edit"
               value="<?php if( $link_is_new ){ ?><?php echo t( 'Save' );?><?php }else{ ?><?php echo t( 'Apply Changes' );?><?php } ?>">
        <?php if( !$link_is_new ){ ?>

        <a href="<?php echo $base_path;?>/admin/shaare/delete?id=<?php echo $link["id"];?>&amp;token=<?php echo $token;?>"
           title="" name="delete_link" class="button button-red confirm-delete">
          <?php echo t( 'Delete' );?>

        </a>
        <?php } ?>

      </div>

      <input type="hidden" name="token" value="<?php echo $token;?>">
      <input type="hidden" name="source" value="<?php echo $source;?>">
      <?php if( $http_referer ){ ?>

        <input type="hidden" name="returnurl" value="<?php echo $http_referer;?>">
      <?php } ?>

    </form>
  </div>

<?php if( empty($batch_mode) ){ ?>

  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

  <?php if( $link_is_new && $async_metadata ){ ?><script src="<?php echo $asset_path;?>/js/metadata.min.js?v=<?php echo $version_hash;?>"></script><?php } ?>

</body>
</html>
<?php } ?>

