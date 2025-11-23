package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func handler(w http.ResponseWriter, r *http.Request) {
	env := os.Getenv("SANDBOX_ENV")
	if env == "" {
		env = "default-dev"
	}
	fmt.Fprintf(w, "Hello from sandbox environment: %s\n", env)
}

func main() {
	http.HandleFunc("/", handler)
	port := "8080"
	log.Printf("Starting app on port %s...", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
