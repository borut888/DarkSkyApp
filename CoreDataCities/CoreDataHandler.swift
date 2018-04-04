//
//  CoreDataHandler.swift
//  DarkSkyApp
//
//  Created by Borut on 02/04/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    class func saveObject(cityName: String, lat: String, long: String)  {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "CitiesData", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        manageObject.setValue(cityName, forKey: "cityName")
        manageObject.setValue(lat, forKey: "latitude")
        manageObject.setValue(long, forKey: "longitude")
    }
    class func fetchObject() -> [CitiesData] {
        let context = getContext()
        var city:[CitiesData]? = nil
        do {
            city = try context.fetch(CitiesData.fetchRequest())
            return city!
        } catch {
            return city!
        }
    }
    class func deleteObject(city: CitiesData) {
        let context = getContext()
        context.delete(city)
    }
}
