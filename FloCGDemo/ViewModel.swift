//
//  ViewModel.swift
//  FloCGDemo
//
//  Created by Junna on 2/29/16.
//  Copyright © 2016 Junna. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ViewModel {
    weak var delegate: ViewController?
    
    var counters: [[Int16]] = []
    
    var todayCounter: Int16 {
        return counters.last?[todayIndex] ?? 0
    }
        
    private let entityName = "FloDataItem"
    private var today: NSDate
    private var todayIndex: Int
    
    init() {
        today = calendar.startOfDayForDate(NSDate()).localDate()
        todayIndex = calendar.component(.Weekday, fromDate: today) - 2
    }
    
    func loadDataItems() {
        counters = loadAllDataItems()
        if counters.isEmpty {
            counters = [Array<Int16>(count: 7, repeatedValue: 0)]
        }
        delegate?.reloadGraphView()
    }
    
    private func loadAllDataItems() -> [[Int16]] {
        let items = loadDataItems(NSDate(timeIntervalSince1970: 0), endDay: today)
        var list = [[Int16]]()
        var tempList = Array<Int16>(count: 7, repeatedValue: 0)
        for index in 0 ..< items.count {
            let item = items[index]
            let weekdayIndex = calendar.component(.Weekday, fromDate: item.date) - 2
            tempList.insert(item.count, atIndex: weekdayIndex)
            if weekdayIndex == 6 || index == items.count - 1 {
                list.append(tempList)
                tempList = Array<Int16>(count: 7, repeatedValue: 0)
            }
        }
        return list
    }
    
    private func loadDataItems(startDay: NSDate, endDay: NSDate) -> [FloDataItem] {
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDay, endDay)
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        
        do {
            
            let list = try managedContext.executeFetchRequest(request) as! [FloDataItem]
            return list
            
        } catch {
            assertionFailure("Failed to fetch DataItems: \(error)")
        }
        return []
    }
    
    func save(count: Int16) {
        
        counters[counters.count - 1][todayIndex] = count
        
        let request = NSFetchRequest(entityName: entityName)
        let predicate = NSPredicate(format: "date == %@", today)
        request.predicate = predicate
        
        do {
            
            let list = try managedContext.executeFetchRequest(request) as! [FloDataItem]
            
            if list.isEmpty {
                let item = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! FloDataItem
                item.date = today
                item.count = count
            } else {
                let item = list[0]
                item.count = count
            }
            
            try managedContext.save()
            
        } catch {
            assertionFailure("Failed to save dataItem: \(error)")
        }
        
        delegate?.reloadGraphView()
    }
    
    private let calendar = NSCalendar.currentCalendar()
    
    lazy var managedContext: NSManagedObjectContext = {
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        return del.managedObjectContext
    }()
    
    lazy var dataItemEntity: NSEntityDescription? = {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: self.managedContext)
    }()
}

@objc(FloDataItem)
class FloDataItem : NSManagedObject {
    @NSManaged var date : NSDate
    @NSManaged var count: Int16
}