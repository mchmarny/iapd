package server

import (
	"fmt"
	"io"
	"net/http"
	"strings"

	"github.com/rs/zerolog/log"
)

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	io.WriteString(w, "OK")
}

func infoHandler(w http.ResponseWriter, r *http.Request) {
	spacer := "\n\n"
	tab := "  "

	io.WriteString(w, spacer)
	io.WriteString(w, "Request:\n")
	io.WriteString(w, fmt.Sprintf("%sURL: %s\n", tab, r.URL.String()))
	io.WriteString(w, fmt.Sprintf("%sMethod: %s\n", tab, r.Method))

	io.WriteString(w, spacer)
	io.WriteString(w, "Headers:\n")
	for name, values := range r.Header {
		for _, value := range values {
			io.WriteString(w, fmt.Sprintf("  %s: %s\n", name, value))
		}
	}
}

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
