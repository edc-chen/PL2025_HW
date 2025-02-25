package main

import (
	"reflect"
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
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

// test_remove_stop_words
func TestRemoveStopWords(t *testing.T) {
	words := []string{"this", "is", "a", "python", "test", "this", "test", "is", "only", "a", "test"}
	expected := []string{"python", "test", "test", "test"}

	result := RemoveStopWords(words)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

// test_frequencies
func TestFrequencies(t *testing.T) {
	words := []string{"python", "test", "test", "test"}
	expected := map[string]int{"python": 1, "test": 3}

	result := Frequencies(words)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}
