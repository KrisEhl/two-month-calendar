# Two Month Calendar

A macOS Notification Center widget that shows this month and next month side by side
(medium size), or four months in a 2x2 grid (large size).

## Install

```sh
brew install xcodegen
make install   # generates the Xcode project, builds Release, copies to /Applications, opens it
```

Then click the clock in the menu bar → **Edit Widgets** → search "Two Month Calendar".

## Layout

- `Shared/MonthView.swift` — month grid (locale-aware first weekday, today highlighted)
- `Widget/CalendarWidget.swift` — WidgetKit timeline (refreshes after midnight) and layouts
- `App/` — host app; registers the widget and, when launched (e.g. by clicking the widget), opens Apple Calendar and quits
- `project.yml` — XcodeGen spec; the `.xcodeproj` is generated and not committed
