# phantomjs_server

## Overview
A standalone phantomjs server that takes in Krake definitions via HTTP post via a RESTFUL API and return an array of results

## Requirements
- PhantomJS 1.8.1

## General settings
- The PhantomJS server will reside on port 9701
- The main file to call in this repository is server.js

## File System

- server.js
    - the main phantomJS server
    
- test/
    - a series of test files written to coffee-script that utitlizes jasmine-node in NodeJS for testing

- logs/
    - where the log files are written to

- shell/
    - the shell script for restarting the phantomjs server background process