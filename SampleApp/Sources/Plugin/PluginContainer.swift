//
//  PluginContainer.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

protocol JSPluginKeyType: AnyObject {
    associatedtype Value
    
    static var value: Value { get }
}

extension JSPluginKeyType {
    static var value: Value {
        JSPluginContainer.shared.resolve(for: Self.self)
    }
}

protocol JSPluginImplType:
    AnyObject,
    JSInterfacePluggable
{
    associatedtype KeyType: JSPluginKeyType
}

class JSPluginKey {}

class JSPluginBase {
    init() {}
}

struct JSPlugin {
    let key: String
    let closure: () -> Any
    
    init<T: JSPluginKeyType, U>(
        _ keyType: T.Type,
        _ closure: @escaping () -> U
    ) where T.Value == U {
        key = "\(keyType)"
        self.closure = closure
    }
    
    init<T: ScanJSPlugin>(_ pluginType: T.Type) {
        key = "\(pluginType.KeyType.self)"
        closure = {
            pluginType.init()
        }
    }
}

class JSPluginContainer {
    static let shared = JSPluginContainer()
    var plugins: [String: JSPlugin] = [:]
    
    init() {}
    
    func register(plugin: JSPlugin) {
        plugins["\(plugin.key)"] = plugin
    }
    
    func register(plugins list: [JSPlugin]) {
        for item in list {
            plugins["\(item.key)"] = item
        }
    }
    
    func resolve<T>(for type: AnyObject.Type) -> T {
        return plugins["\(type)"]?.closure() as! T
    }
}
