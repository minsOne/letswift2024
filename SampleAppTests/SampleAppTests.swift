//
//  SampleAppTests.swift
//  SampleAppTests
//
//  Created by minsOne on 11/5/24.
//

import Testing
import XCTest

@testable import SampleApp

struct PluginScanTests {
    @Test("JSPluginContainer에 등록된 PluginKey 검증")
    func scanKey() async throws {
        let keyList = JSPluginScanner().keyList
        
        if keyList.isEmpty {
            XCTFail("PluginKey가 없습니다. 확인해주세요.")
        } else {
            print("PluginKey 개수는 \(keyList.count)개 입니다.")
        }
        
        for case let key as JSPluginKey.Type in keyList {
            let plugin: any JSPluginImplType = JSPluginContainer.shared.resolve(for: key)
            #expect(plugin != nil)
        }
    }
}
