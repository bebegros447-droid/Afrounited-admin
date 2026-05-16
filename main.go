package main

import (
"encoding/json"
"fmt"
"net/http"
"os"
"strconv"
)

// Driver data model with specific payout choice
type Driver struct {
ID int `json:"id"`
Name string `json:"name"`
Service string `json:"service"`
Status string `json:"status"`
Earnings float64 `json:"earnings"`
PayoutType string `json:"payout_type"` // "Orange Money" or "Wave"
PayoutPhone string `json:"payout_phone"`
}

// Restaurant data model for store partners
type Restaurant struct {
ID int `json:"id"`
Name string `json:"name"`
Location string `json:"location"`
TotalOrders int `json:"total_orders"`
BalanceDue float64 `json:"balance_due"`
PayoutType string `json:"payout_type"` // "Orange Money" or "Wave"
PayoutPhone string `json:"payout_phone"`
}

// In-Memory Database State
var drivers = []Driver{
{ID: 1, Name: "Alpha Diallo", Service: "taxi", Status: "pending", Earnings: 0.0, PayoutType: "Wave", PayoutPhone: "+224-622-11-22-33"},
{ID: 2, Name: "Mariama Barry", Service: "delivery", Status: "approved", Earnings: 120.50, PayoutType: "Orange Money", PayoutPhone: "+224-664-44-55-66"},
{ID: 3, Name: "Amadou Bah", Service: "taxi", Status: "approved", Earnings: 350.00, PayoutType: "Wave", PayoutPhone: "+224-628-99-88-77"},
}

var restaurants = []Restaurant{
{ID: 1, Name: "Le Ciel Conakry", Location: "Dixinn", TotalOrders: 42, BalanceDue: 310.00, PayoutType: "Orange Money", PayoutPhone: "+224-669-11-22-33"},
{ID: 2, Name: "Restaurant Bembeya", Location: "Kaloum", TotalOrders: 19, BalanceDue: 145.50, PayoutType: "Wave", PayoutPhone: "+224-620-55-66-77"},
}

var adminOrangeMoney = "Not Set"
var adminWave = "Not Set"

func main() {
port := os.Getenv("PORT")
if port == "" {
port = "10000"
}

http.HandleFunc("/", visualDashboardHandler)
http.HandleFunc("/admin/save-payout", savePayoutHandler)
http.HandleFunc("/admin/drivers/status", updateDriverStatusHandler)
http.HandleFunc("/admin/drivers", listDriversHandler)

fmt.Printf("Dashboard running securely on port %s...\n", port)
if err := http.ListenAndServe(":"+port, nil); err != nil {
fmt.Println("Server error:", err)
}
}

