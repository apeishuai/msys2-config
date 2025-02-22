<?php if(!class_exists('raintpl')){exit;}?><!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>

<?php $ratioLabel=$this->var['ratioLabel']='1-4';?>

<?php $ratioInput=$this->var['ratioInput']='3-4';?>

<?php $ratioLabelMobile=$this->var['ratioLabelMobile']='7-8';?>

<?php $ratioInputMobile=$this->var['ratioInputMobile']='1-8';?>


<form method="POST" action="<?php echo $base_path;?>/install" name="installform" id="installform">
<div class="pure-g">
  <div class="pure-u-lg-1-6 pure-u-1-24"></div>
  <div class="pure-u-lg-2-3 pure-u-22-24 page-form page-form-complete">
    <h2 class="window-title"><?php echo t( 'Install Shaarli' );?></h2>

    <div class="center">
      <p><?php echo t( 'It looks like it\'s the first time you run Shaarli. Please configure it.' );?></p>
    </div>

    <div class="pure-g">
      <div class="pure-u-lg-<?php echo $ratioLabel;?> pure-u-1">
        <div class="form-label">
          <label for="username">
            <span class="label-name"><?php echo t( 'Username' );?></span>
          </label>
        </div>
      </div>
      <div class="pure-u-lg-<?php echo $ratioInput;?> pure-u-1">
        <div class="form-input">
          <input type="text" name="setlogin" id="username" autocapitalize="off">
        </div>
      </div>
    </div>

    <div class="pure-g">
      <div class="pure-u-lg-<?php echo $ratioLabel;?> pure-u-1">
        <div class="form-label">
          <label for="password">
            <span class="label-name"><?php echo t( 'Password' );?></span>
          </label>
        </div>
      </div>
      <div class="pure-u-lg-<?php echo $ratioInput;?> pure-u-1">
        <div class="form-input">
          <input type="password" name="setpassword" id="password">
        </div>
      </div>
    </div>

    <div class="pure-g">
      <div class="pure-u-lg-<?php echo $ratioLabel;?> pure-u-1">
        <div class="form-label">
          <label for="title">
            <span class="label-name"><?php echo t( 'Shaarli title' );?></span>
          </label>
        </div>
      </div>
      <div class="pure-u-lg-<?php echo $ratioInput;?> pure-u-1">
        <div class="form-input">
          <input type="text" name="title" id="title" placeholder="<?php echo t( 'My links' );?>">
        </div>
      </div>
    </div>

    <div class="pure-g">
      <div class="pure-u-lg-<?php echo $ratioLabel;?> pure-u-1">
        <div class="form-label">
          <label for="language">
            <span class="label-name"><?php echo t( 'Languages' );?></span>
          </label>
        </div>
      </div>
      <div class="pure-u-lg-<?php echo $ratioInput;?> pure-u-1">
        <div class="form-input">
          <select name="language" id="language" class="align">
            <?php $counter1=-1; if( isset($languages) && is_array($languages) && sizeof($languages) ) foreach( $languages as $key1 => $value1 ){ $counter1++; ?>

              <option value="<?php echo $key1;?>">
                <?php echo $value1;?>

              </option>
            <?php } ?>

          </select>
        </div>
      </div>
    </div>

    <div class="pure-g">
      <div class="pure-u-lg-<?php echo $ratioLabel;?> pure-u-1">
        <div class="form-label">
          <label>
            <span class="label-name"><?php echo t( 'Timezone' );?></span><br>
            <span class="label-desc"><?php echo t( 'Continent' );?> &middot; <?php echo t( 'City' );?></span>
          </label>
        </div>
      </div>
      <div class="pure-u-lg-<?php echo $ratioInput;?> pure-u-1">
        <div class="form-input">
          <div class="timezone">
            <select id="continent" name="continent">
              <?php $counter1=-1; if( isset($continents) && is_array($continents) && sizeof($continents) ) foreach( $continents as $key1 => $value1 ){ $counter1++; ?>

                <?php if( $key1 !== 'selected' ){ ?>

                  <option value="<?php echo $value1;?>" <?php if( $continents["selected"] === $value1 ){ ?>selected<?php } ?>>
                    <?php echo $value1;?>

                  </option>
                <?php } ?>

              <?php } ?>

            </select>
            <select id="city" name="city">
              <?php $counter1=-1; if( isset($cities) && is_array($cities) && sizeof($cities) ) foreach( $cities as $key1 => $value1 ){ $counter1++; ?>

                <?php if( $key1 !== 'selected' ){ ?>

                  <option value="<?php echo $value1["city"];?>"
                          <?php if( $cities["selected"] === $value1["city"] ){ ?>selected<?php } ?>

                          data-continent="<?php echo $value1["continent"];?>">
                    <?php echo $value1["city"];?>

                  </option>
                <?php } ?>

              <?php } ?>

            </select>
          </div>
        </div>
      </div>
    </div>

    <div class="pure-g">
      <div class="pure-u-lg-<?php echo $ratioLabel;?> pure-u-7-8">
        <div class="form-label">
          <label for="update">
            <span class="label-name"><?php echo t( 'Check for updates' );?></span><br>
            <span class="label-desc">
              <?php echo t( 'Notify me when a new release is ready' );?>

            </span>
          </label>
        </div>
      </div>
      <div class="pure-u-lg-<?php echo $ratioInput;?> pure-u-1-8">
        <div class="form-input">
          <input type="checkbox" name="updateCheck" id="update" checked="checked">
        </div>
      </div>
    </div>

    <div class="pure-g">
      <div class="pure-u-lg-<?php echo $ratioLabel;?> pure-u-<?php echo $ratioLabelMobile;?>">
        <div class="form-label">
          <label for="enableApi">
            <span class="label-name"><?php echo t( 'Enable REST API' );?></span><br>
            <span class="label-desc"><?php echo t( 'Allow third party software to use Shaarli such as mobile application' );?></span>
          </label>
        </div>
      </div>
      <div class="pure-u-lg-<?php echo $ratioInput;?> pure-u-<?php echo $ratioInputMobile;?>">
        <div class="form-input">
          <input type="checkbox" name="enableApi" id="enableApi" checked />
        </div>
      </div>
    </div>

    <div class="center">
      <input type="submit" value="<?php echo t( 'Install' );?>" name="Save">
    </div>
  </div>
</div>
</form>

<div class="pure-g">
  <div class="pure-u-lg-1-6 pure-u-1-24"></div>
  <div class="pure-u-lg-2-3 pure-u-22-24 page-form page-form-complete">
    <h2 class="window-title"><?php echo t( 'Server requirements' );?></h2>

    <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("server.requirements") . ( substr("server.requirements",-1,1) != "/" ? "/" : "" ) . basename("server.requirements") );?>

  </div>
</div>

<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

</body>
</html>
