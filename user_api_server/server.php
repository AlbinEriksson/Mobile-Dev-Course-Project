<?php

// ----------------------------------------------------------------
// NOTE: The variables below need to be changed according to your
// database connection setup.
$host = 'localhost';
$username = '';
$password = '';
$schema = '';
// ----------------------------------------------------------------

$dsn = "mysql:dbname=$schema;host=$host";

// Error reporting, disable on release
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once('oauth2-server-php/src/OAuth2/Autoloader.php');
OAuth2\Autoloader::register();

$storage = new OAuth2\Storage\Pdo(array('dsn' => $dsn, 'username' => $username, 'password' => $password));

$server = new OAuth2\Server($storage);

$server->addGrantType(new OAuth2\GrantType\UserCredentials($storage));
$server->addGrantType(new OAuth2\GrantType\RefreshToken($storage, array(
    'always_issue_new_refresh_token' => true
)));

?>
