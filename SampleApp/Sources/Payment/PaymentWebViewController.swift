//
//  ViewController.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

import UIKit

final class PaymentWebViewController: UIViewController {
    var pluginKeyList: [JSPluginKey.Type] {
        [
            PaymentPluginKey.self,
            LoadingPluginKey.self,
        ]
    }
    
    let supervisor = JSInterfaceSupervisor()
}

extension PaymentWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerPlugin()
    }
    
    func registerPlugin() {
        for key in pluginKeyList {
            let container = JSPluginContainer.shared
            let plugin = handlerPlugin(container.resolve(for: key))
            supervisor.registerPlugin(plugin)
        }
    }
}

private extension PaymentWebViewController {
    func handlerPlugin(
        _ plugin: any JSPluginImplType
    )
    -> any JSPluginImplType
    {
        switch plugin {
        case let plugin as PaymentPluggable:
            plugin.set { info, webView in
                print(info, webView)
            }
            
        case let plugin as LoadingPluggable:
            plugin.set { info, webView in
                print(info, webView)
            }
            
        default:
            break
        }
        
        return plugin
    }
}
