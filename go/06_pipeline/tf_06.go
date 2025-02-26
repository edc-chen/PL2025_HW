package main

import (
	"fmt"
	"os"
	"regexp"
	"slices"
	"strings"
)

func ReadFile(file_path string) string {
	data, err := os.ReadFile(file_path)
	if err != nil {
		fmt.Println(err)
	}
	return string(data)
}

func FilterCharsAndNormalize(text string) string {
	re, err := regexp.Compile("[^a-zA-Z0-9_]+")
	if err != nil {
		fmt.Println(err)
	}
	result := re.ReplaceAllString(text, " ")
	return strings.ToLower(result)
}

func Scan(text string) []string {
	return strings.Split(strings.TrimSpace(text), " ")
}

func RemoveStopWords(file_path string) func(words []string) []string {
	stop_word_data, err := os.ReadFile(file_path)
	if err != nil {
		fmt.Println(err)
	}
	stop_words := strings.Split(string(stop_word_data), ",")
	for ch := 'a'; ch <= 'z'; ch++ {
		stop_words = append(stop_words, string(ch))
	}
	return func(words []string) []string {
		result := []string{}
		for _, w := range words {
			if !slices.Contains(stop_words, w) {
				result = append(result, w)
			}
		}
		return result
	}
}

func Frequencies(words []string) map[string]int {
	word_freqs := make(map[string]int)
	for _, word := range words {
		word_freqs[word]++
	}
	return word_freqs
}

func Sort(word_freqs map[string]int) []map[string]int {
	return []map[string]int{}
}

func PrintAll(word_freqs []map[string]int) {
	for _, wf := range word_freqs {
		for k, v := range wf {
			fmt.Println(k, " - ", v)
		}
	}
}

func main() {
	words := []string{"python", "test", "test", "test"}
	fmt.Println(Frequencies(words))
}
