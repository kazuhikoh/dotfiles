#!/usr/bin/env bats

@test "Requirements: curl" {
	run curl --version
	[ "$status" -eq 0 ]
}

@test "Sending arg1 value" {
	run ../bin/slk test1
	[ "$status" -eq 0 ]
}

@test "Sending stdin value" {
	run bash -c "echo test2 | ../bin/slk"
	[ "$status" -eq 0 ]
}

