//
//  JSPluginScanner.swift
//  SampleApp
//
//  Created by minsOne on 11/8/24.
//

import Foundation

struct JSPluginScanner {
    var classes: (classesPtr: UnsafeMutablePointer<AnyClass>, numberOfClasses: Int)? {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        guard numberOfClasses > 0 else { return nil }
        
        let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses)
        let autoreleasingClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
        let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses))
        assert(numberOfClasses == count)
        
        return (classesPtr, numberOfClasses)
    }
    
    var keyList: [any JSPluginKeyType.Type] {
        guard let (classesPtr, numberOfClasses) = classes else { return [] }
        defer { classesPtr.deallocate() }
        
        let start = Date()
        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (keys, ptrIndex) = ([any JSPluginKeyType.Type](), [Int]())
        let superCls = JSPluginKey.self
        
        // MARK: Case 1 - class_getSuperclass
        
        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if class_getSuperclass(cls) == superCls,
               case let kcls as any JSPluginKeyType.Type = cls
            {
                ptrIndex.append(i)
                keys.append(kcls)
            }
        }
        
#if DEBUG
        print("""
      ┌───── \(Self.self) \(#function) ──────
      │ Duration : \((Date().timeIntervalSince(start) * 1000).rounded())ms
      │ numberOfClasses : \(numberOfClasses)
      │ JSPluginKey classPtr Index : \(ptrIndex)
      │ JSPluginKey List :
      │  - \(keys)
      └────────────────────────────────────────────────
      """)
#endif
        
        return keys
    }
    
    var scanJSPluginTypeList: [any JSPluginImplType.Type] {
        guard let (classesPtr, numberOfClasses) = classes else { return [] }
        defer { classesPtr.deallocate() }
        
        let start = Date()
        
        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (pluginTypeList, ptrIndex) = ([any JSPluginImplType.Type](), [Int]())
        let superCls = ScanJSPluginBase.self
        
        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if class_getSuperclass(cls) == superCls,
               case let kcls as any JSPluginImplType.Type = cls
            {
                ptrIndex.append(i)
                pluginTypeList.append(kcls)
            }
        }
        
#if DEBUG
        print("""
      ┌───── \(Self.self) \(#function) ─────────
      │ Duration : \((Date().timeIntervalSince(start) * 1000).rounded())ms
      │ numberOfClasses : \(numberOfClasses)
      │ ScanJSPlugin classPtr Index List : \(ptrIndex)
      │ ScanJSPlugin List :
      │  - \(pluginTypeList))
      └────────────────────────────────────────────────
      """)
#endif
        
        return pluginTypeList
    }
    
    var scanJSPluginList: [JSPlugin] {
        scanJSPluginTypeList
            .compactMap { ($0 as? any ScanJSPlugin.Type)?.init().plugin }
    }
}

class ScanJSPluginBase {
    required init() {}
}

typealias ScanJSPlugin = JSPluginImplType & ScanJSPluginBase

extension JSPluginImplType {
    var plugin: JSPlugin? {
        (self as? KeyType.Value)
            .map { instance in JSPlugin(KeyType.self) { instance } }
    }
}
