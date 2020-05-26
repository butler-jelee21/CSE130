#!/usr/bin/env bash

# Author: Jesse Lee
# Test script for CSE 130 Assignment 2: Multi-threaded HTTP Server with logging 

# start server with valgrind logging enabled
start_server() {
    valgrind --log-file=vgrind.server.out ./httpserver 8080 -N 5 -l server.log &
    sleep 5s
}

# start server normally with logging enabled
start_server2 () {
    ./httpserver 8080 -N 3 -l server.log &
    sleep 3s
}

# terminate server
kill_server() {
    pkill httpserver
}

# check for failure and report all failures with a copy of server log
check_test() {
    pgrep -f "valgrind" | xargs kill -15
    if grep "FAIL" mintest.out; then
        cp server.log server.log.copy
        exit 1
    fi
}

# testing single valid request with logging enabled
# includes PUT, GET, and HEAD for different sizes
test_zero() {
    ################ generate all files used and expected output ################
    head -c 1 /dev/urandom > test1.zero.bin
    head -c 111 /dev/urandom > test2.zero.bin
    head -c 2000 /dev/urandom > test3.zero.bin
    head -c 111111 /dev/urandom > test4.zero.bin

    sizen=$(stat -c%s test1.zero.bin)
    size2=$(stat -c%s test2.zero.bin)
    size3=$(stat -c%s test3.zero.bin)
    size4=$(stat -c%s test4.zero.bin)

    # logging expected output for PUT
    printf "PUT /tfile1 length $sizen\n" > test1.zero.expectedlog1.out
    python3 hex.py test1.zero.bin >> test1.zero.expectedlog1.out
    printf "========\n" >> test1.zero.expectedlog1.out

    printf "PUT /tfile2 length $size2\n" > test2.zero.expectedlog2.out
    python3 hex.py test2.zero.bin >> test2.zero.expectedlog2.out
    printf "========\n" >> test2.zero.expectedlog2.out

    printf "PUT /tfile3 length $size3\n" > test3.zero.expectedlog3.out
    python3 hex.py test3.zero.bin >> test3.zero.expectedlog3.out
    printf "========\n" >> test3.zero.expectedlog3.out

    printf "PUT /tfile4 length $size4\n" > test4.zero.expectedlog4.out
    python3 hex.py test4.zero.bin >> test4.zero.expectedlog4.out
    printf "========\n" >> test4.zero.expectedlog4.out

    # logging expected output for GET
    printf "GET /tfile1 length $sizen\n" > test5.zero.expectedlog5.out
    python3 hex.py test1.zero.bin >> test5.zero.expectedlog5.out
    printf "========\n" >> test5.zero.expectedlog5.out

    printf "GET /tfile2 length $size2\n" > test6.zero.expectedlog6.out
    python3 hex.py test2.zero.bin >> test6.zero.expectedlog6.out
    printf "========\n" >> test6.zero.expectedlog6.out

    printf "GET /tfile3 length $size3\n" > test7.zero.expectedlog7.out
    python3 hex.py test3.zero.bin >> test7.zero.expectedlog7.out
    printf "========\n" >> test7.zero.expectedlog7.out

    printf "GET /tfile4 length $size4\n" > test8.zero.expectedlog8.out
    python3 hex.py test4.zero.bin >> test8.zero.expectedlog8.out
    printf "========\n" >> test8.zero.expectedlog8.out

    # logging expeceted output for HEAD
    printf "HTTP/1.1 200 OK\r\nContent-Length: $sizen\r\n\r\n" > test9.head
    printf "HEAD /tfile1 length $sizen\n" > test9.zero.expectedlog9.out
    printf "========\n" >> test9.zero.expectedlog9.out

    printf "HTTP/1.1 200 OK\r\nContent-Length: $size2\r\n\r\n" > test10.head
    printf "HEAD /tfile2 length $size2\n" > test10.zero.expectedlog10.out
    printf "========\n" >> test10.zero.expectedlog10.out

    printf "HTTP/1.1 200 OK\r\nContent-Length: $size3\r\n\r\n" > test11.head
    printf "HEAD /tfile3 length $size3\n" > test11.zero.expectedlog11.out
    printf "========\n" >> test11.zero.expectedlog11.out

    printf "HTTP/1.1 200 OK\r\nContent-Length: $size4\r\n\r\n" > test12.head
    printf "HEAD /tfile4 length $size4\n" > test12.zero.expectedlog12.out
    printf "========\n" >> test12.zero.expectedlog12.out

    ################ begin tests ################
    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s -T test1.zero.bin localhost:8080/tfile1
    sleep 2s
    diff test1.zero.bin tfile1
    diff server.log test1.zero.expectedlog1.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s -T test2.zero.bin localhost:8080/tfile2
    sleep 2s
    diff test2.zero.bin tfile2
    diff server.log test2.zero.expectedlog2.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s -T test3.zero.bin localhost:8080/tfile3
    sleep 2s
    diff test3.zero.bin tfile3
    diff server.log test3.zero.expectedlog3.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s -T test4.zero.bin localhost:8080/tfile4
    sleep 2s
    diff test4.zero.bin tfile4
    diff server.log test4.zero.expectedlog4.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s test1.zero.bin localhost:8080/tfile1 > tmp5.get
    sleep 2s
    diff test1.zero.bin tmp5.get
    diff server.log test5.zero.expectedlog5.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s test2.zero.bin localhost:8080/tfile2 > tmp6.get
    sleep 2s
    diff test2.zero.bin tmp6.get
    diff server.log test6.zero.expectedlog6.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s test3.zero.bin localhost:8080/tfile3 > tmp7.get
    sleep 2s
    diff test3.zero.bin tmp7.get
    diff server.log test7.zero.expectedlog7.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s test4.zero.bin localhost:8080/tfile4 > tmp8.get
    sleep 2s
    diff test4.zero.bin tmp8.get
    diff server.log test8.zero.expectedlog8.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s -I test1.zero.bin localhost:8080/tfile1 > test9.head.out
    sleep 0.2s
    diff test9.head.out test9.head
    diff server.log test9.zero.expectedlog9.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s -I test2.zero.bin localhost:8080/tfile2 > test10.head.out
    sleep 0.2s
    diff test10.head.out test10.head
    diff server.log test10.zero.expectedlog10.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s -I test3.zero.bin localhost:8080/tfile3 > test11.head.out
    sleep 0.2s
    diff test11.head.out test11.head
    diff server.log test11.zero.expectedlog11.out
    pkill httpserver

    ./httpserver 8080 -l server.log &
    sleep 2s
    curl -s -I test4.zero.bin localhost:8080/tfile4 > test12.head.out
    sleep 0.2s
    diff test12.head.out test12.head
    diff server.log test12.zero.expectedlog12.out
    pkill httpserver

    ################ clean test environment ################
    rm test*.zero.bin test*.zero.expectedlog*.out tfile* tmp*.get test*.head*
}

