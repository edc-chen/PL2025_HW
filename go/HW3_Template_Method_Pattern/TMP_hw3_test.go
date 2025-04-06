package main

import (
	"testing"
)

// unit test for the Template Method Pattern

// TextDocument test
func TestTextDocument_PrepareData(t *testing.T) {
	textDoc := BaseGenerator{
		generator: &TextDocument{},
	}
	data := "This is the raw text data."
	result := textDoc.generator.PrepareData()
	if result != data {
		t.Errorf("Expected %q but got %q", data, result)
	}
}

func TestTextDocument_FormatContent(t *testing.T) {
	textDoc := BaseGenerator{
		generator: &TextDocument{},
	}
	data := "This is the raw text data."
	format := "Formatted Text: This is the raw text data."
	result := textDoc.generator.FormatContent(data)
	if result != format {
		t.Errorf("Expected %q but got %q", format, result)
	}
}

func TestTextDocument_Save(t *testing.T) {
	textDoc := BaseGenerator{
		generator: &TextDocument{},
	}
	format := "Formatted Text: This is the raw text data."
	save := "Saving text document: Formatted Text: This is the raw text data."
	result := textDoc.generator.Save(format)
	if result != save {
		t.Errorf("Expected %q but got %q", save, result)
	}
}

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

// HTMLDocument test
func TestHTMLDocument_PrepareData(t *testing.T) {
	htmlDoc := BaseGenerator{
		generator: &HTMLDocument{},
	}
	data := "<html><body>This is raw HTML data.</body></html>"
	result := htmlDoc.generator.PrepareData()
	if result != data {
		t.Errorf("Expected %q but got %q", data, result)
	}
}

func TestHTMLDocument_FormatContent(t *testing.T) {

	htmlDoc := BaseGenerator{
		generator: &HTMLDocument{},
	}
	data := "<html><body>This is raw HTML data.</body></html>"
	format := "<div><html><body>This is raw HTML data.</body></html></div>"
	result := htmlDoc.generator.FormatContent(data)
	if result != format {
		t.Errorf("Expected %q but got %q", format, result)
	}
}

func TestHTMLDocument_Save(t *testing.T) {
	htmlDoc := BaseGenerator{
		generator: &HTMLDocument{},
	}
	format := "<div><html><body>This is raw HTML data.</body></html></div>"
	save := "Saving HTML document: <div><html><body>This is raw HTML data.</body></html></div>"
	result := htmlDoc.generator.Save(format)
	if result != save {
		t.Errorf("Expected %q but got %q", save, result)
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