func visualDashboardHandler(w http.ResponseWriter, r *http.Request) {
var totalTaxi float64
var totalDelivery float64
for _, d := range drivers {
if d.Status == "approved" {
if d.Service == "taxi" {
totalTaxi += d.Earnings * 0.285
} else if d.Service == "delivery" {
totalDelivery += d.Earnings * 0.15
}
}
}
totalRevenue := totalTaxi + totalDelivery

w.Header().Set("Content-Type", "text/html")
fmt.Fprintf(w, `
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Afrounited Global Ecosystem Control</title>
<style>
body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; margin: 0; padding: 0; display: flex; }
.sidebar { width: 240px; background-color: #0f172a; color: white; min-height: 100vh; padding: 20px; }
.sidebar h2 { font-size: 20px; color: #38bdf8; margin-bottom: 30px; }
.sidebar a { display: block; color: #94a3b8; padding: 12px; text-decoration: none; border-radius: 6px; margin-bottom: 8px; }
.sidebar a.active { background-color: #1e293b; color: white; }
.main-content { flex: 1; padding: 40px; }
.stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px; }
.card { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border-left: 5px solid #3b82f6; }
.card.admin { border-left-color: #38bdf8; background: #f0f9ff; }
.card-title { font-size: 12px; color: #64748b; text-transform: uppercase; font-weight: 600; }
.card-value { font-size: 26px; font-weight: 700; color: #1e293b; margin-top: 5px; }
.layout-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; margin-bottom: 25px; }
.panel { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
table { width: 100%%; border-collapse: collapse; text-align: left; }
th { padding: 12px; border-bottom: 2px solid #e2e8f0; color: #64748b; font-size: 13px; }
td { padding: 12px; border-bottom: 1px solid #e2e8f0; color: #334155; font-size: 13px; }
.badge { padding: 4px 8px; border-radius: 20px; font-size: 11px; font-weight: 600; }
.badge.approved { background: #d1fae5; color: #065f46; }
.badge.pending { background: #fef3c7; color: #92400e; }
.badge.orange { background: #ffedd5; color: #ea580c; border: 1px solid #f97316; }
.badge.wave { background: #e0f2fe; color: #0284c7; border: 1px solid #0ea5e9; }
.btn { background: #0284c7; color: white; border: none; padding: 8px 12px; border-radius: 6px; cursor: pointer; font-weight: 600; width: 100%%; }
.btn-secure { background: #dc2626; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; }
.btn-action { background: #16a34a; font-size: 11px; padding: 4px 8px; width: auto; }
.form-group { margin-bottom: 12px; }
input[type="text"] { width: 100%%; padding: 9px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; }

/* Alert Notification Modals styling */
.safety-banner { background: #fef2f2; border: 1px solid #fee2e2; padding: 15px; border-radius: 8px; margin-bottom: 25px; display: flex; align-items: center; justify-content: space-between; }
.safety-title { color: #991b1b; font-weight: 700; font-size: 14px; display: flex; align-items: center; gap: 8px; }
</style>
<script>
function triggerRestaurantPopup(restaurantName, orderId, driverName) {
alert("🚨 AFROUNITED SECURE PICKUP VERIFICATION\n\n[Store Location: " + restaurantName + "]\n[Order Reference ID: #" + orderId + "]\n\nINSTRUCTION FOR MERCHANDISE PARTNER:\nBefore handing over the food box/package, you MUST confirm the mobile app profile photo on screen matches driver: " + driverName.toUpperCase() + ".");
}
function triggerRiderSafetyPopup() {
alert("🛡️ ANTI-FRAUD RIDER IDENTITY SAFETY CHECK\n\nBEFORE ENTERING THE VEHICLE:\n1. Verify the driver's physical face matches the profile shown in your app.\n2. Confirm the vehicle license plate matches your active ride receipt exactly.\n\nNever enter a vehicle if the identity details or driver phone call confirmation do not match!");
}
</script>
</head>
<body>
<div class="sidebar">
<h2>Afrounited Platform</h2>
<a href="#" class="active">Ecosystem Console</a>
<a href="/admin/drivers">JSON Data Out</a>
</div>
<div class="main-content">

<div class="safety-banner">
<div class="safety-title">
🛑 <span><strong>Rider Security Protocol Enabled</strong></span>
</div>
<button class="btn btn-secure" style="width: auto;" onclick="triggerRiderSafetyPopup()">Test Rider Vehicle Matching Notice</button>
</div>

<div class="stats-grid">
<div class="card admin">
<div class="card-title">System Vault Revenue</div>
<div class="card-value">$%.2f</div>
</div>
<div class="card" style="border-left-color: #eab308;">
<div class="card-title">Taxi Fleet Revenue (28.5%%)</div>
<div class="card-value">$%.2f</div>
</div>
<div class="card" style="border-left-color: #10b981;">
<div class="card-title">Delivery Fleet Revenue (15%%)</div>
<div class="card-value">$%.2f</div>
</div>
</div>

<div class="layout-grid">
<div class="panel">
<h3>Active Fleet & Driver Payout Protocols</h3>
<table>
<thead>
<tr>
<th>Driver</th>
<th>Service</th>
<th>Payout Method</th>
<th>Wallet Targets</th>
<th>Status</th>
<th>Action</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Alpha Diallo</strong></td>
<td>Taxi</td>
<td><span class="badge wave">Wave</span></td>
<td>+224-622-11-22-33</td>
<td><span class="badge pending">Pending</span></td>
<td>
<form action="/admin/drivers/status?id=1&status=approved" method="POST" style="margin:0;">
<button type="submit" class="btn btn-action">Approve</button>
</form>
</td>
</tr>
<tr>
<td><strong>Mariama Barry</strong></td>
<td>Delivery</td>
<td><span class="badge orange">Orange Money</span></td>
<td>+224-664-44-55-66</td>
<td><span class="badge approved">Approved</span></td>
<td><button class="btn" style="padding:4px 8px; font-size:11px; width:auto; background:#64748b;" onclick="triggerRestaurantPopup('Le Ciel Conakry', '8841', 'Mariama Barry')">Test Pickup Check</button></td>
</tr>
<tr>
<td><strong>Amadou Bah</strong></td>
<td>Taxi</td>
<td><span class="badge wave">Wave</span></td>
<td>+224-628-99-88-77</td>
<td><span class="badge approved">Approved</span></td>
<td><span style="color:#94a3b8; font-size:12px;">Active Monitoring</span></td>
</tr>
</tbody>
</table>
</div>

<div class="panel">
<h3>Master Platform Payout Setup</h3>
<form action="/admin/save-payout" method="POST">
<div class="form-group">
<label>Platform Orange Money Number</label>
<input type="text" name="orange" placeholder="+224..." value="%s">
</div>
<div class="form-group">
<label>Platform Wave Number</label>
<input type="text" name="wave" placeholder="+224..." value="%s">
</div>
<button type="submit" class="btn">Update Master Vault</button>
</form>
<div style="background:#f8fafc; padding:10px; border-radius:6px; margin-top:12px; font-size:12px;">
🍊 Active Orange Vault: %s<br>
🌊 Active Wave Vault: %s
</div>
</div>
</div>

<div class="panel" style="margin-top:20px;">
<h3>Restaurant Merchant Partners Balance Management</h3>
<table>
<thead>
<tr>
<th>Merchant ID</th>
<th>Restaurant Name</th>
<th>Hub Location</th>
<th>Aggregated Sales Count</th>
<th>Preferred Settlement Method</th>
<th>Merchant Wallet Target</th>
<th>Platform Payables Remaining</th>
</tr>
</thead>
<tbody>
<tr>
<td>#R-01</td>
<td><strong>Le Ciel Conakry</strong></td>
<td>Dixinn Hub</td>
<td>42 orders processed</td>
<td><span class="badge orange">Orange Money</span></td>
<td><strong>+224-669-11-22-33</strong></td>
<td style="color:#16a34a; font-weight:700;">$310.00 due</td>
</tr>
<tr>
<td>#R-02</td>
<td><strong>Restaurant Bembeya</strong></td>
<td>Kaloum Hub</td>
<td>19 orders processed</td>
<td><span class="badge wave">Wave</span></td>
<td><strong>+224-620-55-66-77</strong></td>
<td style="color:#16a34a; font-weight:700;">$145.50 due</td>
</tr>
</tbody>
</table>
</div>

</div>
</body>
</html>
`, totalRevenue, totalTaxi, totalDelivery, adminOrangeMoney, adminWave, adminOrangeMoney, adminWave)
}

func savePayoutHandler(w http.ResponseWriter, r *http.Request) {
if r.Method == http.MethodPost {
r.ParseForm()
if o := r.FormValue("orange"); o != "" {
adminOrangeMoney = o
}
if w := r.FormValue("wave"); w != "" {
adminWave = w
}
}
http.Redirect(w, r, "/", http.StatusSeeOther)
}

func listDriversHandler(w http.ResponseWriter, r *http.Request) {
w.Header().Set("Content-Type", "application/json")
json.NewEncoder(w).Encode(map[string]interface{}{"drivers": drivers, "restaurants": restaurants})
}

func updateDriverStatusHandler(w http.ResponseWriter, r *http.Request) {
idStr := r.URL.Query().Get("id")
status := r.URL.Query().Get("status")
id, _ := strconv.Atoi(idStr)
for i, d := range drivers {
if d.ID == id {
drivers[i].Status = status
break
}
}
http.Redirect(w, r, "/", http.StatusSeeOther)
}