# testing valid GET request on small binary file with logging enabled
test_four() {
    printf "Testing valid GET request on small binary file with logging enabled\n" >> mintest.out

    ################ generate all files used and expected output ################
    head -c 200 /dev/urandom > test_in_bin
    size=$(stat -c%s test_in_bin)
    
    printf "GET /test_in_bin length $size\n" > test.four.expectedlog.bin.out
    python3 hex.py test_in_bin >> test.four.expectedlog.bin.out
    printf "========\n" >> test.four.expectedlog.bin.out
    
    ################ begin tests ################
    start_server
    
    curl -s localhost:8080/test_in_bin > test.getlogbin.out
    sleep 0.1
    
    diff test_in_bin test.getlogbin.out
    python3 -c "x=open('server.log').read(); y=open('test.four.expectedlog.bin.out').read(); print('TEST 1:', 'PASS' if y in x and len(y) else 'FAIL')" >> mintest.out
    
    ################ check and clean test environment ################
    check_test
}

# testing valid GET request on large binary file with logging enabled
test_five() {
    printf "Testing valid GET request on large binary file with logging enabled\n"

    ################ generate all files used and expected output ################
    head -c 20000 /dev/urandom > test_in_bin
    size=$(stat -c%s test_in_bin)
    
    printf "GET /test_in_bin length $size\n" > test.five.expectedlog.bin.out
    python3 hex.py test_in_bin >> test.five.expectedlog.bin.out
    printf "========\n" >> test.five.expectedlog.bin.out
    
    ################ begin tests ################
    # start_server
    start_server2
    
    curl -s localhost:8080/test_in_bin > test.getlogbin.out
    sleep 0.5
    
    diff test.getlogbin.out test_in_bin
    diff test.five.expectedlog.bin.out server.log
    kill_server

    ################ clean test environment ################
    rm -f test.five.* rm test_in_bin test.getlogbin.*
}

