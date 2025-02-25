package main

import (
	"fmt"
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
	fmt.Println("pass ReadFile", result)
}

func TestFilterCharsAndNormalize(t *testing.T) {
	text := "This is a python test. This test is only a test."
	expected := "this is a python test this test is only a test "

	result := FilterCharsAndNormalize(text)
	if result != expected {
		t.Errorf("Expected %q but got %q", expected, result)
	}
	fmt.Println("pass FilterCharsAndNormalize", result)
}

func TestScan(t *testing.T) {
	text := "this is a python test this test is only a test "
	expected := []string{"this", "is", "a", "python", "test", "this", "test", "is", "only", "a", "test"}

	result := Scan(text)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
	fmt.Println("pass Scan", result)
}

func TestRemoveStopWords(t *testing.T) {
	words := []string{"this", "is", "a", "python", "test", "this", "test", "is", "only", "a", "test"}
	expected := []string{"python", "test", "test", "test"}
	file_path := "../stop_words.txt"

	result := RemoveStopWords(file_path)(words)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
	fmt.Println("pass RemoveStopWords", result)
}

func TestFrequencies(t *testing.T) {
	words := []string{"python", "test", "test", "test"}
	expected := map[string]int{"python": 1, "test": 3}

	result := Frequencies(words)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
	fmt.Println("pass Frequencies", result)
}

// // test_sort
// func TestSort(t *testing.T) {
// 	word_freqs := map[string]int{"python": 1, "test": 3}
// 	expected := map[string]int{"test": 3, "python": 1}

// 	result := Sort(word_freqs)
// 	if !reflect.DeepEqual(result, expected) {
// 		t.Errorf("Expected %q but got %q", expected, result)
// 	}
// }
