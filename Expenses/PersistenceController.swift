//
//  PersistenceController.swift
//  Expenses
//
//  Created by mahesh lad on 08/05/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    
    init() {
        container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
    }
    
    var managedObjectModel: NSManagedObjectModel? {
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        
        return mom
    }
    
    static var preview: PersistenceController = {
            let controller = PersistenceController()
            let context = controller.container.viewContext
            for _ in 0..<10 {
                let newItem = Expense(context: context)
                newItem.name = "Test Expense"
                newItem.amount = Double.random(in: 1...100)
                newItem.date = Date()
            }
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            return controller
        }()
}
