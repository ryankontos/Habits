//
//  Persistence.swift
//  Habits
//
//  Created by Ryan on 17/11/2023.
//

import Foundation
import CoreData

struct PersistenceController {
    
    #if targetEnvironment(simulator)
        static let shared = PersistenceController(inMemory: false)
    #else
        static let shared = PersistenceController(inMemory: false)
    #endif
 

    static let preview: PersistenceController = {
            let controller = PersistenceController(inMemory: true)
            // Add any additional setup for the preview container if necessary
            return controller
        }()

    let container: NSPersistentCloudKitContainer

    var oldStoreURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupport.appendingPathComponent("Habits.sqlite")
    }

    var sharedStoreURL: URL {
        let appGroupID = "group.ryankontos.habits" // Update with your App Group ID
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            fatalError("Shared file container could not be created.")
        }
        return containerURL.appendingPathComponent("Habits.sqlite")
    }

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Habits")
        let description = container.persistentStoreDescriptions.first!
        let originalCloudKitOptions = description.cloudKitContainerOptions

        if !FileManager.default.fileExists(atPath: oldStoreURL.path) {
            description.url = sharedStoreURL
        } else {
            description.cloudKitContainerOptions = nil
        }
        
      

        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        if inMemory {
            description.cloudKitContainerOptions = nil
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        if !inMemory {
            
            migrateStore(for: container, originalCloudKitOptions: originalCloudKitOptions)
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        
        if inMemory {
            generateDummyData(context: self.container.viewContext)
        }
        
    }

    func migrateStore(for container: NSPersistentCloudKitContainer, originalCloudKitOptions: NSPersistentCloudKitContainerOptions?) {
        let coordinator = container.persistentStoreCoordinator

        guard coordinator.persistentStore(for: oldStoreURL) != nil else {
            print("Migration not needed")
            return
        }

        do {
            try coordinator.replacePersistentStore(at: sharedStoreURL, withPersistentStoreFrom: oldStoreURL, type: .sqlite)
        } catch {
            fatalError("Something went wrong while migrating the store: \(error)")
        }

        do {
            try coordinator.destroyPersistentStore(at: oldStoreURL, type: .sqlite, options: nil)
        } catch {
            fatalError("Something went wrong while deleting the old store: \(error)")
        }

        // Clean up old store files
        NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: oldStoreURL.deletingLastPathComponent(), options: .forDeleting, error: nil, byAccessor: { url in
            try? FileManager.default.removeItem(at: oldStoreURL)
            try? FileManager.default.removeItem(at: oldStoreURL.deletingLastPathComponent().appendingPathComponent("Habits.sqlite-shm"))
            try? FileManager.default.removeItem(at: oldStoreURL.deletingLastPathComponent().appendingPathComponent("Habits.sqlite-wal"))
            try? FileManager.default.removeItem(at: oldStoreURL.deletingLastPathComponent().appendingPathComponent("ckAssetFiles"))
        })

        // Reload store with CloudKit options
        if let persistentStore = container.persistentStoreCoordinator.persistentStores.first {
            do {
                try container.persistentStoreCoordinator.remove(persistentStore)
            } catch {
                print("Failed to unload persistent store: \(error)")
            }
        }

        let storeDescription = container.persistentStoreDescriptions.first!
        storeDescription.url = sharedStoreURL
        storeDescription.cloudKitContainerOptions = originalCloudKitOptions

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        print("Migration completed")
    }
    

    func generateDummyData(context: NSManagedObjectContext) {
        let habitDetails = [
            ("Shower", "drop.fill"),
            ("Take Medication", "pills.fill"),
            ("Haircut", "scissors"),
            ("Cut Nails", "nailpolish.fill"),
            ("Read", "book.fill"),
            ("Exercise", "figure.walk"),
            ("Meditate", "figure.stand"),
            ("Study", "books.vertical.fill"),
            ("Drink Water", "waveform.path.ecg"),
            ("Walk Dog", "pawprint.fill"),
            ("Cook", "stove.fill"),
            ("Clean", "vacuum.fill"),
            ("Sleep", "bed.double.fill"),
            ("Listen to Music", "music.note"),
            ("Practice Instrument", "guitar.fill"),
            ("Write Journal", "note.text"),
            ("Grocery Shopping", "cart.fill"),
            ("Watch TV", "tv.fill"),
            ("Play Games", "gamecontroller.fill"),
            ("Work", "briefcase.fill"),
            ("Attend Course", "graduationcap.fill"),
            ("Visit Doctor", "stethoscope"),
            ("Call Family", "phone.fill"),
            ("Laundry", "tshirt.fill"),
            ("Yoga", "figure.roll")
        ]
        
        for (name, _) in habitDetails {
            let hasDuration = Bool.random()
            let habit = Habit(context: context)
            habit.name = name
            habit.symbolName = "shower.fill"
            habit.color = ColorOptionsList.colors.randomElement()!
            habit.hasDuration = hasDuration
            
            let numberOfEvents = Int.random(in: 1...5)
            for _ in 0..<numberOfEvents {
                let startDate = Date().addingTimeInterval(TimeInterval.random(in: (-604800)...(-86400)))
                
                let event = Event(context: context)
                event.startDate = startDate
                if hasDuration {
                    let endDate = startDate.addingTimeInterval(TimeInterval.random(in: (60)...(3000)))
                    event.endDate = endDate
                    event.habitHasDuration = true
                }
                habit.addToEvents(event)
            }
        }
        
        do {
            try context.save()
        } catch {
            // Handle the error appropriately
            print("Could not save context: \(error.localizedDescription)")
        }
    }


}


public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}


