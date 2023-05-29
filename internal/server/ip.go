package server

import (
	"net/http"
	"strings"

	"github.com/rs/zerolog/log"
)

func getIP(r *http.Request) string {
	// check for X-Real-Ip
	ip := r.Header.Get("X-Real-Ip")
	if ip != "" {
		log.Debug().Msgf("ip-real: %s", ip)
		return strings.TrimSpace(ip)
	}

	// check for X-Forwarded-For
	ip = r.Header.Get("X-Forwarded-For")
	if ip != "" {
		log.Debug().Msgf("ip-fw: %s", ip)
		// could be comma separated list of IPs
		parts := strings.Split(ip, ",")
		if len(parts) > 0 {
			return strings.TrimSpace(parts[0])
		}
		return ip
	}

	// use remote address
	ip = r.RemoteAddr
	log.Debug().Msgf("ip-remote: %s", ip)
	parts := strings.Split(ip, ":")
	if len(parts) > 0 {
		return strings.TrimSpace(parts[0])
	}
	return ip
}
