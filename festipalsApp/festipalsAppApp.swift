//
//  festipalsAppApp.swift
//  festipalsApp
//
//  Created by sierra jordan on 2/9/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct festipalsAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var eventVM = NewEventViewModel()
    
    var body: some Scene {
        WindowGroup {
            AllEventsView()
                .environmentObject(eventVM)
        }
    }
}
