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
    private let yandexMetrica = YandexMetricaService.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default Configuration",
                                                      sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        yandexMetrica.sendReport(about: AnalyticsModel.Events.close, and: nil, on: AnalyticsModel.Screens.appDelegate)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        yandexMetrica.sendReport(about: AnalyticsModel.Events.open, and: nil, on: AnalyticsModel.Screens.appDelegate)
    }
}

