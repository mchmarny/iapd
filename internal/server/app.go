package server

import (
	"context"
	"net/http"

	"github.com/rs/zerolog/log"
)

const (
	name = "iop"
)

// Run starts the server and waits for termination signal.
func Run(version string) {
	initLogging(name, version)
	log.Info().Msg("starting app server")

	mux := http.NewServeMux()
	mux.HandleFunc("/", infoHandler)
	mux.HandleFunc("/health", healthHandler)

	start(context.Background(), mux)
}
