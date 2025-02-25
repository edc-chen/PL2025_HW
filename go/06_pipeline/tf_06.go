package main

import (
	"fmt"
	"os"
	"regexp"
	"strings"
)

func ReadFile(path_file string) string {
	data, err := os.ReadFile(path_file)
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

func RemoveStopWords(words []string) []string {
	return []string{}
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

func main() {
	words := []string{"python", "test", "test", "test"}
	fmt.Println(Frequencies(words))
}
