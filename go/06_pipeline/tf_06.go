package main

import (
	"fmt"
	"os"
	"regexp"
	"slices"
	"sort"
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
	re, err := regexp.Compile(`[\W_]+`)
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

type Pair struct {
	word  string
	count int
}

func Sort(word_freqs map[string]int) []Pair {
	out_list := []Pair{}
	for k, v := range word_freqs {
		out_list = append(out_list, Pair{k, v})
	}
	sort.Slice(out_list, func(i, j int) bool {
		return out_list[i].count > out_list[j].count
	})

	return out_list
}

func PrintAll(word_freqs []Pair) {
	if len(word_freqs) > 0 {
		fmt.Printf("%s - %d\n", word_freqs[0].word, word_freqs[0].count)
		PrintAll(word_freqs[1:])
	}
}

func main() {
	PrintAll(Sort(Frequencies(RemoveStopWords(os.Args[2])(Scan(FilterCharsAndNormalize(ReadFile(os.Args[1]))))))[0:25])
}
