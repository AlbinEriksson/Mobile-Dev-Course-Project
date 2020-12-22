<?php

require_once __DIR__ . '/server.php';

$request = OAuth2\Request::createFromGlobals();

if(!$server->verifyResourceRequest($request)) {
    $server->getResponse()->send();
    die;
}

$accessToken = $storage->getAccessToken(substr($request->headers("Authorization"), 7));

if($accessToken === null) {
    http_response_code(500);
    echo json_encode(array(
        'error' => "server_error",
        'message' => "access token was verified, but unexpectedly not found"
    ));
    die;
}

if($storage->getUser($accessToken["user_id"]) === false) {
    http_response_code(500);
    echo json_encode(array(
        'error' => "server_error",
        'message' => "access token was verified, but no proper user was bound to it"
    ));
    die;
}

if($_SERVER["REQUEST_METHOD"] === "POST") {
    if(
        !isset($request->request["difficulty"]) ||
        !isset($request->request["type"]) ||
        !isset($request->request["accuracy"])
    ) {
        http_response_code(400);
        echo json_encode(array(
            'error' => "missing_parameters",
            'message' => "you must specify 'difficulty', 'type' and 'accuracy' in request body"
        ));
        die;
    }

    if(!$storage->difficultyExists($request->request("difficulty"))) {
        http_response_code(404);
        echo json_encode(array(
            'error' => "invalid_difficulty",
            'message' => "difficulty was invalid"
        ));
        die;
    }

    if(!$storage->testTypeExists($request->request("type"))) {
        http_response_code(404);
        echo json_encode(array(
            'error' => "invalid_type",
            'message' => "type was invalid"
        ));
        die;
    }

    $accuracy = $request->request("accuracy");

    if(gettype($accuracy) !== "double" && gettype($accuracy) !== "integer") {
        http_response_code(400);
        echo json_encode(array(
            'error' => "invalid_accuracy",
            'message' => "accuracy must be a float"
        ));
        die;
    }

    if($accuracy < 0 || $accuracy > 1) {
        http_response_code(400);
        echo json_encode(array(
            'error' => "invalid_accuracy",
            'message' => "accuracy must be between 0 and 1"
        ));
        die;
    }

    if(!$storage->addTestResult($accessToken["user_id"], $request->request("type"), $request->request("difficulty"), $request->request("accuracy"))) {
        http_response_code(500);
        echo json_encode(array(
            'error' => "server_error",
            'message' => "failed to add test result"
        ));
        die;
    }

    http_response_code(200);
    echo json_encode(array(
        'success' => true,
        'message' => "result was added successfully"
    ));
    die;
}

?>
