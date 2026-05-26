package main

import (
"encoding/json"
"fmt"
"net/http"
"os"
"strconv"
)

type Driver struct {
ID int `json:"id"`
Name string `json:"name"`
Service string `json:"service"`
Status string `json:"status"`
Earnings float64 `json:"earnings"`
PayoutType string `json:"payout_type"`
PayoutPhone string `json:"payout_phone"`
}

type Restaurant struct {
ID int `json:"id"`
Name string `json:"name"`
Location string `json:"location"`
TotalOrders int `json:"total_orders"`
BalanceDue float64 `json:"balance_due"`
PayoutType string `json:"payout_type"`
PayoutPhone string `json:"payout_phone"`
}

type Customer struct {
Name string
PaymentType string
Phone string
}

type LiveOrder struct {
ID int
Restaurant string
Item string
Driver string
Status string
}

var drivers = []Driver{
{ID: 1, Name: "Alpha Diallo", Service: "taxi", Status: "pending", Earnings: 0.0, PayoutType: "Wave", PayoutPhone: "+224-622-11-22-33"},
{ID: 2, Name: "Mariama Barry", Service: "delivery", Status: "approved", Earnings: 120.50, PayoutType: "Orange Money", PayoutPhone: "+224-664-44-55-66"},
{ID: 3, Name: "Amadou Bah", Service: "taxi", Status: "approved", Earnings: 350.00, PayoutType: "Wave", PayoutPhone: "+224-628-99-88-77"},
}

var restaurants = []Restaurant{
{ID: 1, Name: "Le Ciel Conakry", Location: "Dixinn", TotalOrders: 42, BalanceDue: 310.00, PayoutType: "Orange Money", PayoutPhone: "+224-669-11-22-33"},
{ID: 2, Name: "Restaurant Bembeya", Location: "Kaloum", TotalOrders: 19, BalanceDue: 145.50, PayoutType: "Wave", PayoutPhone: "+224-620-55-66-77"},
}

var customers = []Customer{
{Name: "Ismaila Diallo", PaymentType: "Orange Money", Phone: "+224-661-00-11-22"},
}

var liveOrders = []LiveOrder{
{ID: 101, Restaurant: "Le Ciel Conakry", Item: "Yassa Chicken Rice", Driver: "Mariama Barry", Status: "Ready for Pickup"},
}

var adminOrangeMoney = "00224629135060"
var adminWave = "Not Set"

