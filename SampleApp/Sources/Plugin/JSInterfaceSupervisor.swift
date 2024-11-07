//
//  JSInterfaceSupervisor.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

import WebKit

protocol JSInterfacePluggable {
    var action: String { get }
    func callAsAction(_ message: [String: Any], with: WKWebView)
}

/// Supervisor class responsible for loading and managing JS plugins.
class JSInterfaceSupervisor {
    var plugins = [String: JSInterfacePluggable]()

    init() {}
}

extension JSInterfaceSupervisor {
    /// register a single plugin into the supervisor.
    func registerPlugin(_ plugin: JSInterfacePluggable) {
        let action = plugin.action

        guard plugins[action] == nil else {
            assertionFailure("\(action) action already exists. Please check the plugin.")
            return
        }
        plugins[action] = plugin
    }
}

extension JSInterfaceSupervisor {
    /// Resolves an action and calls the corresponding plugin with a message and web view.
    func resolve(
        _ action: String,
        message: [String: Any],
        with webView: WKWebView)
    {
        let plugin = plugins[action]

        guard
            let plugin, plugin.action == action
        else {
            assertionFailure("Failed to resolve \(action): Action is not loaded. Please ensure the plugin is correctly loaded.")
            return
        }
        plugin.callAsAction(message, with: webView)
    }
}
