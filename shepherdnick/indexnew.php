<?php include('header.txt'); ?>

<?php

if ($page=="") {
include ("home.inc");
}

elseif ($page=="about") {
include ("site/aboutme.html");
}

else {
echo "That is not a valid location!";
}

?>
<?php include('footer.txt'); ?>