# testing concurrent GET with logging enabled
test_seven() {
    printf "Testing concurrent GET request with logging enabled\n" >> mintest.out

    ################ generate all files used and expected output ################
    head -c 157 /dev/urandom > test_file1
    head -c 2033 /dev/urandom > test_file2
    size1=$(stat -c%s test_file1)
    size2=$(stat -c%s test_file2)

    printf "GET /test_file1 length $size1\n" > test.seven.expectedlog1.out
    python3 hex.py test_file1 >> test.seven.expectedlog1.out
    printf "========\n" >> test.seven.expectedlog1.out

    printf "GET /test_file2 length $size2\n" > test.seven.expectedlog2.out
    python3 hex.py test_file2 >> test.seven.expectedlog2.out
    printf "========\n" >> test.seven.expectedlog2.out

    ################ begin tests ################
    # start_server
    start_server2

    curl -s localhost:8080/test_file1 > test_file1.out &\
    curl -s localhost:8080/test_file2 > test_file2.out &
    sleep 0.5

    diff test_file1 test_file1.out
    diff test_file2 test_file2.out
    python3 -c "x=open('server.log').read(); y=open('test.seven.expectedlog1.out').read(); print('TEST 1:', 'PASS' if y in x and len(y) else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.seven.expectedlog2.out').read(); print('TEST 2:', 'PASS' if y in x and len(y) else 'FAIL')" >> mintest.out
    kill_server

    ################ clean test environment ################
    rm test_file1 test_file2 test_file*.out test.seven.*
}

# testing concurrent requests including at least one 400 error with logging enabled
test_eight() {
    printf "Testing concurrent requests including at least one 400 with logging enabled\n"  >> mintest.out

    ################ generate all files used and expected output ################
    head -c 147 /dev/urandom > test_file1
    head -c 1337 /dev/urandom > test_file2
    size1=$(stat -c%s test_file1)
    size2=$(stat -c%s test_file2)

    printf "GET /test_file1 length $size1\n" > test.eight.expectedlog1.out
    python3 hex.py test_file1 >> test.eight.expectedlog1.out
    printf "========\n" >> test.eight.expectedlog1.out

    printf "GET /test_file2 length $size2\n" > test.eight.expectedlog2.out
    python3 hex.py test_file2 >> test.eight.expectedlog2.out
    printf "========\n" >> test.eight.expectedlog2.out

    printf "FAIL: GET /bl.ah HTTP/1.1 --- response 400\n========\n" > test.eight.expectedlog3.out
    printf "FAIL: GET /$ HTTP/1.1 --- response 400\n========\n" > test.eight.expectedlog4.out
    printf "FAIL: GET /this_shoudbe+ HTTP/1.1 --- response 400\n========\n" > test.eight.expectedlog5.out
    printf "HEAD /test_file2 length $size2\n========\n" > test.eight.expectedlog6.out
    printf "FAIL: POST /something HTTP/1.1 --- response 400\n========\n" > test.eight.expectedlog7.out
    printf "FAIL: DELETE /Makefile HTTP/1.1 --- response 400\n========\n" > test.eight.expectedlog8.out
    printf "FAIL: GET /SADKJLKASJKLDJALSDJKLASJDLKAJDLKSJKLDJLKAJSDKDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDhello HTTP/1.1 --- response 400\n========\n" > test.eight.expectedlog9.out
    
    ################ begin tests ################
    # start_server
    start_server2

    curl -s localhost:8080/this_shoudbe+ &\
    printf "DELETE /Makefile HTTP/1.1\r\nContent-Length: 0\r\n\r\n" | nc localhost 8080 &\
    curl -s localhost:8080/test_file1 > test_file1.out &\
    curl -s localhost:8080/bl.ah &\
    printf "POST /something HTTP/1.1\r\nContent-Length: 0\r\n\r\n" | nc localhost 8080 &\
    curl -s localhost:8080/test_file2 > test_file2.out &\
    printf "GET /SADKJLKASJKLDJALSDJKLASJDLKAJDLKSJKLDJLKAJSDKDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDhello HTTP/1.1\r\nContent-Length: 0\r\n\r\n" | nc localhost 8080 &\
    curl -s localhost:8080/\$ &\
    curl -s -I localhost:8080/test_file2 &
    sleep 8
    
    diff test_file1 test_file1.out
    diff test_file2 test_file2.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog1.out').read(); print('TEST 1:', 'PASS' if y in x and len(y) else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog2.out').read(); print('TEST 2:', 'PASS' if y in x and len(y) else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog3.out').read(); print('TEST 3:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog4.out').read(); print('TEST 4:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog5.out').read(); print('TEST 5:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog6.out').read(); print('TEST 6:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog7.out').read(); print('TEST 7:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog8.out').read(); print('TEST 8:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.eight.expectedlog9.out').read(); print('TEST 9:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    kill_server

    ################ clean test environment ################
    rm test_file1 test_file2 test_file*.out test.eight.*
}

