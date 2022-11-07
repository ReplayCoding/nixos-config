package main

import (
	"fmt"
	"hash/crc32"
	"io"
	"os"
	"strings"
)

func calculateCrc(reader io.Reader) ([]byte, error) {
	hasher := crc32.NewIEEE()
	for {
		buffer := make([]byte, 1024)
		bytesread, err := reader.Read(buffer)
		if err != nil {
			if err != io.EOF {
				return nil, err
			}

			break
		}

		hasher.Write(buffer[:bytesread])
	}

	return hasher.Sum(nil), nil
}

func isCrcInString(crc []byte, str string) bool {
  crc_s := fmt.Sprintf("%08x", crc);
  str = strings.ToLower(str)
  return strings.Contains(str, crc_s)
}

const usage = `usage: crc32 <file1> <file2> ...`

func main() {
	if len(os.Args) < 2 {
		fmt.Println(usage)
		return
	}

	for _, fname := range os.Args[1:] {
		file, err := os.Open(fname)
		if err != nil {
			fmt.Println(err)
			return
		}
		defer file.Close()

		hash, err := calculateCrc(file)
		if err != nil {
			fmt.Println(err)
			return
		}

    prefix := ""
    if isCrcInString(hash, fname) {
      prefix = "\x1b[32m"
    }

		fmt.Printf("%s%08x %s\x1b[0m\n", prefix, hash, fname)
	}
}
