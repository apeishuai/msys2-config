<?php if(!class_exists('raintpl')){exit;}?><?php echo '<?xml  version="1.0" encoding="UTF-8" ?>'; ?>

<feed xmlns="http://www.w3.org/2005/Atom">
  <title><?php echo $pagetitle;?></title>
  <subtitle>Shaared links</subtitle>
  <?php if( $show_dates ){ ?>

    <updated><?php echo $last_update;?></updated>
  <?php } ?>

  <link rel="self" href="<?php echo $self_link;?>" />
  <link rel="search" type="application/opensearchdescription+xml" href="<?php echo $index_url;?>open-search"
        title="Shaarli search - <?php echo $shaarlititle;?>" />
  <?php $counter1=-1; if( isset($feed_plugins_header) && is_array($feed_plugins_header) && sizeof($feed_plugins_header) ) foreach( $feed_plugins_header as $key1 => $value1 ){ $counter1++; ?>

    <?php echo $value1;?>

  <?php } ?>

  <author>
    <name><?php echo $pagetitle;?></name>
    <uri><?php echo $index_url;?></uri>
  </author>
  <id><?php echo $index_url;?></id>
  <generator>Shaarli</generator>
  <?php $counter1=-1; if( isset($links) && is_array($links) && sizeof($links) ) foreach( $links as $key1 => $value1 ){ $counter1++; ?>

    <entry>
      <title><?php echo $value1["title"];?></title>
      <?php if( $usepermalinks ){ ?>

        <link href="<?php echo $value1["guid"];?>" />
      <?php }else{ ?>

        <link href="<?php echo $value1["url"];?>" />
      <?php } ?>

      <id><?php echo $value1["guid"];?></id>
      <?php if( $show_dates ){ ?>

        <published><?php echo $value1["pub_iso_date"];?></published>
        <updated><?php echo $value1["up_iso_date"];?></updated>
      <?php } ?>

      <content type="html" xml:lang="<?php echo $language;?>"><![CDATA[<?php echo $value1["description"];?>]]></content>
      <?php $counter2=-1; if( isset($value1["taglist"]) && is_array($value1["taglist"]) && sizeof($value1["taglist"]) ) foreach( $value1["taglist"] as $key2 => $value2 ){ $counter2++; ?>

        <category scheme="<?php echo $index_url;?>?searchtags=" term="<?php echo strtolower( $value2 );?>" label="<?php echo $value2;?>" />
      <?php } ?>

      <?php $counter2=-1; if( isset($value1["feed_plugins"]) && is_array($value1["feed_plugins"]) && sizeof($value1["feed_plugins"]) ) foreach( $value1["feed_plugins"] as $key2 => $value2 ){ $counter2++; ?>

        <?php echo $value2;?>

      <?php } ?>

    </entry>
  <?php } ?>

</feed>
