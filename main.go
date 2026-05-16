package main

import (
"fmt"
"net/http"
"os"
)

func main() {
// Get the port Render assigns us, default to 8080 if not found
port := os.Getenv("PORT")
if port == "" {
port = "8080"
}

// A basic welcome message for your admin dashboard backend
http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
fmt.Fprintf(w, "Afrounited Admin Dashboard Backend is Running!")
})

fmt.Printf("Server starting on port %s...\n", port)
err := http.ListenAndServe(":"+port, nil)
if err != nil {
fmt.Println("Error starting server:", err)
}
}
