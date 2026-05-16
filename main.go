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
.sidebar a { display: block; color: #94a3b8; padding: 12px; text-decoration: none; border-radius: 6px; margin-bottom: 8px; }
.sidebar a.active { background-color: #1e293b; color: white; }
.main-content { flex: 1; padding: 40px; box-sizing: border-box; overflow-y: auto; max-height: 100vh; }
.stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px; }
.card { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border-left: 5px solid #3b82f6; }
.card.admin { border-left-color: #38bdf8; background: #f0f9ff; }
.card-title { font-size: 12px; color: #64748b; text-transform: uppercase; font-weight: 600; }
.card-value { font-size: 26px; font-weight: 700; color: #1e293b; margin-top: 5px; }
.layout-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; margin-bottom: 25px; }
.panel { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 25px; }
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
.btn-payout { background: #ea580c; font-size: 11px; padding: 4px 8px; width: auto; margin-left: 5px; }
.form-group { margin-bottom: 12px; }
label { display: block; font-size: 12px; color: #475569; font-weight: 600; margin-bottom: 4px; }
input[type="text"], select { width: 100%%; padding: 9px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; }
.safety-banner { background: #fef2f2; border: 1px solid #fee2e2; padding: 15px; border-radius: 8px; margin-bottom: 25px; display: flex; align-items: center; justify-content: space-between; }
.safety-title { color: #991b1b; font-weight: 700; font-size: 14px; }
</style>
<script>
function triggerRestaurantPopup(restaurantName, driverName) {
alert("🚨 AFROUNITED SECURE PICKUP VERIFICATION\n\n[Store Location: " + restaurantName + "]\n\nINSTRUCTION FOR RESTAURANT PARTNER:\nBefore handing over the container, you MUST confirm the mobile app profile photo matches driver: " + driverName.toUpperCase() + ".");
}
function triggerRiderSafetyPopup() {
alert("🛡️ ANTI-FRAUD RIDER VEHICLE MATCHING CHECK\n\nBEFORE ENTERING THE VEHICLE:\n1. Verify the driver's face matches the profile portrait in your app.\n2. Confirm the vehicle license plate matches your active ride receipt exactly.");
}
function alertPayoutDispatched(driverName, method, target) {
alert("💸 TRANSACTION SENT\n\nPlatform has successfully routed the earnings settlement for " + driverName + " directly to their preferred " + method + " wallet: " + target);
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
<div class="safety-title">🛑 <strong>Rider Security Protocols Active</strong></div>
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

<div class="layout-grid">
<div class="panel">
<h3>Simulate Restaurant Food Order Dispatch</h3>
<form action="/admin/add-order" method="POST" style="margin-bottom: 15px;">
<div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px;">
<div>
<label>Restaurant Partner</label>
<select name="restaurant">
<option value="Le Ciel Conakry">Le Ciel Conakry</option>
<option value="Restaurant Bembeya">Restaurant Bembeya</option>
</select>
</div>
<div>
<label>Food Item</label>
<input type="text" name="item" placeholder="e.g., Attieke, Shawarma" required>
</div>
<div style="display:flex; align-items:flex-end;">
<button type="submit" class="btn" style="background:#16a34a;">Send Active Order</button>
</div>
</div>
</form>

<h4>Active Operations Tracking Pipeline</h4>
<table>
<thead>
<tr>
<th>ID</th>
<th>Restaurant</th>
<th>Order Content</th>
<th>Assigned Courier</th>
<th>Safety Action</th>
</tr>
</thead>
<tbody>
`+getOrdersHTML()+`
</tbody>
</table>
</div>

<div class="panel">
<h3>Simulate App User Wallet Registration</h3>
<form action="/admin/add-customer" method="POST">
<div class="form-group">
<label>Customer Full Name</label>
<input type="text" name="name" placeholder="John Doe" required>
</div>
<div class="form-group">
<label>Preferred Payment Wallet</label>
<select name="wallet">
<option value="Orange Money">Orange Money</option>
<option value="Wave">Wave</option>
</select>
</div>
<div class="form-group">
<label>Mobile Number</label>
<input type="text" name="phone" placeholder="+224..." required>
</div>
<button type="submit" class="btn" style="background:#0ea5e9;">Register User Wallet</button>
</form>

<h4 style="margin-top:15px; margin-bottom:5px;">Registered Accounts</h4>
<div style="max-height:100px; overflow-y:auto; font-size:12px; background:#f8fafc; padding:8px; border-radius:6px;">
`+getCustomersHTML()+`
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
<a href="/admin/drivers/clear-payout?id=%d" style="text-decoration:none;" onclick="alertPayoutDispatched('%s', '%s', '%s')">
<button type="button" class="btn btn-payout">Send Payout</button>
</a>`, d.ID, d.Name, d.PayoutType, d.PayoutPhone)
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

func getOrdersHTML() string {
html := ""
for _, o := range liveOrders {
html += fmt.Sprintf(`
<tr>
<td>#%d</td>
<td style="color:#0284c7; font-weight:600;">📍 %s</td>
<td>%s</td>
<td><strong>%s</strong></td>
<td><button class="btn" style="padding:3px 6px; font-size:11px; background:#475569;" onclick="triggerRestaurantPopup('%s', '%s')">Verify Handshake</button></td>
</tr>`, o.ID, o.Restaurant, o.Item, o.Driver, o.Restaurant, o.Driver)
}
return html
}

func getCustomersHTML() string {
html := ""
for _, c := range customers {
badgeClass := "wave"
if c.PaymentType == "Orange Money" {
badgeClass = "orange"
}
html += fmt.Sprintf(`<div>👤 <strong>%s</strong> - <span class="badge %s" style="font-size:10px; padding:2px 5px;">%s</span> (%s)</div>`, c.Name, badgeClass, c.PaymentType, c.Phone)
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
drivers[i].Earnings = 0.0 // Clear balance upon payment simulation
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
