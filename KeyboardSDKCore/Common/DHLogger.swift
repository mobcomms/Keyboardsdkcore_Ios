//
//  DHLogger.swift
//  DHCommonUtil
//
//  Created by DHLee on 2021/04/27.
//

import Foundation
import OSLog


@available(iOS 14, *)
extension Logger {
    private static let process: String = Bundle.main.bundleIdentifier ?? ""
    
    
    /// Device Console을 통해 출력될 메시지 카테고리 설정
    static let dhLogger:Logger = Logger.init(subsystem: process, category: "DHLogger")
}



/// 프로젝트 디비깅 로그 출력 관리용 클래스
public class DHLogger {
    
    static let showLog:Bool = ENKeyboardSDKCoreInfo.showLog
    static let showTime:Bool = ENKeyboardSDKCoreInfo.showTime
    static let logName:String = "ENKeyboard"
    
    
    /// 로그 출력 시간 표시를 위한 날짜 포맷
    public static let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        formatter.locale = Locale.current
        return formatter
    }()
    
    
    
    /// 로그 메세지를 출력한다.
    /// - Parameter message: 출력할 로그 메세지
    public static func log(_ message:Any) {
        if(showLog) {
            if(showTime) {
                print("[\(dateFormatter.string(from: Date()))][\(logName)] \(message)")
            }
            else {
                print("[\(logName)] \(message)")
            }
        }
    }
    public static func simplelog(_ message:Any) {
        if(showLog) {
            if(showTime) {
                print("[\(dateFormatter.string(from: Date()))] \(message)")
            }
            else {
                print(" \(message)")
            }
        }
    }

    
    /// 로그 메세지를 출력한다.
    /// - Parameters:
    ///   - format: 출력할 로그 메세지 포맷
    ///   - arguments: 로그 메세지 포멧으로 설정된 파라메터들에 대응하는 값
    public static func log(format: String, _ arguments: CVarArg...) {
        log(String.init(format:format, arguments:arguments))
    }
    
    
    
    /// 시스템 로그를 출력한다.
    /// - Parameter message: 출력할 로그 메세지
    public static func systemInfoLog(message: String) {
        if #available(iOS 14, *) {
            Logger.dhLogger.info("\(message)")
        }
        else {
            NSLog(message)
        }
    }
}
