package server

import (
	"io"
	"net/http"
	"net/url"

	"github.com/pkg/errors"
	"gopkg.in/yaml.v2"
)

func getInfo(r *http.Request) *info {
	i := &info{
		Host: r.Host,
		Request: map[string]interface{}{
			"url":    r.URL.String(),
			"method": r.Method,
			"ip":     getIP(r),
		},
		Headers: r.Header,
		Form:    r.Form,
	}

	return i
}

type info struct {
	Host    string                 `yaml:"host"`
	Request map[string]interface{} `yaml:"request"`
	Headers map[string][]string    `yaml:"headers"`
	Form    url.Values             `yaml:"form"`
}

func (i *info) write(w io.Writer) error {
	return errors.Wrap(yaml.NewEncoder(w).Encode(i), "failed to write info")
}
