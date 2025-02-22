<?php if(!class_exists('raintpl')){exit;}?><?php echo '<?xml  version="1.0" encoding="UTF-8" ?>'; ?>

<rss version="2.0">
  <channel>
    <title><?php echo $localizedType;?> - <?php echo $title;?></title>
    <link><?php echo $index_url;?></link>
    <description><?php echo t('All links of one :type in a single page.', '', 1, 'shaarli', [':type' => t($type)]); ?></description>
    <language><?php echo $language;?></language>
    <copyright><?php echo $index_url;?></copyright>
    <generator>Shaarli</generator>

    <?php $counter1=-1; if( isset($days) && is_array($days) && sizeof($days) ) foreach( $days as $key1 => $value1 ){ $counter1++; ?>

      <item>
        <title><?php echo $value1["date_human"];?> - <?php echo $title;?></title>
        <guid><?php echo $value1["absolute_url"];?></guid>
        <link><?php echo $value1["absolute_url"];?></link>
        <pubDate><?php echo $value1["date_rss"];?></pubDate>
        <description><![CDATA[
          <?php $counter2=-1; if( isset($value1["links"]) && is_array($value1["links"]) && sizeof($value1["links"]) ) foreach( $value1["links"] as $key2 => $value2 ){ $counter2++; ?>

            <h3><a href="<?php echo $value2["url"];?>"><?php echo $value2["title"];?></a></h3>
            <small>
              <?php if( !$hide_timestamps ){ ?><?php echo format_date( $value2["created"] );?> &#8212; <?php } ?>

              <a href="<?php echo $index_url;?>shaare/<?php echo $value2["shorturl"];?>"><?php echo t( 'Permalink' );?></a>
              <?php if( $value2["tags"] ){ ?> &#8212; <?php echo $value2["tags"];?><?php } ?>

              <br>
              <?php echo $value2["url"];?>

            </small><br>
            <?php if( $value2["thumbnail"] ){ ?><img src="<?php echo $index_url;?><?php echo $value2["thumbnail"];?>" alt="thumbnail" /><?php } ?><br>
            <?php if( $value2["description"] ){ ?><?php echo $value2["description"];?><?php } ?>

            <br><hr>
          <?php } ?>

        ]]></description>
      </item>
    <?php } ?>

  </channel>
</rss><!-- Cached version of <?php echo $page_url;?> -->
