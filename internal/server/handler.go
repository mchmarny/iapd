package server

import (
	"net/http"

	"github.com/rs/zerolog/log"
)

func healthHandler(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("OK")) // nolint: errcheck
}

func infoHandler(w http.ResponseWriter, r *http.Request) {
	info := getInfo(r)
	log.Debug().Interface("info", info).Msg("request info")

	w.WriteHeader(http.StatusOK)
	if err := info.write(w); err != nil {
		log.Error().Err(err).Msg("failed to write info")
		w.WriteHeader(http.StatusInternalServerError)
	}
}
