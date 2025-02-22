<?php if(!class_exists('raintpl')){exit;}?><?php echo '<?xml  version="1.0" encoding="UTF-8" ?>'; ?>

<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title><?php echo $pagetitle;?></title>
    <link><?php echo $index_url;?></link>
    <description>Shaared links</description>
    <language><?php echo $language;?></language>
    <copyright><?php echo $index_url;?></copyright>
    <generator>Shaarli</generator>
    <atom:link rel="self" href="<?php echo $self_link;?>" />
    <atom:link rel="search" type="application/opensearchdescription+xml" href="<?php echo $index_url;?>open-search#"
               title="Shaarli search - <?php echo $shaarlititle;?>" />
    <?php $counter1=-1; if( isset($feed_plugins_header) && is_array($feed_plugins_header) && sizeof($feed_plugins_header) ) foreach( $feed_plugins_header as $key1 => $value1 ){ $counter1++; ?>

      <?php echo $value1;?>

    <?php } ?>

    <?php $counter1=-1; if( isset($links) && is_array($links) && sizeof($links) ) foreach( $links as $key1 => $value1 ){ $counter1++; ?>

      <item>
        <title><?php echo $value1["title"];?></title>
        <guid isPermaLink="<?php if( $usepermalinks ){ ?>true<?php }else{ ?>false<?php } ?>"><?php echo $value1["guid"];?></guid>
        <?php if( $usepermalinks ){ ?>

          <link><?php echo $value1["guid"];?></link>
        <?php }else{ ?>

          <link><?php echo $value1["url"];?></link>
        <?php } ?>

        <?php if( $show_dates ){ ?>

          <pubDate><?php echo $value1["pub_iso_date"];?></pubDate>
          <atom:modified><?php echo $value1["up_iso_date"];?></atom:modified>
        <?php } ?>

        <description><![CDATA[<?php echo $value1["description"];?>]]></description>
        <?php $counter2=-1; if( isset($value1["taglist"]) && is_array($value1["taglist"]) && sizeof($value1["taglist"]) ) foreach( $value1["taglist"] as $key2 => $value2 ){ $counter2++; ?>

          <category domain="<?php echo $index_url;?>?searchtags="><?php echo $value2;?></category>
        <?php } ?>

        <?php $counter2=-1; if( isset($value1["feed_plugins"]) && is_array($value1["feed_plugins"]) && sizeof($value1["feed_plugins"]) ) foreach( $value1["feed_plugins"] as $key2 => $value2 ){ $counter2++; ?>

          <?php echo $value2;?>

        <?php } ?>

      </item>
    <?php } ?>

  </channel>
</rss>
