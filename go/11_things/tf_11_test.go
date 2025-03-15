package main

import (
	"fmt"
	"io"
	"os"
	"reflect"
	"strings"
	"testing"
)

func TestDataStorageManager(t *testing.T) {
	filePath := "../in.txt"
	dsm := NewDataStorageManager(filePath)
	new_expected := "this is a python test this test is only a test "
	if dsm._data != new_expected {
		t.Errorf("Expected %q but got %q", new_expected, dsm._data)
	}
	words := dsm.Words()
	words_expected := []string{"this", "is", "a", "python", "test", "this", "test", "is", "only", "a", "test"}
	if !reflect.DeepEqual(words, words_expected) {
		t.Errorf("Expected %q but got %q", words_expected, words)
	}
	info_expected := "*main.DataStorageManager: My major data structure is a string"
	if dsm.Info() != info_expected {
		t.Errorf("Expected %q but got %q", info_expected, dsm.Info())
	}
}

func TestStopWordManager(t *testing.T) {
	file, err := os.ReadFile("../stop_words.txt")
	if err != nil {
		fmt.Println(err)
	}
	new_expected := strings.Split(string(file), ",")
	for ch := 'a'; ch <= 'z'; ch++ {
		new_expected = append(new_expected, string(ch))
	}
	swm := NewStopWordManager()
	if !reflect.DeepEqual(new_expected, swm._stopWords) {
		t.Errorf("Expected %q but got %q", new_expected, swm._stopWords)
	}
	if swm.IsStopWord("test") {
		t.Errorf("Expected 'test' to not be a stop word")
	}
	if !swm.IsStopWord("this") {
		t.Errorf("Expected 'this' to be a stop word")
	}
	info_expected := "*main.StopWordManager: My major data structure is a []string"
	if swm.Info() != info_expected {
		t.Errorf("Expected %q but got %q", info_expected, swm.Info())
	}
}

func TestWordFrequencyManager(t *testing.T) {
	new_expected := make(map[string]int)
	wfm := NewWordFrequencyManager()
	if !reflect.DeepEqual(new_expected, wfm._wordFreqs) {
		t.Errorf("Expected %q but got %q", new_expected, wfm._wordFreqs)
	}

	words := []string{"python", "test", "test", "test"}
	increment_expected := map[string]int{"python": 1, "test": 3}
	for _, word := range words {
		wfm.IncrementCount(word)
	}
	if !reflect.DeepEqual(increment_expected, wfm._wordFreqs) {
		t.Errorf("Expected %q but got %q", increment_expected, wfm._wordFreqs)
	}

	sorted_expected := []Pair{{"test", 3}, {"python", 1}}
	sorted := wfm.Sorted()
	if !reflect.DeepEqual(sorted, sorted_expected) {
		t.Errorf("Expected %v but got %v", sorted_expected, sorted)
	}

	info_expected := "*main.WordFrequencyManager: My major data structure is a map[string]int"
	if wfm.Info() != info_expected {
		t.Errorf("Expected %q but got %q", info_expected, wfm.Info())
	}
}

func TestWordFrequencyController(t *testing.T) {
	filePath := "../in.txt"
	dsm := NewDataStorageManager(filePath)
	swm := NewStopWordManager()
	wfm := NewWordFrequencyManager()
	controller := NewWordFrequencyController(filePath)

	if controller._storageManager._data != dsm._data {
		t.Errorf("Expected %q but got %q", dsm._data, controller._storageManager._data)
	}
	if !reflect.DeepEqual(controller._stopWordManager._stopWords, swm._stopWords) {
		t.Errorf("Expected %q but got %q", swm._stopWords, controller._stopWordManager._stopWords)
	}
	if !reflect.DeepEqual(controller._wordFreqManager._wordFreqs, wfm._wordFreqs) {
		t.Errorf("Expected %q but got %q", wfm._wordFreqs, controller._wordFreqManager._wordFreqs)
	}

	expected := "test - 3\npython - 1\n"
	rescueStdout := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w
	controller.Run()
	w.Close()
	out, _ := io.ReadAll(r)
	os.Stdout = rescueStdout
	if string(out) != expected {
		t.Errorf("Expected %s, got %s", expected, out)
	}
}
