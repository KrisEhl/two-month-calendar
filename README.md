# Two Month Calendar

A macOS Notification Center widget that shows this month and next month side by side.
macOS's own Calendar widget only shows the current month.

## Requirements

- macOS 14 or later
- Xcode (command-line tools alone are not enough)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

## Install

```sh
git clone git@github.com:KrisEhl/two-month-calendar.git
cd two-month-calendar
make install
```

`make install` generates the Xcode project, builds a Release version, copies
`TwoMonthCalendar.app` to `/Applications`, and opens it once so macOS registers the widget.
Opening the app just launches Apple Calendar; that is expected (see below).

## Usage

### Add the widget

1. Click the date/time in the menu bar to open Notification Center.
2. Scroll to the bottom and click **Edit Widgets**.
3. Search for **Two Month Calendar**.
4. Pick a size and click it (or drag it into Notification Center or onto the desktop):
   - **Medium**: this month and next month side by side.
   - **Large**: four months (this month plus the next three) in a 2×2 grid.
5. Click **Done**.

### What it shows

- Weeks start on your system's first weekday (System Settings → General → Language & Region).
- Today is marked with a red circle, and the current month's title is red.
- The widget refreshes just after midnight, so it rolls over to the next day and month by itself.

### Clicking the widget

Clicking the widget opens Apple Calendar. Behind the scenes, macOS launches
`TwoMonthCalendar.app`, which has no window or Dock icon. It opens Calendar and quits immediately.

## Update after changing the code

```sh
make install
pkill -f CalendarWidget   # make Notification Center reload the widget
```

If the widget still looks old, remove it (Edit Widgets → ⊖) and add it again; macOS
sometimes caches the previous rendering.

## Uninstall

1. Remove the widget from Notification Center (Edit Widgets → ⊖).
2. `rm -rf /Applications/TwoMonthCalendar.app`

## Troubleshooting

- **Widget not in the gallery:** open `/Applications/TwoMonthCalendar.app` once, then reopen
  Edit Widgets. Check registration with
  `pluginkit -m -p com.apple.widgetkit-extension | grep twomonth`.
- **Clicking does nothing:** make sure `/Applications/TwoMonthCalendar.app` exists (the widget
  needs its host app) and that Calendar is at `/System/Applications/Calendar.app`.

## Project layout

- `Shared/MonthView.swift`: month grid (first weekday from your locale, today highlighted)
- `Widget/CalendarWidget.swift`: WidgetKit timeline (refreshes after midnight) and the medium/large layouts
- `App/`: host app that registers the widget and forwards clicks to Apple Calendar.
  It is not sandboxed, so it can launch Calendar; the widget itself is sandboxed.
- `project.yml`: XcodeGen spec. `TwoMonthCalendar.xcodeproj` is generated and not committed.
- `Makefile`: `project`, `build`, `install`, `clean`

The app is signed ad hoc (no Apple developer certificate), so it runs on the Mac that built
it. To share it with others, it would need a Developer ID signature and notarization.
