package main

import (
	"io"
	"os"
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

func TestScan(t *testing.T) {
	text := "this is a python test this test is only a test "
	expected := []string{"this", "is", "a", "python", "test", "this", "test", "is", "only", "a", "test"}

	result := Scan(text)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

func TestRemoveStopWords(t *testing.T) {
	words := []string{"this", "is", "a", "python", "test", "this", "test", "is", "only", "a", "test"}
	expected := []string{"python", "test", "test", "test"}
	file_path := "../stop_words.txt"

	result := RemoveStopWords(file_path)(words)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

func TestFrequencies(t *testing.T) {
	words := []string{"python", "test", "test", "test"}
	expected := map[string]int{"python": 1, "test": 3}

	result := Frequencies(words)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

func TestSort(t *testing.T) {
	word_freqs := map[string]int{"python": 1, "test": 3}
	expected := []Pair{{"test", 3}, {"python", 1}}

	result := Sort(word_freqs)
	if !reflect.DeepEqual(result, expected) {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

func TestPrintAll(t *testing.T) {
	word_freqs := []Pair{{"test", 3}, {"python", 1}}
	expected := "test - 3\npython - 1\n"
	rescueStdout := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w
	PrintAll(word_freqs)
	w.Close()
	out, _ := io.ReadAll(r)
	os.Stdout = rescueStdout
	if string(out) != expected {
		t.Errorf("Expected %s, got %s", expected, out)
	}
}
