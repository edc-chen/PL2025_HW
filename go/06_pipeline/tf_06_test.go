package main

import (
	"testing"
)

func TestReadFile(t *testing.T) {
	path_file := "../in.txt"
	expected := "This is a python test. This test is only a test."

	result := ReadFile(path_file)
	if result != expected {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

func TestFilterCharsAndNormalize(t *testing.T) {
	text := "This is a python test. This test is only a test."
	expected := "this is a python test this test is only a test "

	result := FilterCharsAndNormalize(text)
	if result != expected {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

// test_scan
func TestScan(t *testing.T) {
	text := "this is a python test this test is only a test "
	expected := []string{"this", "is", "a", "python", "test", "this", "test", "is", "only", "a", "test"}

	result := Scan(text)
	if !Equal(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}