# testing concurrent requests including at least one 400/404 error with logging enabled
test_nine() {
    printf "Testing concurrent requests including at least one 400/404 with logging enabled\n" >> mintest.out

    ################ generate all files used and expected output ################
    head -c 777 /dev/urandom > test_file1
    head -c 699 /dev/urandom > test_file2
    size1=$(stat -c%s test_file1)
    size2=$(stat -c%s test_file2)
    
    printf "GET /test_file1 length $size1\n" > test.nine.expectedlog1.out
    python3 hex.py test_file1 >> test.nine.expectedlog1.out
    printf "========\n" >> test.nine.expectedlog1.out
    
    printf "GET /test_file2 length $size2\n" > test.nine.expectedlog2.out
    python3 hex.py test_file2 >> test.nine.expectedlog2.out
    printf "========\n" >> test.nine.expectedlog2.out
    
    printf "FAIL: GET /bl.ah HTTP/1.1 --- response 400\n========\n" > test.nine.expectedlog3.out
    printf "FAIL: GET /$ HTTP/1.1 --- response 400\n========\n" > test.nine.expectedlog4.out
    printf "FAIL: GET /this_shoudbe+ HTTP/1.1 --- response 400\n========\n" > test.nine.expectedlog5.out
    printf "HEAD /test_file2 length $size2\n========\n" > test.nine.expectedlog6.out
    printf "FAIL: POST /something HTTP/1.1 --- response 400\n========\n" > test.nine.expectedlog7.out
    printf "FAIL: DELETE /Makefile HTTP/1.1 --- response 400\n========\n" > test.nine.expectedlog8.out
    printf "FAIL: GET /SADKJLKASJKLDJALSDJKLASJDLKAJDLKSJKLDJLKAJSDKDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDhello HTTP/1.1 --- response 400\n========\n" > test.nine.expectedlog9.out
    printf "FAIL: GET /test_file3 HTTP/1.1 --- response 404\n========\n" > test.nine.expectedlog10.out
    printf "FAIL: HEAD /test_file11 HTTP/1.1 --- response 404\n========\n" > test.nine.expectedlog11.out
    
    ################ begin tests ################
    # start_server
    start_server2
    
    curl -s localhost:8080/this_shoudbe+ &\
    printf "DELETE /Makefile HTTP/1.1\r\nContent-Length: 0\r\n\r\n" | nc localhost 8080 &\
    curl -s localhost:8080/test_file1 > test_file1.out &\
    curl -s -I localhost:8080/test_file11 &\
    curl -s localhost:8080/bl.ah &\
    curl -s localhost:8080/test_file3 &\
    printf "POST /something HTTP/1.1\r\nContent-Length: 0\r\n\r\n" | nc localhost 8080 &\
    curl -s localhost:8080/test_file2 > test_file2.out &\
    printf "GET /SADKJLKASJKLDJALSDJKLASJDLKAJDLKSJKLDJLKAJSDKDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDhello HTTP/1.1\r\nContent-Length: 0\r\n\r\n" | nc localhost 8080 &\
    curl -s localhost:8080/\$ &\
    curl -s -I localhost:8080/test_file2 &
    sleep 8
    
    diff test_file1 test_file1.out
    diff test_file2 test_file2.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog1.out').read(); print('TEST 1:', 'PASS' if y in x and len(y) else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog2.out').read(); print('TEST 2:', 'PASS' if y in x and len(y) else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog3.out').read(); print('TEST 3:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog4.out').read(); print('TEST 4:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog5.out').read(); print('TEST 5:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog6.out').read(); print('TEST 6:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog7.out').read(); print('TEST 7:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog8.out').read(); print('TEST 8:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog9.out').read(); print('TEST 9:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog10.out').read(); print('TEST 10:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    python3 -c "x=open('server.log').read(); y=open('test.nine.expectedlog11.out').read(); print('TEST 11:', 'PASS' if y in x else 'FAIL')" >> mintest.out
    kill_server

    ################ clean test environment ################
    rm test_file1 test_file2 test_file*.out test.nine.*
}