func main() {
port := os.Getenv("PORT")
if port == "" {
port = "10000"
}

http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
http.ServeFile(w, r, "index.html")
})
  http.HandleFunc("/users", func(w http.ResponseWriter, r *http.Request) {
http.ServeFile(w, r, "users.html")
})
  http.HandleFunc("/trips", func(w http.ResponseWriter, r *http.Request) {
http.ServeFile(w, r, "trips.html")
})
http.HandleFunc("/admin/save-payout", savePayoutHandler)
http.HandleFunc("/api/stats", GetDashboardStats)
http.HandleFunc("/admin/drivers/status", updateDriverStatusHandler)
http.HandleFunc("/admin/drivers/clear-payout", clearDriverPayoutHandler)
http.HandleFunc("/admin/add-customer", addCustomerHandler)
http.HandleFunc("/admin/add-order", addOrderHandler)
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
.sidebar a { display: block; color: #94a3b8; padding: 12px; text-decoration: none; border-radius: 6px; margin-bottom: 8px; font-weight:600; }
.sidebar a.active { background-color: #1e293b; color: white; }
.main-content { flex: 1; padding: 40px; box-sizing: border-box; overflow-y: auto; max-height: 100vh; }

/* Layout Configuration */
.stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px; }
.card { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border-left: 5px solid #3b82f6; }
.card.admin { border-left-color: #38bdf8; background: #f0f9ff; }
.card-title { font-size: 12px; color: #64748b; text-transform: uppercase; font-weight: 600; }
.card-value { font-size: 26px; font-weight: 700; color: #1e293b; margin-top: 5px; }
.layout-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; margin-bottom: 25px; }
.panel { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 25px; }

/* Tables & Badges */
table { width: 100%%%%; border-collapse: collapse; text-align: left; }
th { padding: 12px; border-bottom: 2px solid #e2e8f0; color: #64748b; font-size: 13px; }
td { padding: 12px; border-bottom: 1px solid #e2e8f0; color: #334155; font-size: 13px; }
.badge { padding: 4px 8px; border-radius: 20px; font-size: 11px; font-weight: 600; display: inline-block; }
.badge.approved { background: #d1fae5; color: #065f46; }
.badge.pending { background: #fef3c7; color: #92400e; }
.badge.orange { background: #ffedd5; color: #ea580c; border: 1px solid #f97316; }
.badge.wave { background: #e0f2fe; color: #0284c7; border: 1px solid #0ea5e9; }

/* Interactive Buttons */
.btn { background: #0284c7; color: white; border: none; padding: 8px 12px; border-radius: 6px; cursor: pointer; font-weight: 600; width: 100%%%%; }
.btn-secure { background: #dc2626; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; }
.btn-action { background: #16a34a; font-size: 11px; padding: 4px 8px; width: auto; }
.btn-payout { background: #ea580c; font-size: 11px; padding: 4px 8px; width: auto; margin-left: 5px; border:none; color:white; border-radius:4px; cursor:pointer; font-weight:700;}
.form-group { margin-bottom: 12px; }
label { display: block; font-size: 12px; color: #475569; font-weight: 600; margin-bottom: 4px; }
input[type="text"], select { width: 100%%%%; padding: 9px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; }

/* Smartphone Shell Simulations */
.phone-container-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-top: 20px; }
.phone-shell { background: #1e293b; border: 12px solid #0f172a; border-radius: 36px; padding: 18px; box-sizing: border-box; height: 560px; color: #1e293b; display: flex; flex-direction: column; box-shadow: 0 10px 25px rgba(0,0,0,0.15); position: relative;}
.phone-screen { background: #f8fafc; border-radius: 20px; flex: 1; padding: 15px; overflow-y: auto; display: flex; flex-direction: column; font-size: 13px; }
.phone-header { background: #0284c7; color: white; padding: 12px; border-radius: 10px; text-align: center; font-weight: 700; margin-bottom: 15px; font-size: 14px; }
.phone-header.driver-banner { background: #1e293b; }

/* Custom Mobile Components */
.wallet-card-choice { border: 2px solid #cbd5e1; border-radius: 10px; padding: 12px; margin-bottom: 10px; cursor: pointer; display: flex; align-items: center; justify-content: space-between; background: white; font-weight:600;}
.wallet-card-choice.selected-orange { border-color: #ea580c; background: #fff7ed; }
.wallet-card-choice.selected-wave { border-color: #0284c7; background: #f0f9ff; }
.mobile-modal-alert { background: #fef2f2; border: 2px dashed #dc2626; padding: 12px; border-radius: 10px; color: #991b1b; margin-top: 15px; font-weight: 600; }
</style>
<script>
function selectRiderWallet(type) {
var oCard = document.getElementById('card-opt-orange');
var wCard = document.getElementById('card-opt-wave');
var inputTarget = document.getElementById('rider-phone-input');
if(type === 'orange') {
oCard.className = "wallet-card-choice selected-orange";
wCard.className = "wallet-card-choice";
inputTarget.value = "00224629135060";
} else {
wCard.className = "wallet-card-choice selected-wave";
oCard.className = "wallet-card-choice";
inputTarget.value = "+224-622-99-88-11";
}
}
function triggerMobileRiderCheck() {
alert("🛡️ AFROUNITED SECURITY CHECK PROTOCOL\n\nBefore you step inside the taxi vehicle:\n1. Verify the driver's face matches the application profile image portrait.\n2. Confirm physical license plate matches numbers exactly!");
}
function alertPayoutDispatched(driverName, method, target) {
alert("💸 TRANSACTION SENT\n\nPlatform has successfully routed the earnings settlement for " + driverName + " directly to their preferred " + method + " wallet: " + target);
}
</script>
</head>
<body>
<div class="sidebar">
<h2>Afrounited Control</h2>
<a href="#" class="active">Ecosystem Console</a>
<a href="/admin/drivers">JSON Data Out</a>
</div>
<div class="main-content">

<div class="stats-grid">
<div class="card admin">
<div class="card-title">System Vault Revenue</div>
<div class="card-value">$%.2f</div>
</div>
<div class="card" style="border-left-color: #eab308;">
<div class="card-title">Taxi Fleet Revenue (28.5%%%%)</div>
<div class="card-value">$%.2f</div>
</div>
<div class="card" style="border-left-color: #10b981;">
<div class="card-title">Delivery Fleet Revenue (15%%%%)</div>
<div class="card-value">$%.2f</div>
</div>
</div>

<div class="layout-grid">
<div class="panel">
<h3>Active Fleet Drivers & Payout Targets</h3>
<table>
<thead>
<tr>
<th>Driver</th>
<th>Service</th>
<th>Accrued Earnings</th>
<th>Payout Method</th>
<th>Wallet Targets</th>
<th>Action Execution</th>
</tr>
</thead>
<tbody>
`+getDriversHTML()+`
</tbody>
</table>
</div>

<div class="panel">
<h3>Master Platform Payout Setup</h3>
<form action="/admin/save-payout" method="POST">
<div class="form-group">
<label>Platform Orange Money Number</label>
<input type="text" name="orange" placeholder="+224..." value="`+adminOrangeMoney+`">
</div>
<div class="form-group">
<label>Platform Wave Number</label>
<input type="text" name="wave" placeholder="+224..." value="`+adminWave+`">
</div>
<button type="submit" class="btn">Update Master Vault</button>
</form>
<div style="background:#f8fafc; padding:10px; border-radius:6px; margin-top:12px; font-size:12px; border-left:3px solid #0284c7;">
🍊 <strong>Active Orange Vault:</strong> `+adminOrangeMoney+`<br>
🌊 <strong>Active Wave Vault:</strong> `+adminWave+`
</div>
</div>
</div>

<h3>Live Mobile Smartphone Screen Mockups</h3>
<div class="phone-container-grid">

<div class="phone-shell">
<div class="phone-screen">
<div class="phone-header">Afrounited Rider App</div>

<label style="margin-top:5px; font-weight:700;">Select Billing Method at Checkout:</label>
<div id="card-opt-orange" class="wallet-card-choice selected-orange" onclick="selectRiderWallet('orange')">
<span>🍊 Orange Money Guinee</span>
<span style="color:#ea580c; font-size:11px;">Active</span>
</div>
<div id="card-opt-wave" class="wallet-card-choice" onclick="selectRiderWallet('wave')">
<span>🌊 Wave Mobile Money</span>
<span style="color:#0284c7; font-size:11px;">Select</span>
</div>

<div class="form-group" style="margin-top:10px;">
<label>Linked Billing Account Number</label>
<input type="text" id="rider-phone-input" value="00224629135060" readonly style="background:#e2e8f0; font-weight:700; color:#334155;">
</div>

<div class="mobile-modal-alert">
🛡️ SECURITY ALERTS SYSTEM RUNNING<br>
<span style="font-size:11px; font-weight:500; color:#475569; display:block; margin-top:4px;">Anti-fraud prompts enforce facial visual verification before trips begin.</span>
</div>

<button class="btn" style="background:#16a34a; margin-top:auto; padding:12px;" onclick="triggerMobileRiderCheck()">Book Safe Ride Now</button>
</div>
</div>

<div class="phone-shell">
<div class="phone-screen">
<div class="phone-header driver-banner">Afrounited Driver App</div>

<div style="background:white; padding:15px; border-radius:10px; border:1px solid #e2e8f0; text-align:center; margin-bottom:15px; box-shadow:0 2px 4px rgba(0,0,0,0.02);">
<div style="font-size:11px; text-transform:uppercase; color:#64748b; font-weight:600;">Accrued Driver Balance</div>
<div style="font-size:28px; font-weight:800; color:#1e293b; margin-top:2px;">$120.50</div>
</div>

<label style="font-weight:700; display:block; margin-bottom:6px;">Your Destination Payout Target:</label>
<div style="background:#f1f5f9; padding:12px; border-radius:8px; border-left:4px solid #ea580c; font-size:12px;">
<strong>Method:</strong> Orange Money<br>
<strong>Number:</strong> +224-664-44-55-66<br>
<span style="color:#64748b; font-size:11px; display:block; margin-top:4px;">Configured securely from settings panel</span>
</div>

<div style="margin-top:20px; font-size:12px; color:#475569; line-height:1.4;">
ℹ️ <em>Payout requests directly ping the Master Platform Vault. Funds route smoothly into your local wallet cuts once processed by the administrator panel above.</em>
</div>

<button class="btn" style="background:#ea580c; margin-top:auto; padding:12px;" onclick="alert('Polled! Payout transfer request dispatched securely to system administration vault.')">Request Wallet Transfer</button>
</div>
</div>

</div>

</div>
</body>
</html>
`, totalRevenue, totalTaxi, totalDelivery)
}

func getDriversHTML() string {
html := ""
for _, d := range drivers {
badgeClass := "wave"
if d.PayoutType == "Orange Money" {
badgeClass = "orange"
}

statusAction := ""
if d.Status == "pending" {
statusAction = fmt.Sprintf(`
<form action="/admin/drivers/status?id=%d&status=approved" method="POST" style="margin:0; display:inline;">
<button type="submit" class="btn btn-action">Approve</button>
</form>`, d.ID)
} else {
statusAction = fmt.Sprintf(`
<span class="badge approved">Approved</span>
<button type="button" class="btn btn-payout" onclick="alertPayoutDispatched('%s', '%s', '%s')">Send Payout</button>
`, d.Name, d.PayoutType, d.PayoutPhone)
}

html += fmt.Sprintf(`
<tr>
<td><strong>%s</strong></td>
<td>%s</td>
<td style="font-weight:700; color:#1e293b;">$%s</td>
<td><span class="badge %s">%s</span></td>
<td>%s</td>
<td>%s</td>
</tr>`, d.Name, d.Service, fmt.Sprintf("%.2f", d.Earnings), badgeClass, d.PayoutType, d.PayoutPhone, statusAction)
}
return html
}

func savePayoutHandler(w http.ResponseWriter, r *http.Request) {
if r.Method == http.MethodPost {
r.ParseForm()
adminOrangeMoney = r.FormValue("orange")
adminWave = r.FormValue("wave")
}
http.Redirect(w, r, "/", http.StatusSeeOther)
}

func clearDriverPayoutHandler(w http.ResponseWriter, r *http.Request) {
idStr := r.URL.Query().Get("id")
id, _ := strconv.Atoi(idStr)
for i, d := range drivers {
if d.ID == id {
drivers[i].Earnings = 0.0
break
}
}
http.Redirect(w, r, "/", http.StatusSeeOther)
}

func addCustomerHandler(w http.ResponseWriter, r *http.Request) {
if r.Method == http.MethodPost {
r.ParseForm()
newC := Customer{
Name: r.FormValue("name"),
PaymentType: r.FormValue("wallet"),
Phone: r.FormValue("phone"),
}
customers = append(customers, newC)
}
http.Redirect(w, r, "/", http.StatusSeeOther)
}

func addOrderHandler(w http.ResponseWriter, r *http.Request) {
if r.Method == http.MethodPost {
r.ParseForm()
newID := 100 + len(liveOrders) + 1
newO := LiveOrder{
ID: newID,
Restaurant: r.FormValue("restaurant"),
Item: r.FormValue("item"),
Driver: "Mariama Barry",
Status: "Ready for Pickup",
}
liveOrders = append(liveOrders, newO)
}
http.Redirect(w, r, "/", http.StatusSeeOther)
}

func listDriversHandler(w http.ResponseWriter, r *http.Request) {
w.Header().Set("Content-Type", "application/json")
json.NewEncoder(w).Encode(drivers)
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
// UpdateDriverStatus handles approving or rejecting drivers from the dashboard
func UpdateDriverStatus(driverID int, newStatus string) string {
// This will connect to the Pending/Approved/Rejected buttons on your screen
message := "Driver ID " + strconv.Itoa(driverID) + " status changed to: " + newStatus
return message
}


// GetDashboardStats calculates the live numbers and sends them to the HTML dashboard
func GetDashboardStats(w http.ResponseWriter, r *http.Request) {
pendingCount := 0
approvedCount := 0
rejectedCount := 0

// Count up all the drivers based on their current status
for _, d := range drivers {
if d.Status == "pending" {
pendingCount++
} else if d.Status == "approved" {
approvedCount++
} else if d.Status == "rejected" {
rejectedCount++
}
}

// Package the numbers into JSON format so the HTML can read it easily
w.Header().Set("Content-Type", "application/json")
json.NewEncoder(w).Encode(map[string]int{
"pending": pendingCount,
"approved": approvedCount,
"rejected": rejectedCount,
})
}
