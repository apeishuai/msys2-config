<?php if(!class_exists('raintpl')){exit;}?><div class="server-tables">
  <h3 class="window-subtitle"><?php echo t( 'Permissions' );?></h3>

  <?php if( count($permissions) > 0 ){ ?>

    <p class="center">
      <i class="fa fa-close fa-color-red" aria-hidden="true"></i>
      <?php echo t( 'There are permissions that need to be fixed.' );?>

    </p>

    <p>
      <?php $counter1=-1; if( isset($permissions) && is_array($permissions) && sizeof($permissions) ) foreach( $permissions as $key1 => $value1 ){ $counter1++; ?>

        <div class="center"><?php echo $value1;?></div>
      <?php } ?>

    </p>
  <?php }else{ ?>

    <p class="center">
      <i class="fa fa-check fa-color-green" aria-hidden="true"></i>
      <?php echo t( 'All read/write permissions are properly set.' );?>

    </p>
  <?php } ?>


  <h3 class="window-subtitle">PHP</h3>

  <p class="center">
    <strong><?php echo t( 'Running PHP' );?> <?php echo $php_version;?></strong>
    <?php if( $php_has_reached_eol ){ ?>

    <i class="fa fa-circle fa-color-orange" aria-label="hidden"></i><br>
    <?php echo t( 'End of life: ' );?> <?php echo $php_eol;?>

    <?php }else{ ?>

    <i class="fa fa-circle fa-color-green" aria-label="hidden"></i><br>
    <?php } ?>

  </p>

  <table class="center">
    <thead>
      <tr>
        <th><?php echo t( 'Extension' );?></th>
        <th><?php echo t( 'Usage' );?></th>
        <th><?php echo t( 'Status' );?></th>
        <th><?php echo t( 'Loaded' );?></th>
      </tr>
    </thead>
    <tbody>
      <?php $counter1=-1; if( isset($php_extensions) && is_array($php_extensions) && sizeof($php_extensions) ) foreach( $php_extensions as $key1 => $value1 ){ $counter1++; ?>

        <tr>
          <td><?php echo $value1["name"];?></td>
          <td><?php echo $value1["desc"];?></td>
          <td><?php echo $value1["required"] ? t('Required') : t('Optional');?></td>
          <td>
            <?php if( $value1["loaded"] ){ ?>

              <?php $classLoaded=$this->var['classLoaded']="fa-color-green";?>

              <?php $strLoaded=$this->var['strLoaded']=t('Loaded');?>

            <?php }else{ ?>

              <?php $strLoaded=$this->var['strLoaded']=t('Not loaded');?>

              <?php if( $value1["required"] ){ ?>

                <?php $classLoaded=$this->var['classLoaded']="fa-color-red";?>

              <?php }else{ ?>

                <?php $classLoaded=$this->var['classLoaded']="fa-color-orange";?>

              <?php } ?>

            <?php } ?>


            <i class="fa fa-circle <?php echo $classLoaded;?>" aria-label="<?php echo $strLoaded;?>" title="<?php echo $strLoaded;?>"></i>
          </td>
        </tr>
      <?php } ?>

    </tbody>
  </table>
</div>
