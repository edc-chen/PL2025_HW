package main

import (
	"fmt"
	"os"
	"reflect"
	"regexp"
	"slices"
	"sort"
	"strings"
)

func info(v interface{}) string {
	return reflect.TypeOf(v).String()
}

type DataStorageManager struct {
	_data string
}

func NewDataStorageManager(filePath string) *DataStorageManager {
	file, err := os.ReadFile(filePath)
	if err != nil {
		fmt.Println(err)
	}

	reg, _ := regexp.Compile(`[\W_]+`)
	processed := strings.ToLower(reg.ReplaceAllString(string(file), " "))

	return &DataStorageManager{_data: processed}
}

func (dsm *DataStorageManager) Words() []string {
	return strings.Fields(dsm._data)
}

func (dsm *DataStorageManager) Info() string {
	return info(dsm) + ": My major data structure is a " + info(dsm._data)
}

type StopWordManager struct {
	_stopWords []string
}

func NewStopWordManager() *StopWordManager {
	file, err := os.ReadFile("../stop_words.txt")
	if err != nil {
		fmt.Println(err)
	}
	stop_words := strings.Split(string(file), ",")
	for ch := 'a'; ch <= 'z'; ch++ {
		stop_words = append(stop_words, string(ch))
	}

	return &StopWordManager{_stopWords: stop_words}
}

func (swm *StopWordManager) IsStopWord(word string) bool {
	return slices.Contains(swm._stopWords, word)
}

func (swm *StopWordManager) Info() string {
	return info(swm) + ": My major data structure is a " + info(swm._stopWords)
}

type WordFrequencyManager struct {
	_wordFreqs map[string]int
}

func NewWordFrequencyManager() *WordFrequencyManager {
	return &WordFrequencyManager{_wordFreqs: make(map[string]int)}
}

func (wfm *WordFrequencyManager) IncrementCount(word string) {
	wfm._wordFreqs[word]++
}

func (wfm *WordFrequencyManager) Info() string {
	return info(wfm) + ": My major data structure is a " + info(wfm._wordFreqs)
}

type Pair struct {
	word  string
	count int
}

func (wfm *WordFrequencyManager) Sorted() []Pair {
	sortedList := []Pair{}

	for k, v := range wfm._wordFreqs {
		sortedList = append(sortedList, Pair{k, v})
	}

	sort.Slice(sortedList, func(i, j int) bool {
		return sortedList[i].count > sortedList[j].count
	})
	return sortedList
}

type WordFrequencyController struct {
	_storageManager  *DataStorageManager
	_stopWordManager *StopWordManager
	_wordFreqManager *WordFrequencyManager
}

func NewWordFrequencyController(filePath string) *WordFrequencyController {
	return &WordFrequencyController{
		_storageManager:  NewDataStorageManager(filePath),
		_stopWordManager: NewStopWordManager(),
		_wordFreqManager: NewWordFrequencyManager(),
	}
}

func (wfc *WordFrequencyController) Run() {
	for _, word := range wfc._storageManager.Words() {
		if !wfc._stopWordManager.IsStopWord(word) {
			wfc._wordFreqManager.IncrementCount(word)
		}
	}

	wordFreqs := wfc._wordFreqManager.Sorted()
	for i := 0; i < 25 && i < len(wordFreqs); i++ {
		fmt.Println(wordFreqs[i].word, "-", wordFreqs[i].count)
	}
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run main.go <file_path>")
		return
	}
	NewWordFrequencyController(os.Args[1]).Run()
}
