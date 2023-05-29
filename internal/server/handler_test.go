package server

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestInfoHandler(t *testing.T) {
	req, err := http.NewRequest(http.MethodGet, "/", nil)
	assert.NoError(t, err)

	rec := httptest.NewRecorder()
	handler := http.HandlerFunc(infoHandler)
	handler.ServeHTTP(rec, req)

	assert.Equal(t, http.StatusOK, rec.Code)
}

func TestRemoteAddress(t *testing.T) {
	hdFW := "X-Forwarded-For"
	hdReal := "X-Real-Ip"
	wantIP := "192.1.2.3"

	// create a request with no headers
	r := httptest.NewRequest("GET", "http://example.com/foo", nil)

	// FW
	r.Header.Set(hdFW, wantIP)
	assert.Equal(t, wantIP, getIP(r))
	r.Header.Set(hdFW, "")

	// Real
	r.Header.Set(hdReal, wantIP)
	assert.Equal(t, wantIP, getIP(r))
	r.Header.Set(hdReal, "")

	// Remote
	r.Header.Set(hdFW, "")
	r.Header.Set(hdReal, "")
	r.RemoteAddr = wantIP + ":1234"
	assert.Equal(t, wantIP, getIP(r))
}
