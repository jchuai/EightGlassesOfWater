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
    
    var counters: [Int16] = [0, 0, 0, 0, 0, 0, 0]
    
    var todayCounter: Int16 {
        return counters[todayIndex]
    }
        
    private let entityName = "FloDataItem"
    private var today: NSDate
    private var todayIndex: Int
    private var monday: NSDate
    private var nextMonday: NSDate
    
    init() {
        today = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(timeIntervalSinceNow: 0), options: [])!
        let components = calendar.components([.Year, .Month, .Weekday, .Day], fromDate: today)
        todayIndex = components.weekday - 2
        
        components.day -= (components.weekday - 2)
        monday = calendar.dateFromComponents(components)!
        
        components.day += 7
        nextMonday = calendar.dateFromComponents(components)!
    }
    
    func loadDataItems() {
        let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", monday, nextMonday)
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        do {
            let list = try managedContext.executeFetchRequest(request) as! [FloDataItem]
            
            for item in list {
                let component = calendar.components([.Weekday], fromDate: item.date)
                let index = component.weekday - 2
                counters[index] = item.count
            }
            
            delegate?.reloadGraphView()

        } catch {
            assertionFailure("Failed to fetch DataItems: \(error)")
        }
    }
    
    func save(count: Int16) {
        
        counters[todayIndex] = count
        
        let item = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! FloDataItem
        item.date = today
        item.count = count
        
        do {
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