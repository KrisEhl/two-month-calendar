import SwiftUI
import WidgetKit

struct CalendarEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> Void) {
        completion(CalendarEntry(date: .now))
    }

    /// One entry for now, refreshed just after the next midnight so "today" moves.
    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> Void) {
        let calendar = Calendar.current
        let nextMidnight = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: 1, to: .now) ?? .now)
        let timeline = Timeline(
            entries: [CalendarEntry(date: .now)],
            policy: .after(nextMidnight.addingTimeInterval(1)))
        completion(timeline)
    }
}

struct CalendarWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: CalendarEntry

    var body: some View {
        switch family {
        case .systemLarge:
            // Four months in a 2x2 grid: this month plus the next three.
            Grid(horizontalSpacing: 16, verticalSpacing: 12) {
                GridRow {
                    month(offset: 0)
                    month(offset: 1)
                }
                GridRow {
                    month(offset: 2)
                    month(offset: 3)
                }
            }
        default:
            HStack(alignment: .top, spacing: 16) {
                month(offset: 0)
                month(offset: 1)
            }
        }
    }

    private func month(offset: Int) -> some View {
        MonthView(monthStart: monthStart(for: entry.date, offset: offset), today: entry.date)
    }
}

@main
struct CalendarWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TwoMonthCalendar", provider: Provider()) { entry in
            CalendarWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Two Month Calendar")
        .description("This month and next side by side.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    CalendarWidget()
} timeline: {
    CalendarEntry(date: .now)
}
