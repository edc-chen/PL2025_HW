package main

import (
	"fmt"
)

// DocumentGenerator interface
type DocumentGenerator interface {
	PrepareData() string
	FormatContent(data string) string
	Save(content string) string
}

// BaseGenerator
type BaseGenerator struct {
	generator DocumentGenerator
}

func (b *BaseGenerator) Generate() string {
	data := b.generator.PrepareData()
	formatted := b.generator.FormatContent(data)
	result := b.generator.Save(formatted)
	return result
}

// TextDocument Concrete implementation
type TextDocument struct {
	BaseGenerator
}

func (t *TextDocument) PrepareData() string {
	return "This is the raw text data."
}

func (t *TextDocument) FormatContent(data string) string {
	return fmt.Sprintf("Formatted Text: %s", data)
}

func (t *TextDocument) Save(content string) string {
	return fmt.Sprintf("Saving text document: %s", content)
}

// HTMLDocument Concrete implementation
type HTMLDocument struct {
	BaseGenerator
}

func (h *HTMLDocument) PrepareData() string {
	return "<html><body>This is raw HTML data.</body></html>"
}

func (h *HTMLDocument) FormatContent(data string) string {
	return fmt.Sprintf("<div>%s</div>", data)
}

func (h *HTMLDocument) Save(content string) string {
	return fmt.Sprintf("Saving HTML document: %s", content)
}

// main function
func main() {
	textDoc := BaseGenerator{
		generator: &TextDocument{},
	}
	fmt.Println(textDoc.Generate())

	htmlDoc := BaseGenerator{
		generator: &HTMLDocument{},
	}
	fmt.Println(htmlDoc.Generate())
}
