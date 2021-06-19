<?php
header( "refresh:2;url=./status" );
system( 'sudo /usr/local/bin/net-setup.sh ' . htmlspecialchars($_POST["wifi"]) . ' ' . htmlspecialchars($_POST["password"] ) ); ?>
