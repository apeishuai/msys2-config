<?php if(!class_exists('raintpl')){exit;}?></main>

<div class="pure-g">
  <div class="pure-u-2-24"></div>
  <footer id="footer" class="pure-u-20-24 footer-container" role="contentinfo">
    <i class="fa fa-shaarli" aria-hidden="true"></i>
    <strong><a href="https://github.com/shaarli/Shaarli">Shaarli</a></strong>
    <?php if( $is_logged_in===true ){ ?>

      <?php echo $version;?>

    <?php } ?>

    &middot;
    <?php echo t( 'The personal, minimalist, super fast, database-free, bookmarking service' );?> <?php echo t( 'by the Shaarli community' );?> &middot;
    <a href="<?php echo $root_path;?>/doc/html/index.html" rel="nofollow"><?php echo t( 'Documentation' );?></a>
      <?php $counter1=-1; if( isset($plugins_footer["text"]) && is_array($plugins_footer["text"]) && sizeof($plugins_footer["text"]) ) foreach( $plugins_footer["text"] as $key1 => $value1 ){ $counter1++; ?>

          <?php echo $value1;?>

      <?php } ?>

  </footer>
  <div class="pure-u-2-24"></div>
</div>

<?php $counter1=-1; if( isset($plugins_footer["endofpage"]) && is_array($plugins_footer["endofpage"]) && sizeof($plugins_footer["endofpage"]) ) foreach( $plugins_footer["endofpage"] as $key1 => $value1 ){ $counter1++; ?>

    <?php echo $value1;?>

<?php } ?>


<?php $counter1=-1; if( isset($plugins_footer["js_files"]) && is_array($plugins_footer["js_files"]) && sizeof($plugins_footer["js_files"]) ) foreach( $plugins_footer["js_files"] as $key1 => $value1 ){ $counter1++; ?>

	<script src="<?php echo $root_path;?>/<?php echo $value1;?>"></script>
<?php } ?>


<div id="js-translations" class="hidden" aria-hidden="true">
  <span id="translation-fold"><?php echo t( 'Fold' );?></span>
  <span id="translation-fold-all"><?php echo t( 'Fold all' );?></span>
  <span id="translation-expand"><?php echo t( 'Expand' );?></span>
  <span id="translation-expand-all"><?php echo t( 'Expand all' );?></span>
  <span id="translation-delete-link"><?php echo t( 'Are you sure you want to delete this link?' );?></span>
  <span id="translation-delete-tag"><?php echo t( 'Are you sure you want to delete this tag?' );?></span>
  <span id="translation-shaarli-desc">
    <?php echo t( 'The personal, minimalist, super fast, database-free, bookmarking service' );?> <?php echo t( 'by the Shaarli community' );?>

  </span>
</div>

<input type="hidden" name="js_base_path" value="<?php echo $base_path;?>" />
<input type="hidden" name="token" value="<?php echo $token;?>" id="token" />
<input type="hidden" name="tags_separator" value="<?php echo $tags_separator;?>" id="tags_separator" />

<script src="<?php echo $asset_path;?>/js/shaarli.min.js?v=<?php echo $version_hash;?>"></script>
