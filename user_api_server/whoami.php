<?php

require_once __DIR__ . '/server.php';

if($_SERVER['REQUEST_METHOD'] == 'GET') {
    $request = OAuth2\Request::createFromGlobals();

    if(!$server->verifyResourceRequest($request)) {
        $server->getResponse()->send();
        die;
    }

    $accessToken = $storage->getAccessToken(substr($request->headers("Authorization"), 7));

    if($accessToken === null) {
        http_response_code(500);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "server_error",
            'message' => "access token was verified, but unexpectedly not found"
        ));
        die;
    }

    $user = $storage->getUser($accessToken["user_id"]);

    if($user === false) {
        http_response_code(500);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "server_error",
            'message' => "access token was verified, but no proper user was bound to it"
        ));
        die;
    }

    $user["email_verified"] = boolval($user["email_verified"]);
    unset($user["password"]);
    unset($user["username"]);

    http_response_code(200);
    header("Content-Type: application/json");
    echo json_encode(array(
        "success" => true,
        "data" => $user
    ));
}

?>
