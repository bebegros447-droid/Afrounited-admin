
package main

import (
"encoding/json"
"fmt"
"net/http"
"os"
"strconv"
)

// Driver represents a ride-sharing or delivery worker
type Driver struct {
ID int `json:"id"`
Name String `json:"name"`
Service String `json:"service"` // "taxi" or "delivery"
Status String `json:"status"` // "pending", "approved", "rejected"
Earnings float64 `json:"earnings"`
}

// Global memory to store data for now
var drivers = []Driver{
{ID: 1, Name: "Alpha Diallo", Service: "taxi", Status: "pending", Earnings: 0.0},
{ID: 2, Name: "Mariama Barry", Service: "delivery", Status: "approved", Earnings: 120.50},
}

func main() {
port := os.Getenv("PORT")
if port == "" {
port = "8080"
}

// Home Route
http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
fmt.Fprintf(w, "Afrounited Admin Dashboard API is running actively!")
})

// 1. PAYMENT & DRIVER TRACKING: List all drivers and data
http.HandleFunc("/admin/drivers", listDriversHandler)

// 2. DRIVER MANAGEMENT: Approve or reject a driver account
http.HandleFunc("/admin/drivers/status", updateDriverStatusHandler)

fmt.Printf("Dashboard backend starting on port %s...\n", port)
if err := http.ListenAndServe(":"+port, nil); err != nil {
fmt.Println("Error starting server:", err)
}
}

// Handler to view all drivers, commissions, and stats
func listDriversHandler(w http.ResponseWriter, r *http.Request) {
w.Header().Set("Content-Type", "application/json")

// Calculate total platform commissions collected
// (Taxi: 28.5%, Delivery: 15%)
var totalTaxiCommissions float64
var totalDeliveryCommissions float64

for _, d := range drivers {
if d.Service == "taxi" {
totalTaxiCommissions += d.Earnings * 0.285
} else if d.Service == "delivery" {
totalDeliveryCommissions += d.Earnings * 0.15
}
}

response := map[string]interface{}{
"drivers": drivers,
"stats": map[string]float64{
"total_taxi_commissions_collected": totalTaxiCommissions,
"total_delivery_commissions_collected": totalDeliveryCommissions,
"total_platform_revenue": totalTaxiCommissions + totalDeliveryCommissions,
},
}

json.NewEncoder(w).Encode(response)
}

// Handler to manage approvals and rejections
func updateDriverStatusHandler(w http.ResponseWriter, r *http.Request) {
if r.Method != http.MethodPost {
http.Error(w, "Method not allowed. Use POST.", http.StatusMethodNotAllowed)
return
}

// Read URL parameters: ?id=1&status=approved
idStr := r.URL.Query().Get("id")
status := r.URL.Query().Get("status")

id, err := strconv.Atoi(idStr)
if err != nil || (status != "approved" && status != "rejected") {
http.Error(w, "Invalid driver ID or status parameter", http.StatusBadRequest)
return
}

// Find the driver and update their status
success := false
for i, d := range drivers {
if d.ID == id {
drivers[i].Status = status
success = true
break
}
}

w.Header().Set("Content-Type", "application/json")
if success {
json.NewEncoder(w).Encode(map[string]string{"message": "Driver status updated successfully!"})
} else {
http.Error(w, "Driver not found", http.StatusNotFound)
}
}
