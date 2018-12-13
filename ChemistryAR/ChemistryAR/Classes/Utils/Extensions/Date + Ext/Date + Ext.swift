import Foundation

public extension Date {
    
    /// User’s current calendar.
    public var calendar: Calendar {
        return Calendar.current
    }
    
    /// Era.
    public var era: Int {
        return calendar.component(.era, from: self)
    }
    
    /// Year.
    public var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: newValue, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        }
    }
    
    /// Quarter.
    public var quarter: Int {
        return calendar.component(.quarter, from: self)
    }
    
    /// Month.
    public var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: newValue, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        }
    }
    
    /// Week of year.
    public var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    /// Week of month.
    public var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }
    
    /// Weekday.
    public var weekday: Int {
        return calendar.component(.weekday, from: self)
    }
    
    /// Day.
    public var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: newValue, hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        }
    }
    
    /// Hour.
    public var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: newValue, minute: minute, second: second, nanosecond: nanosecond)
        }
    }
    
    /// Minutes.
    public var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: hour, minute: newValue, second: second, nanosecond: nanosecond)
        }
    }
    
    /// Seconds.
    public var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: newValue, nanosecond: nanosecond)
        }
    }
    
    /// Nanoseconds.
    public var nanosecond: Int {
        return calendar.component(.nanosecond, from: self)
    }
    
    /// Check if date is in future.
    public var isInFuture: Bool {
        return self > Date()
    }
    
    /// Check if date is in past.
    public var isInPast: Bool {
        return self < Date()
    }
    
    /// Check if date is in today.
    public var isInToday: Bool {
        return self.day == Date().day && self.month == Date().month && self.year == Date().year
    }
    
    /// ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
    public var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
    /// Nearest five minutes to date.
    public var nearestFiveMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month , .day , .hour , .minute], from: self)
        guard let min = components.minute else {
            return self
        }
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        if min > 57 {
            components.hour? += 1
        }
        return Calendar.current.date(from: components) ?? Date()
    }
    
    /// Nearest ten minutes to date.
    public var nearestTenMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month , .day , .hour , .minute], from: self)
        guard let min = components.minute else {
            return self
        }
        components.minute! = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        if min > 55 {
            components.hour? += 1
        }
        return Calendar.current.date(from: components) ?? Date()
    }
    
    /// Nearest quarter to date.
    public var nearestHourQuarter: Date {
        var components = Calendar.current.dateComponents([.year, .month , .day , .hour , .minute], from: self)
        guard let min = components.minute else {
            return self
        }
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        if min > 52 {
            components.hour? += 1
        }
        return Calendar.current.date(from: components) ?? Date()
    }
    
    /// Nearest half hour to date.
    public var nearestHalfHour: Date {
        var components = Calendar.current.dateComponents([.year, .month , .day , .hour , .minute], from: self)
        guard let min = components.minute else {
            return self
        }
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        if min > 30 {
            components.hour? += 1
        }
        return Calendar.current.date(from: components) ?? Date()
    }
    
    /// Time zone used by system.
    public var timeZone: TimeZone {
        return self.calendar.timeZone
    }
    
    /// UNIX timestamp from date.
    public var unixTimestamp: Double {
        return timeIntervalSince1970
    }
    
}


// MARK: - Methods
public extension Date {
    
    /// Add calendar component to date.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of compnenet to add.
    public mutating func add(_ component: Calendar.Component, value: Int) {
        switch component {
        case .second:
            self = calendar.date(byAdding: .second, value: value, to: self) ?? self
            break
            
        case .minute:
            self = calendar.date(byAdding: .minute, value: value, to: self) ?? self
            break
            
        case .hour:
            self = calendar.date(byAdding: .hour, value: value, to: self) ?? self
            break
            
        case .day:
            self = calendar.date(byAdding: .day, value: value, to: self) ?? self
            break
            
        case .weekOfYear, .weekOfMonth:
            self = calendar.date(byAdding: .day, value: value * 7, to: self) ?? self
            break
            
        case .month:
            self = calendar.date(byAdding: .month, value: value, to: self) ?? self
            break
            
        case .year:
            self = calendar.date(byAdding: .year, value: value, to: self) ?? self
            break
            
        default:
            break
        }
    }
    
