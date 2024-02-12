//
//  AppDelegate.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        return true
    }
    
 
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TimeSheetDaysValueTransformer.register()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    //MARK: - CoreData
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "TrackerCoreDataModel")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(CoreDataErrors.persistentStoreError(error)), \(error.userInfo)")
                }
            })
            return container
        }()
    
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
//                fatalError("Не удалось сохранить контекст CoreData: \(CoreDataErrors.saveError(error))")
               throw CoreDataErrors.saveError(NSError(domain: "CoreData", code: 0, userInfo: nil))
            }
        }
    }
}

