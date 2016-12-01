//
//  Todotask+CoreDataClass.swift
//  Todotask
//
//  Created by Tools Team India on 20/11/16.
//  Copyright © 2016 Schneider-Electric. All rights reserved.
//

import Foundation
import CoreData


public class Todotask: NSManagedObject {

 
    class func createTodotaskWithInfo(_ taskInfo:NSDictionary, inManagedObjectContext context:NSManagedObjectContext)
    {
        let createDate  = taskInfo.object(forKey: "createDate") as! NSDate
        
        if let _ =  fetchTaskFor(createDate, context: context)
        {
            print("Update")
            let _ = updateNewsWithInfo(taskInfo, inManagedObjectContext: context)
        }else
        {
            print("Insert")
            let _ = insertNewsWithnewsInfo(taskInfo, inManagedObjectContext: context)
        }
        
        
        
    }
 
    class func insertNewsWithnewsInfo(_ taskInfo:NSDictionary, inManagedObjectContext context:NSManagedObjectContext)-> Todotask{
        
        let taskObject = NSEntityDescription.insertNewObject(forEntityName: "Todotask", into: context) as! Todotask
        taskObject.createDate = taskInfo.object(forKey: "createDate") as? NSDate
        taskObject.notifyDate = taskInfo.object(forKey: "notifyDate") as? NSDate
        taskObject.taskDescription = taskInfo.object(forKey: "taskDescription") as? String
        taskObject.taskSubject =  taskInfo.object(forKey: "taskSubject") as? String
        return taskObject
    }
 
    class func updateNewsWithInfo(_ taskInfo:NSDictionary, inManagedObjectContext context:NSManagedObjectContext)-> Todotask{
        
        let createDate =  taskInfo.object(forKey: "createDate") as! NSDate
        let taskObject:Todotask  = fetchTaskFor(createDate, context: context)!
        taskObject.createDate = taskInfo.object(forKey: "createDate") as? NSDate
        taskObject.notifyDate = taskInfo.object(forKey: "notifyDate") as? NSDate
        taskObject.taskDescription = taskInfo.object(forKey: "taskDescription") as? String
        taskObject.taskSubject =  taskInfo.object(forKey: "taskSubject") as? String

        return taskObject
    }
    
    class func fetchTaskFor(_ createDate: NSDate , context:NSManagedObjectContext) -> Todotask? {
        
        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest<Todotask>(entityName: "Todotask")
        let predicate = NSPredicate(format: "createDate == %@",createDate)
        fetchRequest.predicate = predicate
        let fetchedResults: [AnyObject]?
        do {
            fetchedResults = try context.fetch(fetchRequest)
        } catch {
            fetchedResults = nil
        }
        if fetchedResults?.count != 0 {
            if let fetchedEvent: Todotask = fetchedResults![0] as? Todotask {
                return fetchedEvent
            }
        }
        return nil
    }

    class func deleteAllNewsRecords(inManagedObjectContext context:NSManagedObjectContext)
    {
        let fetchRequest = NSFetchRequest<Todotask>(entityName:"Todotask")
        let results:[Todotask]? = (try? context.fetch(fetchRequest))
        if let array = results{ //Check for nil and unwrap
            for newsItem in array as [Todotask]{
                context.delete(newsItem);
            }
        }
        do {
            try context.save()
        } catch _ {
        }
    }
    
    class func deleteNewsRecords(_ createDate:NSDate , inManagedObjectContext context:NSManagedObjectContext)
    {
        let fetchRequest = NSFetchRequest<Todotask>(entityName:"Todotask")
        let predicate = NSPredicate(format:"createDate = %@",createDate)
        fetchRequest.predicate = predicate
        let results:[Todotask]? = (try? context.fetch(fetchRequest))
        if let array = results{ //Check for nil and unwrap
            for newsItem in array as [Todotask]{
                context.delete(newsItem);
            }
        }
    }
    

    
}
