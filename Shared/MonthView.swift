import SwiftUI

/// A compact month grid with weekday headers and today highlighted.
struct MonthView: View {
    let monthStart: Date
    let today: Date
    var calendar: Calendar = .current

    private var title: String {
        monthStart.formatted(.dateTime.month(.wide).year())
    }

    /// Weekday symbols rotated so the locale's first weekday comes first.
    private var weekdaySymbols: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let offset = calendar.firstWeekday - 1
        return Array(symbols[offset...] + symbols[..<offset])
    }

    /// Day numbers for the month, padded with nil so day 1 lands under its weekday.
    private var cells: [Int?] {
        let weekdayOfFirst = calendar.component(.weekday, from: monthStart)
        let leadingBlanks = (weekdayOfFirst - calendar.firstWeekday + 7) % 7
        let dayCount = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? 30
        var result: [Int?] = Array(repeating: nil, count: leadingBlanks)
        result += (1...dayCount).map { Optional($0) }
        while result.count % 7 != 0 { result.append(nil) }
        return result
    }

    private var todayDay: Int? {
        calendar.isDate(today, equalTo: monthStart, toGranularity: .month)
            ? calendar.component(.day, from: today) : nil
    }

    var body: some View {
        let weeks = stride(from: 0, to: cells.count, by: 7).map { Array(cells[$0..<$0 + 7]) }
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(todayDay != nil ? Color.red : Color.primary)
            // Plain Grid with one GridRow per week: headers and day cells live in
            // separate ForEach scopes, so their identities can never collide.
            Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                GridRow {
                    ForEach(weekdaySymbols.indices, id: \.self) { index in
                        Text(weekdaySymbols[index])
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.secondary)
                            .frame(width: 16)
                    }
                }
                ForEach(weeks.indices, id: \.self) { weekIndex in
                    GridRow {
                        ForEach(0..<7, id: \.self) { dayIndex in
                            let day = weeks[weekIndex][dayIndex]
                            DayCell(day: day, isToday: day != nil && day == todayDay)
                        }
                    }
                }
            }
        }
    }
}

private struct DayCell: View {
    let day: Int?
    let isToday: Bool

    var body: some View {
        Text(day.map(String.init) ?? "")
            .font(.system(size: 10, weight: isToday ? .bold : .regular))
            .monospacedDigit()
            .foregroundStyle(isToday ? Color.white : Color.primary)
            .frame(width: 16, height: 16)
            .background {
                if isToday { Circle().fill(Color.red) }
            }
    }
}

/// Start of the month containing `date`, shifted by `offset` months.
func monthStart(for date: Date, offset: Int, calendar: Calendar = .current) -> Date {
    let start = calendar.dateInterval(of: .month, for: date)?.start ?? date
    return calendar.date(byAdding: .month, value: offset, to: start) ?? start
}
