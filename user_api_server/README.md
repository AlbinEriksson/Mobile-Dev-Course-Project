# User API Server
This directory is the root of the user API.

## Setup
1. Execute `tables.sql` in an empty MySQL database schema.
2. Configure the variables in `server.php` according to your database connection.
3. Install an Apache web server (2.4.46+ recommended) with PHP version 7.4.x.
4. Set the `DocumentRoot` in the Apache config file to this directory.
5. Start the Apache web server.

## Documentation
All endpoints are documented in [https://aetias.gitbook.io/languide-user-api/].
