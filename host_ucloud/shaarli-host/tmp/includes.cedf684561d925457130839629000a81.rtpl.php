<?php if(!class_exists('raintpl')){exit;}?><title><?php echo $pagetitle;?></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="referrer" content="same-origin">
<link rel="alternate" type="application/atom+xml" href="<?php echo $feedurl;?>feed/atom?<?php echo $searchcrits;?>" title="ATOM Feed" />
<link rel="alternate" type="application/rss+xml" href="<?php echo $feedurl;?>feed/rss?<?php echo $searchcrits;?>" title="RSS Feed" />
<link href="<?php echo $asset_path;?>/img/favicon.png" rel="shortcut icon" type="image/png" />
<link href="<?php echo $asset_path;?>/img/apple-touch-icon.png" rel="apple-touch-icon" sizes="180x180" />
<link type="text/css" rel="stylesheet" href="<?php echo $asset_path;?>/css/shaarli.min.css?v=<?php echo $version_hash;?>" />
<?php if( strpos($formatter, 'markdown') !== false ){ ?>

  <link type="text/css" rel="stylesheet" href="<?php echo $asset_path;?>/css/markdown.min.css?v=<?php echo $version_hash;?>" />
<?php } ?>

<?php $counter1=-1; if( isset($plugins_includes["css_files"]) && is_array($plugins_includes["css_files"]) && sizeof($plugins_includes["css_files"]) ) foreach( $plugins_includes["css_files"] as $key1 => $value1 ){ $counter1++; ?>

  <link type="text/css" rel="stylesheet" href="<?php echo $root_path;?>/<?php echo $value1;?>?v=<?php echo $version_hash;?>"/>
<?php } ?>

<?php if( is_file('data/user.css') ){ ?>

  <link type="text/css" rel="stylesheet" href="<?php echo $root_path;?>/data/user.css" />
<?php } ?>

<link rel="search" type="application/opensearchdescription+xml" href="<?php echo $base_path;?>/open-search"
      title="Shaarli search - <?php echo $shaarlititle;?>" />
<?php if( $template === 'linklist' && ! empty($links) && count($links) === 1 ){ ?>

  <?php $link=$this->var['link']=reset($links);?>

  <meta property="og:title" content="<?php echo $link["title"];?>" />
  <meta property="og:type" content="article" />
  <meta property="og:url" content="<?php echo $index_url;?>shaare/<?php echo $link["shorturl"];?>" />
  <?php $ogDescription=$this->var['ogDescription']=isset($link["description_src"]) ? $link["description_src"] : $link["description"];?>

  <meta property="og:description" content="<?php echo substr(strip_tags($ogDescription), 0, 300); ?>" />
  <?php if( !empty($link["thumbnail"]) ){ ?>

    <meta property="og:image" content="<?php echo $index_url;?><?php echo $link["thumbnail"];?>" />
  <?php } ?>

  <?php if( !$hide_timestamps || $is_logged_in ){ ?>

    <meta property="article:published_time" content="<?php echo $link["created"]->format(DateTime::ATOM);?>" />
    <?php if( !empty($link["updated"]) ){ ?>

      <meta property="article:modified_time" content="<?php echo $link["updated"]->format(DateTime::ATOM);?>" />
    <?php } ?>

  <?php } ?>

  <?php $counter1=-1; if( isset($link["taglist"]) && is_array($link["taglist"]) && sizeof($link["taglist"]) ) foreach( $link["taglist"] as $key1 => $value1 ){ $counter1++; ?>

    <meta property="article:tag" content="<?php echo $value1;?>" />
  <?php } ?>

<?php } ?>

