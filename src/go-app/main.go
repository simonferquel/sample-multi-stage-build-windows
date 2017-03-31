package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

type requestHandler struct {
}

func (requestHandler) ServeHTTP(writer http.ResponseWriter, origreq *http.Request) {
	resp, err := http.Get("http://localhost:5000/api/values")
	if err != nil {
		writer.WriteHeader(500)
		writer.Write([]byte(fmt.Sprintf("error: %v", err)))
		return
	}
	defer resp.Body.Close()
	payload, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		writer.WriteHeader(500)
		writer.Write([]byte(fmt.Sprintf("error: %v", err)))
		return
	}
	writer.Write(append([]byte("Hello from go, dotnet said: "), payload...))
}

func main() {
	http.ListenAndServe(":80", requestHandler{})
}
