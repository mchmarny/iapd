package main

import (
	"github.com/mchmarny/iop/internal/server"
)

var (
	// Set at build time.
	version = "v0.0.1-default"
)

func main() {
	server.Run(version)
}
