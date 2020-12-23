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
    header('Content-Type: application/json');
    echo json_encode(array(
        'error' => "server_error",
        'message' => "access token was verified, but unexpectedly not found"
    ));
    die;
}

if($storage->getUser($accessToken["user_id"]) === false) {
    http_response_code(500);
    header('Content-Type: application/json');
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
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "missing_parameters",
            'message' => "you must specify 'difficulty', 'type' and 'accuracy' in request body"
        ));
        die;
    }

    if(!$storage->difficultyExists($request->request("difficulty"))) {
        http_response_code(404);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "invalid_difficulty",
            'message' => "difficulty was invalid"
        ));
        die;
    }

    if(!$storage->testTypeExists($request->request("type"))) {
        http_response_code(404);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "invalid_type",
            'message' => "type was invalid"
        ));
        die;
    }

    $accuracy = $request->request("accuracy");

    if(gettype($accuracy) !== "double" && gettype($accuracy) !== "integer") {
        http_response_code(400);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "invalid_accuracy",
            'message' => "accuracy must be a float"
        ));
        die;
    }

    if($accuracy < 0 || $accuracy > 1) {
        http_response_code(400);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "invalid_accuracy",
            'message' => "accuracy must be between 0 and 1"
        ));
        die;
    }

    if(!$storage->addTestResult($accessToken["user_id"], $request->request("type"), $request->request("difficulty"), $request->request("accuracy"))) {
        http_response_code(500);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "server_error",
            'message' => "failed to add test result"
        ));
        die;
    }

    http_response_code(200);
    header('Content-Type: application/json');
    echo json_encode(array(
        'success' => true,
        'message' => "result was added successfully"
    ));
    die;
}
else if($_SERVER['REQUEST_METHOD'] == 'GET') {
    if(
        !isset($request->query['type']) ||
        !isset($request->query['unit']) ||
        !isset($request->query['amount'])
    ) {
        http_response_code(400);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "missing_parameters",
            'message' => "you must specify 'type', 'unit' and 'amount' in request body"
        ));
        die;
    }

    if(!$storage->testTypeExists($request->query("type"))) {
        http_response_code(404);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "invalid_type",
            'message' => "type was invalid"
        ));
        die;
    }

    $unit = $request->query('unit');
    if($unit !== "amount" && $unit !== "days" && $unit !== "weeks" && $unit !== "months" && $unit !== "years") {
        http_response_code(400);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "invalid_unit",
            'message' => "unit was invalid"
        ));
        die;
    }

    $amount = $request->query('amount');
    $amount = ctype_digit($amount) ? intval($amount) : null;
    if($amount === null || $amount < 1) {
        http_response_code(400);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "invalid_amount",
            'message' => "amount must be a positive integer"
        ));
        die;
    }

    $difficulty = $request->query('difficulty');
    if($difficulty !== null && !$storage->difficultyExists($difficulty)) {
        http_response_code(404);
        header('Content-Type: application/json');
        echo json_encode(array(
            'error' => "invalid_difficulty",
            'message' => "difficulty was invalid"
        ));
        die;
    }

    if($unit === "amount") {
        http_response_code(200);
        header('Content-Type: application/json');
        echo json_encode(array(
            'success' => true,
            'data' => $storage->getTestResultsByAmount($accessToken["user_id"], $request->query("type"), $difficulty, $amount)
        ));
    } else {
        $time = time();
        if($unit === "days") {
            $time = strtotime("-$amount days", $time);
        } else if($unit === "weeks") {
            $time = strtotime("-$amount weeks", $time);
        } else if($unit === "months") {
            $time = strtotime("-$amount months", $time);
        } else if($unit === "years") {
            $time = strtotime("-$amount years", $time);
        }

        http_response_code(200);
        header('Content-Type: application/json');
        echo json_encode(array(
            'success' => true,
            'data' => $storage->getTestResultsFromTime($accessToken["user_id"], $request->query("type"), $difficulty, $time)
        ));
    }
}

?>