    /// Date by adding multiples of calendar component.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of compnenets to add.
    /// - Returns: original date + multiples of compnenet added.
    public func adding(_ component: Calendar.Component, value: Int) -> Date {
        switch component {
        case .second:
            return calendar.date(byAdding: .second, value: value, to: self) ?? self
            
        case .minute:
            return calendar.date(byAdding: .minute, value: value, to: self) ?? self
            
        case .hour:
            return calendar.date(byAdding: .hour, value: value, to: self) ?? self
            
        case .day:
            return calendar.date(byAdding: .day, value: value, to: self) ?? self
            
        case .weekOfYear, .weekOfMonth:
            return calendar.date(byAdding: .day, value: value * 7, to: self) ?? self
            
        case .month:
            return calendar.date(byAdding: .month, value: value, to: self) ?? self
            
        case .year:
            return calendar.date(byAdding: .year, value: value, to: self) ?? self
            
        default:
            return self
        }
    }
    
    /// Date by changing value of calendar component.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: new value of compnenet to change.
    /// - Returns: original date + multiples of compnenets added.
    public func changing(_ component: Calendar.Component, value: Int) -> Date {
        switch component {
        case .second:
            var date = self
            date.second = value
            return date
            
        case .minute:
            var date = self
            date.minute = value
            return date
            
        case .hour:
            var date = self
            date.hour = value
            return date
            
        case .day:
            var date = self
            date.day = value
            return date
            
        case .month:
            var date = self
            date.month = value
            return date
            
        case .year:
            var date = self
            date.year = value
            return date
            
        default:
            return self
        }
    }
    
    /// Data at the beginning of calendar component.
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    public func beginning(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            return calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self))
            
        case .minute:
            return calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self))
            
        case .hour:
            return calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: self))
            
        case .day:
            return self.calendar.startOfDay(for: self)
            
        case .weekOfYear, .weekOfMonth:
            return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
            
        case .month:
            return calendar.date(from: calendar.dateComponents([.year, .month], from: self))
            
        case .year:
            return calendar.date(from: calendar.dateComponents([.year], from: self))
            
        default:
            return nil
        }
    }
    
    /// Date at the end of calendar component.
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    public func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = self.adding(.second, value: 1)
            guard let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)) else {
                return nil
            }
            date = after
            date.add(.second, value: -1)
            return date
            
        case .minute:
            var date = self.adding(.minute, value: 1)
            guard let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)) else {
                return nil
            }
            date = after.adding(.second, value: -1)
            return date
            
        case .hour:
            var date = self.adding(.hour, value: 1)
            guard let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: self)) else {
                return nil
            }
            date = after.adding(.second, value: -1)
            return date
            
        case .day:
            var date = self.adding(.day, value: 1)
            date = date.calendar.startOfDay(for: date)
            date.add(.second, value: -1)
            return date
            
        case .weekOfYear, .weekOfMonth:
            var date = self
            guard let beginningOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
                return nil
            }
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date
            
        case .month:
            var date = self.adding(.month, value: 1)
            guard let after = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) else {
                return nil
            }
            date = after.adding(.second, value: -1)
            return date
            
        case .year:
            var date = self.adding(.year, value: 1)
            guard let after = calendar.date(from: calendar.dateComponents([.year], from: self)) else {
                return nil
            }
            date = after.adding(.second, value: -1)
            return date
            
        default:
            return nil
        }
    }
    
    /// Date string from date.
    ///
    /// - Parameter style: DateFormatter style (default is .medium)
    /// - Returns: date string
    func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// Date and time string from date.
    ///
    /// - Parameter style: DateFormatter style (default is .medium)
    /// - Returns: date and time string
    public func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// Check if date is in current given calendar component.
    ///
    /// - Parameter component: calendar componenet to check.
    /// - Returns: true if date is in current given calendar component.
    public func isInCurrent(_ component: Calendar.Component) -> Bool {
        switch component {
        case .second:
            return second == Date().second && minute == Date().minute && hour == Date().hour && day == Date().day
                && month == Date().month && year == Date().year && era == Date().era
            
        case .minute:
            return minute == Date().minute && hour == Date().hour && day == Date().day && month == Date().month
                && year == Date().year && era == Date().era
            
        case .hour:
            return hour == Date().hour && day == Date().day && month == Date().month && year == Date().year
                && era == Date().era
            
        case .day:
            return day == Date().day && month == Date().month && year == Date().year && era == Date().era
            
        case .weekOfYear, .weekOfMonth:
            let beginningOfWeek = Date().beginning(of: .weekOfMonth)!
            let endOfWeek = Date().end(of: .weekOfMonth)!
            return self >= beginningOfWeek && self <= endOfWeek
            
        case .month:
            return month == Date().month && year == Date().year && era == Date().era
            
        case .year:
            return year == Date().year && era == Date().era
            
        case .era:
            return era == Date().era
            
        default:
            return false
        }
    }
    
    /// Time string from date
    public func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }
    
}


