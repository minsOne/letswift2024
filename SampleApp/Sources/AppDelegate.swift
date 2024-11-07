//
//  AppDelegate.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  {
    let plugins = JSPluginScanner().scanJSPluginList
    
    let container = JSPluginContainer.shared
    container.register(plugins: plugins)
    
    print("Container에 등록된 Plugin: \n\(container.plugins)")
    
    return true
  }
}
