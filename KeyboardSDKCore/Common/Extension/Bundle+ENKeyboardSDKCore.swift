//
//  Bundle+ENKeyboardSDKCore.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/17.
//

import Foundation


extension Bundle {
    
    /// 프레임워크의  Bundle을 가져온다. 프레임워크내 추가된 리소스 파일들에 접근하기 위함.
    static let frameworkBundle:Bundle = {
        return Bundle.init(for: ENKeyboardSDKCore.self)
//        let bundle = Bundle.init(for: ENKeyboardSDKCore.self)
//
//        if let bundlePath = bundle.path(forResource: "KeyboardSDKCoreBundle", ofType: "bundle")  {
//            return Bundle.init(path: bundlePath) ?? bundle
//        }
//        if let bundlePath2 = bundle.path(forResource: "Frameworks/KeyboardSDKCore.framework/KeyboardSDKCoreBundle", ofType: "bundle")  {
//            return Bundle.init(path: bundlePath2) ?? bundle
//        }
//        if let bundlePath3 = Bundle.main.path(forResource: "KeyboardSDKCoreBundle", ofType: "bundle")  {
//            return Bundle.init(path: bundlePath3) ?? bundle
//        }
//
//        return bundle
    }()
    
    
}