// MARK: - Initializers
public extension Date {
    
    /// Create a new date form calendar components.
    ///
    /// - Parameters:
    ///   - calendar: Calendar (default is current).
    ///   - timeZone: TimeZone (default is current).
    ///   - era: Era (default is current era).
    ///   - year: Year (default is current year).
    ///   - month: Month (default is current month).
    ///   - day: Day (default is today).
    ///   - hour: Hour (default is current hour).
    ///   - minute: Minute (default is current minute).
    ///   - second: Second (default is current second).
    ///   - nanosecond: Nanosecond (default is current nanosecond).
    public init(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = TimeZone.current,
        era: Int? = Date().era,
        year: Int? = Date().year,
        month: Int? = Date().month,
        day: Int? = Date().day,
        hour: Int? = Date().hour,
        minute: Int? = Date().minute,
        second: Int? = Date().second,
        nanosecond: Int? = Date().nanosecond) {
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.era = era
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond
        
        self = calendar?.date(from: components) ?? Date()
    }
    
    /// Create date object from ISO8601 string.
    ///
    /// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
    public init(iso8601String: String) {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self = dateFormatter.date(from: iso8601String) ?? Date()
    }
    
    /// Create new date object from UNIX timestamp.
    ///
    /// - Parameter unixTimestamp: UNIX timestamp.
    public init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp)
    }
    
}

public extension Date {
    /// SwiftRandom extension
    public static func randomWithinDaysBeforeToday(_ days: Int) -> Date {
        let today = Date()
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let r1 = arc4random_uniform(UInt32(days))
        let r2 = arc4random_uniform(UInt32(23))
        let r3 = arc4random_uniform(UInt32(59))
        let r4 = arc4random_uniform(UInt32(59))
        
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(r1) * -1
        offsetComponents.hour = Int(r2)
        offsetComponents.minute = Int(r3)
        offsetComponents.second = Int(r4)
        
        guard let rndDate1 = gregorian.date(byAdding: offsetComponents, to: today) else {
            print("randoming failed")
            return today
        }
        return rndDate1
    }
    
    /// SwiftRandom extension
    public static func random() -> Date {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return Date(timeIntervalSince1970: randomTime)
    }
}

//MARK: - Locale
extension Locale {
    static let en_US_POSIX: Locale = Locale(identifier: "en_US_POSIX")
}

//MARK: - TimeZone
extension TimeZone {
    static let centralTexas: TimeZone = TimeZone(identifier: "UTC-06:00")!
    static fileprivate(set) var app: TimeZone = .current;
}

//MARK: - Calendar
extension Calendar {
    static let app: Calendar = Calendar(identifier: .gregorian, timeZone: .app)
    
    init(identifier: Calendar.Identifier, timeZone: TimeZone) {
        self.init(identifier: identifier);
        self.timeZone = timeZone;
    }
}


//MARK: - Date
extension Date {
    
    static var now: Date {
        return Date();
    }
    
    static func join(date: Date, time: Date) -> Date?{
        var dateComponents = Calendar.app.dateComponents([.year, .month, .day], from: date);
        let timeComponents = Calendar.app.dateComponents([.hour, .minute, .second], from: time);
        dateComponents.hour = timeComponents.hour;
        dateComponents.minute = timeComponents.minute;
        dateComponents.second = timeComponents.second;
        return Calendar.app.date(from: dateComponents);
    }
    
    enum TimeInDay {
        case start;
        case end;
    }
    
