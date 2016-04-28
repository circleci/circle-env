#!/usr/bin/env bats

@test "google-chrome works on trusty" {
    circle-env install google-chrome &>> test.log

    run google-chrome --version &>> test.log

    [ "$status" -eq 0 ]
}
