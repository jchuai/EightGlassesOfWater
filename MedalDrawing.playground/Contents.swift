//: Playground - noun: a place where people can play

import UIKit
import Foundation

let calendar = NSCalendar.currentCalendar()
var today = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(timeIntervalSinceNow: 0), options: [])!

let components = calendar.components([.Year, .Month, .Weekday, .Day], fromDate: today)
components.day -= (components.weekday - 2)
let monday = calendar.dateFromComponents(components)

components.day += 7
let nextMonday = calendar.dateFromComponents(components)