<?php

require_once __DIR__ . '/server.php';

$roleToScope = array(
    'student' => 'student',
    'teacher' => 'teacher'
);

$input = file_get_contents('php://input');
$json = json_decode($input, true);

if(!isset($json['password']) || !isset($json['email']) || !isset($json['firstName']) || !isset($json['role']))
{
    http_response_code(400);
    header('Content-Type: application/json');
    echo json_encode(array(
        'error' => true,
        'message' => "you must specify 'email', 'password', 'firstName' and 'role' in request body"
    ));
    die;
}

$email = $json['email'];
$password = $json['password'];
$firstName = $json['firstName'];
$lastName = null;

if(isset($json['lastName']))
{
    $lastName = $json['lastName'];
}

if(!isset($roleToScope[$json['role']]))
{
    http_response_code(400);
    header('Content-Type: application/json');
    echo json_encode(array(
        'error' => true,
        'message' => 'invalid role'
    ));
    die;
}

$scope = $roleToScope[$json['role']];

if($storage->getUser($email) !== false)
{
    http_response_code(409);
    header('Content-Type: application/json');
    echo json_encode(array(
        'error' => true,
        'message' => 'that email is already in use'
    ));
    die;
}

if(!$storage->setUser($email, $password, $scope, $firstName, $lastName))
{
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode(array(
        'error' => true,
        'message' => 'failed to register user'
    ));
    die;
}

http_response_code(201);
header('Content-Type: application/json');
echo json_encode(array(
    'success' => true,
    'message' => 'user was registered'
));

?>
