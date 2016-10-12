//
//  NSDate+Extension.swift
//  Tasty
//
//  Created by Vitaliy Kuzmenko on 17/10/14.
//  http://github.com/vitkuzmenko
//  Copyright (c) 2014 Vitaliy Kuz'menko. All rights reserved.
//

import Foundation

func NSDateTimeAgoLocalizedStrings(key: String) -> String {
    let resourcePath: String?

    if let frameworkBundle = Bundle(identifier: "com.kevinlawler.NSDateTimeAgo") {
        // Load from Framework
        resourcePath = frameworkBundle.resourcePath
    } else {
        // Load from Main Bundle
        resourcePath = Bundle.main.resourcePath
    }

    if resourcePath == nil {
        return ""
    }

    let path = NSURL(fileURLWithPath: resourcePath!).appendingPathComponent("NSDateTimeAgo.bundle")
    guard let bundle = Bundle(url: path!) else {
        return ""
    }
    
    return NSLocalizedString(key, tableName: "NSDateTimeAgo", bundle: bundle, comment: "")
}
extension Date {
    
    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: d)
    }
}
extension Date {
    
    // shows 1 or two letter abbreviation for units.
    // does not include 'ago' text ... just {value}{unit-abbreviation}
    // does not include interim summary options such as 'Just now'
    public var timeAgoSimple: String {
        let components = self.dateComponents()

        if components.year! > 0 {
            return stringFromFormat(format: "%%d%@yr", withValue: components.year!)
        }

        if components.month! > 0 {
            return stringFromFormat(format: "%%d%@mo", withValue: components.month!)
        }

        // TODO: localize for other calanders
        if components.day! >= 7 {
            let value = components.day!/7
            return stringFromFormat(format: "%%d%@w", withValue: value)
        }

        if components.day! > 0 {
            return stringFromFormat(format: "%%d%@d", withValue: components.day!)
        }

        if components.hour! > 0 {
            return stringFromFormat(format: "%%d%@h", withValue: components.hour!)
        }

        if components.minute! > 0 {
            return stringFromFormat(format: "%%d%@m", withValue: components.minute!)
        }

        if components.second! > 0 {
            return stringFromFormat(format: "%%d%@s", withValue: components.second! )
        }

        return ""
    }

    public var timeAgo: String {
        let components = self.dateComponents()

        if components.year! > 0 {
            if components.year! < 2 {
                return NSDateTimeAgoLocalizedStrings(key: "Hace un año")
            } else {
                return stringFromFormat(format: "Hace %%d %@años", withValue: components.year!)
            }
        }

        if components.month! > 0 {
            if components.month! < 2 {
                return NSDateTimeAgoLocalizedStrings(key: "Hace un mes")
            } else {
                return stringFromFormat(format: "Hace %%d %@meses", withValue: components.month!)
            }
        }

        // TODO: localize for other calanders
        if components.day! >= 7 {
            let week = components.day!/7
            if week < 2 {
                return NSDateTimeAgoLocalizedStrings(key: "Hace una semana")
            } else {
                return stringFromFormat(format: "Hace %%d %@semanas", withValue: week)
            }
        }

        if components.day! > 0 {
            if components.day! < 2 {
                return NSDateTimeAgoLocalizedStrings(key: "Ayer")
            } else  {
                return stringFromFormat(format: "Hace %%d %@dias", withValue: components.day!)
            }
        }

        if components.hour! > 0 {
            if components.hour! < 2 {
                return NSDateTimeAgoLocalizedStrings(key: "Hace una hora")
            } else  {
                return stringFromFormat(format: "Hace %%d %@horas", withValue: components.hour!)
            }
        }

        if components.minute! > 0 {
            if components.minute! < 2 {
                return NSDateTimeAgoLocalizedStrings(key: "Hace un minuto")
            } else {
                return stringFromFormat(format: "Hace %%d %@minutos", withValue: components.minute!)
            }
        }

        if components.second! > 0 {
            if components.second! < 5 {
                return NSDateTimeAgoLocalizedStrings(key: "Ahora")
            } else {
                return stringFromFormat(format: "Hace %%d %@segundos", withValue: components.second!)
            }
        }
        
        return ""
    }

    private func dateComponents() -> DateComponents {
        let calendar = Calendar.current
//        calendar.dateComponents(<#T##components: Set<Calendar.Component>##Set<Calendar.Component>#>, from: <#T##Date#>)
//        calendar.dateComponents(Set<Calendar.Component>, from: Date, to: Date)
        return calendar.dateComponents(Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year]), from: self as Date, to: Date())
    }

    private func stringFromFormat(format: String, withValue value: Int) -> String {
        let localeFormat = String(format: format, getLocaleFormatUnderscoresWithValue(value: Double(value)))
        return String(format: NSDateTimeAgoLocalizedStrings(key: localeFormat), value)
    }
    
    private func getLocaleFormatUnderscoresWithValue(value: Double) -> String {
        guard let localeCode = Locale.preferredLanguages.first else {
            return ""
        }
        
        // Russian (ru) and Ukrainian (uk)
        if localeCode == "ru" || localeCode == "uk" {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10

            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }

            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }

            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        return ""
    }
    
}

