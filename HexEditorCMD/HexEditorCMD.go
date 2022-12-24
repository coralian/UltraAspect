package main

import (
	"encoding/hex"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"strings"
)

func main() {
	// Define command-line flags
	targetFilePath := flag.String("file", "", "Path to the file to modify")
	// Get the directory of the input file
	findValue := flag.String("find", "", "Find value (in the format XX:XX:XX:XX)")
	replaceValue := flag.String("replace", "", "Replace value (in the format XX:XX:XX:XX)")

	// Define the help message
	flag.Usage = func() {
		fmt.Println("Usage: go run HexEditorCMD.go -file <targetFilePath> -find <find value> -replace <replace value>")
		fmt.Println("\nOptions:")
		flag.PrintDefaults()
	}

	// Parse command-line flags
	flag.Parse()

	// Check that targetFilePath, find value, and replace value are all provided
	if *targetFilePath == "" || *findValue == "" || *replaceValue == "" {
		fmt.Println("All flags must be provided")
		return
	}

	// Check if find value and replace value are the same length
	if len(*findValue) != len(*replaceValue) {
		fmt.Println("Find and replace values must be the same length")
		return
	}

	dir, targetFileName := filepath.Split(*targetFilePath)

	// Replace the ":" characters with an empty string
	findValueNoColon := strings.Replace(*findValue, ":", "", -1)
	replaceValueNoColon := strings.Replace(*replaceValue, ":", "", -1)

	// Convert the find and replace values to byte arrays
	findBytes, err := hex.DecodeString(findValueNoColon)
	if err != nil {
		fmt.Printf("Error decoding find value: %s\n", err)
		return
	}
	replaceBytes, err := hex.DecodeString(replaceValueNoColon)
	if err != nil {
		fmt.Printf("Error decoding replace value: %s\n", err)
		return
	}

	// Read file
	data, err := ioutil.ReadFile(*targetFilePath)
	if err != nil {
		fmt.Printf("Error reading file: %s\n", err)
		return
	}

	// Replace all occurrences of the find value with replace value
	modifiedData := make([]byte, len(data))
	copy(modifiedData, data)
	counter := 0
	for i := 0; i < len(modifiedData)-len(findBytes)+1; i++ {
		if reflect.DeepEqual(modifiedData[i:i+len(findBytes)], findBytes) {
			copy(modifiedData[i:i+len(replaceBytes)], replaceBytes)
			counter++
		}
	}

	// Write modified data to a new file
	modifiedFile, err := os.Create(filepath.Join(dir, targetFileName))
	if err != nil {

	}
	defer modifiedFile.Close()

	// Write the contents of modifiedData to the modifiedFile
	_, err = modifiedFile.Write(modifiedData)
	if err != nil {

	}

	// Check for changes
	if counter < 0 {
		fmt.Printf("No Changes made to target file: %d\n", counter)
		err = os.Remove(*targetFilePath)
		if err != nil {
		}
	}

	// Rename the modified file to the same name as the input file
	err = os.Rename(modifiedFile.Name(), filepath.Join(dir, targetFileName))
	if err != nil {
	}

	fmt.Printf("Number of values replaced: %d\n", counter)
}
