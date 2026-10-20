//
//  ImmersionApp.swift
//  Immersion
//
//  Created by forest on 2024/01/15.
//

import SwiftUI
import SwiftData

@main
struct ImmersionApp: App {
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Cat.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .modelContainer(previewContainer)
                .environmentObject(ShareData())
                .environmentObject(WatchConnectViewModel(selectedItemModel: SelectedItemModel()))
            
//            ContentView()
//                .environmentObject(ShareData())
//                .environmentObject(WatchConnectViewModel(selectedItemModel: SelectedItemModel()))
//                .modelContainer(for: [
//                    Category.self,
//                    Item.self, 
//                    Want.self, 
//                    Keyword.self,
//                    Step.self,
//                    Dislike.self,
//                    Phase.self
//                ])
             
        }
       
    }
}


// 追加
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        
//        // 起動時に1回だけやる処理をここに記述する
//        
//        return true
//    }
//}

