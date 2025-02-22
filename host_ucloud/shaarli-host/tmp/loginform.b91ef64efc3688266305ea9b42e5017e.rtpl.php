<?php if(!class_exists('raintpl')){exit;}?><!DOCTYPE html>
<html<?php if( $language !== 'auto' ){ ?> lang="<?php echo $language;?>"<?php } ?>>
<head>
  <?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("includes") . ( substr("includes",-1,1) != "/" ? "/" : "" ) . basename("includes") );?>

</head>
<body>
<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.header") . ( substr("page.header",-1,1) != "/" ? "/" : "" ) . basename("page.header") );?>

<div class="pure-g">
  <div class="pure-u-lg-1-3 pure-u-1-24"></div>
  <div id="login-form" class="page-form page-form-light pure-u-lg-1-3 pure-u-22-24 login-form-container">
    <form method="post" name="loginform">
      <h2 class="window-title"><?php echo t( 'Login' );?></h2>
      <div>
        <input type="text" name="login" aria-label="<?php echo t( 'Username' );?>" placeholder="<?php echo t( 'Username' );?>"
           <?php if( !empty($username) ){ ?>value="<?php echo $username;?>"<?php } ?> class="autofocus" autocapitalize="off">
      </div>
      <div>
        <input type="password" name="password" aria-label="<?php echo t( 'Password' );?>" placeholder="<?php echo t( 'Password' );?>" class="autofocus">
      </div>
      <div class="remember-me">
        <input type="checkbox" name="longlastingsession" id="longlastingsessionform"
           <?php if( $remember_user_default ){ ?>checked="checked"<?php } ?>>
        <label for="longlastingsessionform"><?php echo t( 'Remember me' );?></label>
      </div>
      <div>
        <input type="submit" value="<?php echo t( 'Login' );?>" class="bigbutton">
      </div>
      <input type="hidden" name="token" value="<?php echo $token;?>">
      <?php if( $returnurl ){ ?><input type="hidden" name="returnurl" value="<?php echo $returnurl;?>"><?php } ?>

    </form>
  </div>
  <div class="pure-u-lg-1-3 pure-u-1-8"></div>
</div>

<?php $tpl = new RainTpl;$tpl_dir_temp = self::$tpl_dir;$tpl->assign( $this->var );$tpl->draw( dirname("page.footer") . ( substr("page.footer",-1,1) != "/" ? "/" : "" ) . basename("page.footer") );?>

</body>
</html>
