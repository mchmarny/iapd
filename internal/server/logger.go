package server

import (
	"os"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

const (
	logLevelEnvVar     = "LOG_LEVEL"
	logLevelDefaultVal = "debug"
)

func initLogging(name, version string) {
	zerolog.SetGlobalLevel(zerolog.DebugLevel)
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

	level := os.Getenv(logLevelEnvVar)
	if level == "" {
		level = logLevelDefaultVal
	}

	lvl, err := zerolog.ParseLevel(level)
	if err != nil {
		log.Warn().Err(err).Msgf("error parsing log level: %s", level)
	} else {
		zerolog.SetGlobalLevel(lvl)
	}

	log.Logger = zerolog.New(os.Stdout).With().
		Str("name", name).
		Str("version", version).
		Logger()
}
