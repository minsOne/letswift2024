//
//  ViewController.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

import UIKit
import WebKit

final class PaymentWebViewController: UIViewController, WKScriptMessageHandler {
    var pluginKeyList: [JSPluginKey.Type] {
        [
            PaymentPluginKey.self,
            LoadingPluginKey.self,
        ]
    }
    
    private let supervisor = JSInterfaceSupervisor()
    private let messageHandler = "actionHandler"
    private var webView: WKWebView?
}

extension PaymentWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerPlugin()
        initWebView()
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

extension PaymentWebViewController {
    func initWebView() {
        // WKUserContentController 인스턴스 생성
        let userContentController = WKUserContentController()
        userContentController.add(self, name: messageHandler) // 메시지 핸들러 등록
        
        // WKWebView에 WKUserContentController 설정
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        // WKWebView 인스턴스 생성
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        self.webView = webView
        
        // WKWebView를 뷰에 추가
        view.addSubview(webView)
        
        // HTML 파일 로드
        _ = Bundle.main.path(forResource: "index", ofType: "html")
            .map { URL(fileURLWithPath: $0) }
            .map { webView.loadFileURL($0, allowingReadAccessTo: $0) }
    }

    // WKScriptMessageHandler 프로토콜 메서드 구현
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard
            let webView,
            message.name == messageHandler,
            let messageBody = message.body as? [String: Any],
            let action = messageBody["action"] as? String
        else { return }
        
        supervisor.resolve(action, message: messageBody, with: webView)
    }
}