# testing single valid GET request on large binary file with logging enabled
test_ten() {
    printf "Testing single valid GET request on large binary file with logging enabled\n" >> mintest.out

    ################ generate all files used and expected output ################
    head -c 2000000 /dev/urandom > test_in_bin
    size=$(stat -c%s test_in_bin)
    
    printf "GET /test_in_bin length $size\n" > test.ten.expectedlog.bin.out
    python3 hex.py test_in_bin >> test.ten.expectedlog.bin.out
    printf "========\n" >> test.ten.expectedlog.bin.out
    head -n -1 test.ten.expectedlog.bin.out > test.temp.out
    
    ################ begin tests ################
    start_server
    
    curl -s localhost:8080/test_in_bin > test.getlogbin.out
    sleep 12
    
    diff test.getlogbin.out test_in_bin
    python3 -c "x=open('server.log').read(); y=open('test.temp.out').read(); print('TEST 1:', 'PASS' if y in x and len(y) else 'FAIL')" >> mintest.out
    pkill httpserver

    ################ clean test environment ################
    rm test_file1 test_file2 test.ten.expectedlog*.out test_in_bin *.temp.out
}

################ some helper functions to debugging race conditions ################
clean() {
    printf "Cleaning..\n"
    rm -f test.* test_* design_put_out cget*.out healthcheck.403.out chc.403.out test.server.log
}

grep_fail() {
    if grep "FAIL" mintest.out; then
        cp server.log server.log.copy
        exit 1
    fi
}

erase_perm() {
    echo "Remove mintest.out?"
    read CLEAN
    if [[ $CLEAN == 'y' ]]; then
      rm mintest.out
    fi
}

################ driver function ################
# Note: comment out different functions to tests different units
test_main() {
    # testing single valid request with logging enabled
    # test_zero

    # testing valid GET request on small binary file with logging enabled
    test_four
    sleep 0.1
    
    # testing single valid GET request on large binary file with logging enabled
    # test_ten

    # testing concurrent GET with logging enabled
    test_seven
    sleep 0.1

    # testing concurrent requests including at least one 400 error with logging enabled
    test_eight
    sleep 0.1

    # testing concurrent requests including at least one 400/404 error with logging enabled
    test_nine
    sleep 0.1

    # clean

    # grep_fail
    # erase_perm
}

test_main