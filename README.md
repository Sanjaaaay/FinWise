# FinWise

A native iOS expense & budget tracker built with SwiftUI. Log expenses and income, browse spending by category, chart trends over time, and manage your account — all with a custom teal/mint theme and its own light/dark mode.

## Features

- **Auth flow** — Launch screen, onboarding, login, sign up, forgot/reset password, PIN and Fingerprint unlock
- **Home** — Budget overview, savings-on-goals card, Daily/Weekly/Monthly transaction list, quick Add Expense/Income
- **Add Expense / Add Income** — Single form with an Expense/Income toggle, category picker, real date picker, and note field
- **Categories** — Grid of spending categories, each with its own detail view and transaction history; custom categories via "New Category"
- **Savings Goals** — Travel, New House, Car, Wedding goals with progress rings and deposit history
- **Analysis** — Daily/Weekly/Monthly/Yearly bar charts, search & filter transactions, calendar view
- **Transactions** — Full history grouped by month
- **Account Balance & Quickly Analysis** — Income/expense breakdowns reachable from Home
- **Notifications** — Reminders and a live feed of transaction activity
- **Profile** — Edit profile with an independent in-app dark theme toggle
- **Security** — Change PIN, manage Fingerprint (add/delete), Terms & Conditions
- **Settings** — Notification preferences, change password, delete account
- **Help & Support** — FAQ search, Contact Us, and an Online Support chat
- **Logout** — Confirmation modal before ending the session

## Screenshots

### Onboarding & Auth

<table>
<tr>
<td><img src="screenshots/01-launch.png" width="200"/></td>
<td><img src="screenshots/02-onboarding.png" width="200"/></td>
<td><img src="screenshots/03-login.png" width="200"/></td>
<td><img src="screenshots/04-create-account.png" width="200"/></td>
</tr>
<tr>
<td align="center">Launch</td>
<td align="center">Onboarding</td>
<td align="center">Login</td>
<td align="center">Create Account</td>
</tr>
</table>

### Home & Adding Transactions

<table>
<tr>
<td><img src="screenshots/05-home.png" width="200"/></td>
<td><img src="screenshots/06-add-expense.png" width="200"/></td>
<td><img src="screenshots/07-add-income.png" width="200"/></td>
<td><img src="screenshots/08-date-picker.png" width="200"/></td>
</tr>
<tr>
<td align="center">Home</td>
<td align="center">Add Expense</td>
<td align="center">Add Income</td>
<td align="center">Date Picker</td>
</tr>
</table>

### Categories & Savings

<table>
<tr>
<td><img src="screenshots/09-categories.png" width="200"/></td>
<td><img src="screenshots/10-category-detail.png" width="200"/></td>
<td><img src="screenshots/11-savings-goals.png" width="200"/></td>
</tr>
<tr>
<td align="center">Categories</td>
<td align="center">Category Detail</td>
<td align="center">Savings Goals</td>
</tr>
</table>

### Analysis & Transactions

<table>
<tr>
<td><img src="screenshots/12-analysis.png" width="200"/></td>
<td><img src="screenshots/13-search.png" width="200"/></td>
<td><img src="screenshots/14-calendar.png" width="200"/></td>
<td><img src="screenshots/15-transactions.png" width="200"/></td>
</tr>
<tr>
<td align="center">Analysis Charts</td>
<td align="center">Search</td>
<td align="center">Calendar</td>
<td align="center">Transactions</td>
</tr>
</table>

<table>
<tr>
<td><img src="screenshots/16-account-balance.png" width="200"/></td>
<td><img src="screenshots/17-quickly-analysis.png" width="200"/></td>
<td><img src="screenshots/18-notifications.png" width="200"/></td>
</tr>
<tr>
<td align="center">Account Balance</td>
<td align="center">Quickly Analysis</td>
<td align="center">Notifications</td>
</tr>
</table>

### Profile & Settings

<table>
<tr>
<td><img src="screenshots/19-profile.png" width="200"/></td>
<td><img src="screenshots/20-dark-mode.png" width="200"/></td>
<td><img src="screenshots/21-security.png" width="200"/></td>
<td><img src="screenshots/22-change-pin.png" width="200"/></td>
</tr>
<tr>
<td align="center">Profile</td>
<td align="center">Dark Mode</td>
<td align="center">Security</td>
<td align="center">Change Pin</td>
</tr>
</table>

<table>
<tr>
<td><img src="screenshots/23-fingerprint.png" width="200"/></td>
<td><img src="screenshots/24-settings.png" width="200"/></td>
<td><img src="screenshots/25-password-success.png" width="200"/></td>
<td><img src="screenshots/26-delete-account.png" width="200"/></td>
</tr>
<tr>
<td align="center">Fingerprint</td>
<td align="center">Settings</td>
<td align="center">Password Changed</td>
<td align="center">Delete Account</td>
</tr>
</table>

### Help & Logout

<table>
<tr>
<td><img src="screenshots/27-help-faq.png" width="200"/></td>
<td><img src="screenshots/28-online-support.png" width="200"/></td>
<td><img src="screenshots/29-logout.png" width="200"/></td>
</tr>
<tr>
<td align="center">Help & FAQs</td>
<td align="center">Online Support</td>
<td align="center">Logout Confirmation</td>
</tr>
</table>

## Tech

- SwiftUI, iOS 17+
- Swift Charts for the Analysis bar charts
- No third-party dependencies — the whole app is native SwiftUI
