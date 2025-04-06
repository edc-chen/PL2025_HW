package main

import (
	"testing"
)

// 單元測試
func TestTextDocument_Generate(t *testing.T) {
	textDoc := BaseGenerator{
		generator: &TextDocument{},
	}
	expected := "Saving text document: Formatted Text: This is the raw text data."
	result := textDoc.Generate()
	if result != expected {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}

func TestHTMLDocument_Generate(t *testing.T) {
	htmlDoc := BaseGenerator{
		generator: &HTMLDocument{},
	}
	expected := "Saving HTML document: <div><html><body>This is raw HTML data.</body></html></div>"
	result := htmlDoc.Generate()
	if result != expected {
		t.Errorf("Expected %q but got %q", expected, result)
	}
}