    func day(for timeInDay: TimeInDay) -> Date {
        switch timeInDay {
        case .start:
            return startDay();
            
        case .end:
            return endDay();
        }
    }
    
    func startDay() -> Date {
        var dateComponents = Calendar.app.dateComponents([.year, .month, .day], from: self);
        dateComponents.hour = 0;
        dateComponents.minute = 0;
        dateComponents.second = 0;
        return Calendar.app.date(from: dateComponents)!;
    }
    
    func endDay() -> Date {
        var dateComponents = Calendar.app.dateComponents([.year, .month, .day], from: self);
        dateComponents.day = dateComponents.day! + 1;
        dateComponents.hour = 0;
        dateComponents.minute = 0;
        dateComponents.second = -1;
        return Calendar.app.date(from: dateComponents)!;
    }
    
    func startOfMonth() -> Date {
        let dateComponents = Calendar.app.dateComponents([.year,.month],
                                                         from: Calendar.app.startOfDay(for: self))
        return (Calendar.app.date(from: dateComponents)?.startDay())!
    }
    
    func endOfMonth() -> Date {
        return (Calendar.app.date(byAdding: DateComponents(month: 1, day: -1),
                                  to: self.startOfMonth())?.endDay())!
    }
    
    func isEqualExactDay(_ date: Date) -> Bool {
        return  self.year == date.year &&
            self.month == date.month &&
            self.day == date.day
    }
    
    func isEqualExactMinute(_ date: Date ) -> Bool {
        return  (self.year == date.year &&
            self.month == date.month &&
            self.day == date.day &&
            self.minute == date.minute)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.app.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.app.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.app.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.app.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.app.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.app.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.app.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func offsetLong(from date: Date) -> String {
        if years(from: date)   > 0 { return years(from: date) > 1 ? "\(years(from: date)) years ago" : "\(years(from: date)) year ago" }
        if months(from: date)  > 0 { return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago" }
        if weeks(from: date)   > 0 { return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"   }
        if days(from: date)    > 0 { return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago" }
        if hours(from: date)   > 0 { return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"   }
        if minutes(from: date) > 0 { return minutes(from: date) > 1 ? "\(minutes(from: date)) minutes ago" : "\(minutes(from: date)) minute ago" }
        if seconds(from: date) > 0 { return seconds(from: date) > 1 ? "\(seconds(from: date)) seconds ago" : "\(seconds(from: date)) second ago" }
        return ""
    }
    
    func offsetFrom(date : Date) -> DateComponents {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = Calendar.app.dateComponents(dayHourMinuteSecond, from: date, to: self);
        return difference
    }
}

//MARK: - Date for server
extension Date {
    
    private static let serverDateFormatter = DateFormatter(format: "MM/dd/yyyy")
    private static let serverTimeFormatter = DateFormatter(format: "hh:mm a")
    
    static func server(date dateString: String?, time timeString: String?) -> Date? {
        var date: Date? = nil;
        if let dateString = dateString {
            date = serverDateFormatter.date(from: dateString)
        }
        
        var time: Date? = nil;
        if let timeString = timeString {
            time = serverTimeFormatter.date(from: timeString)
        }
        
        if date != nil || time != nil {
            return join(date: date ?? Date(), time: time ?? Date());
        }
        
        return nil;
    }
    
    static func server(date dateString: String?, defaultTime: Date) -> Date? {
        guard let dateString = dateString,
            let date = serverDateFormatter.date(from: dateString) else {
                return nil;
        }
        
        return join(date: date, time: defaultTime);
    }
    
    static func server(time timeString: String?, defaultDate: Date) -> Date? {
        guard let timeString = timeString,
            let time = serverTimeFormatter.date(from: timeString) else {
                return nil;
        }
        
        return join(date: defaultDate, time: time);
    }
    
    static func server(date dateString: String?, for timeInDay: TimeInDay) -> Date? {
        guard let dateString = dateString,
            let date = serverDateFormatter.date(from: dateString) else {
                return nil;
        }
        
        return date.day(for: timeInDay);
    }
    
    func toServerDateTime() -> (date: String, time: String) {
        return (date: Date.serverDateFormatter.string(from: self),
                time: Date.serverTimeFormatter.string(from: self));
    }
    
}


