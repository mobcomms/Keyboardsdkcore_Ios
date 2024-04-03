//
//  ENKeyboardThemeManager.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/11.
//

import Foundation
import UIKit



/// 테마 파일 타입. keyboard 는 공통 항목이며, custom은 각 클라이언트별 커스텀된 ui에 대응하는 항목이 된다.
public enum ENKeyboardThemeType: String {
    case keyboard = "keyboard"
    case custom = "custom"
}




/// 테마 파일 정보를 담는 객체
public struct ENKeyboardThemeFileInfo {
    
    /// 테마 이름
    public var name:String
    
    
    /// 해당 테마의 공통 항목을 다운로드 받을 수 있는 주소
    public var keyboardUrl: String?
    
    /// 클라이언트별 별도로 커스텀된 ui에 대응하는 리소스 파일을 다운로드 받을 수 있는 주소
    public var customUrl: String?
    
    
    /// 기본 테마 파일을 로드한다. (임시)
    /// - Returns: 기본 테마 파일 정보
    static public func getDefaultTheme() -> ENKeyboardThemeFileInfo{
        return ENKeyboardThemeFileInfo(name: "default",
                                       keyboardUrl: "https://okcashbag.cashkeyboard.co.kr/images/theme/common/2/common_theme_118.zip",
                                       customUrl: "https://okcashbag.cashkeyboard.co.kr/images/theme/OCB/2/custom_theme_118.zip")
    }
}



public class ENKeyboardThemeManager {
    
    public typealias ENKeyboardThemeManagerHandler = (_ theme: ENKeyboardTheme) -> Void
    
    
    public static let shared:ENKeyboardThemeManager = ENKeyboardThemeManager()
    
    public var loadedTheme: ENKeyboardTheme?
    
    
    
    /// 현재 사용중인 테마 정보를 가져온다.
    /// - Returns: 현재 사용중인 테마 정보를 담고 있는 ENKeyboardThemeModel 객체.  선택된것이 없거나 오류 발생시 nil을 반환한다.
    public func getCurrentTheme() -> ENKeyboardThemeModel {
        return UserDefaults.enKeyboardGroupStandard?.getSelectedThemeInfo() ?? ENKeyboardThemeModel.defaultTheme()
    }
    
    
    /// 선택된 테마 정보를 저장한다.
    /// - Parameter theme: 현재 선택된 테마 객체
    public func saveSelectedThemeInfo(theme: ENKeyboardThemeModel) {
        UserDefaults.enKeyboardGroupStandard?.setSelectedThemeInfo(theme: theme)
    }
    
    
    /// 테마 파일을 로드 한다.
    /// - Parameters:
    ///   - theme: 테파 인포 객체
    ///   - handler: 테마 파일의 로딩이 완료된 경우 동작할 클로저
    public func loadTheme(theme: ENKeyboardThemeFileInfo, _ handler: ENKeyboardThemeManagerHandler?) {
        if UserDefaults.standard.isUsePhotoTheme() {
            loadPhotoTheme(theme: theme, handler)
        }
        else {
            loadBasicTheme(theme: theme, handler)
        }
    }
    
    
    
    private func loadPhotoTheme(theme: ENKeyboardThemeFileInfo, _ handler: ENKeyboardThemeManagerHandler?) {
        let photoTheme = UserDefaults.standard.loadPhotoThemeInfo()
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.loadedTheme?.clear()
            self.loadedTheme = photoTheme
            
            self.loadedTheme?.isPhotoTheme = true
            
            var backgroundImage = self.getPhotoThemeBackgroundImage(theme: photoTheme)
            self.loadedTheme?.backgroundImage = backgroundImage
            
            self.loadedTheme?.loadPhotoThemeIcons()
            
            backgroundImage = nil
            
            
            DispatchQueue.main.async {
                handler?(self.loadedTheme!)
            }
        }
    }
    
    
    private func loadBasicTheme(theme: ENKeyboardThemeFileInfo, _ handler: ENKeyboardThemeManagerHandler?) {
        guard theme.name == "default" || alreadyDownlaoded(theme: theme) else {
            self.download(theme: theme) { [weak self] success in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.loadBasicTheme(theme: theme, handler)
                }
            }
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let isDefault = (theme.name == "default")
            let folder = self.themeFolder(name: theme.name, type: .keyboard)
            
            self.loadedTheme?.clear()
            self.loadedTheme = ENKeyboardTheme()
            
            var backgroundImage = UIImage.init(contentsOfFile: "\(folder.path)/aikbd_img_keyboard_bg_origin.png") ?? UIImage.init(named: "aikbd_img_keyboard_bg_origin", in: Bundle.frameworkBundle, compatibleWith: nil)
            var keyNormalBackgroundImage = UIImage.init(contentsOfFile: "\(folder.path)/aikbd_btn_keyboard_key_off.9.png") ?? UIImage.init(named: "aikbd_btn_keyboard_key_off.9", in: Bundle.frameworkBundle, compatibleWith: nil)
            var keyPressedBackgroundImage = UIImage.init(contentsOfFile: "\(folder.path)/aikbd_btn_keyboard_key_on.9.png") ?? UIImage.init(named: "aikbd_btn_keyboard_key_on.9", in: Bundle.frameworkBundle, compatibleWith: nil)
            var specialKeyNormalBackgroundImage = UIImage.init(contentsOfFile: "\(folder.path)/aikbd_btn_keyboard_specialkey_off.9.png") ?? UIImage.init(named: "aikbd_btn_keyboard_specialkey_off.9", in: Bundle.frameworkBundle, compatibleWith: nil)
            var specialKeyPressedBackgroundImage = UIImage.init(contentsOfFile: "\(folder.path)/aikbd_btn_keyboard_specialkey_on.9.png") ?? UIImage.init(named: "aikbd_btn_keyboard_specialkey_on.9", in: Bundle.frameworkBundle, compatibleWith: nil)
            
            self.loadedTheme?.backgroundImage = backgroundImage
            
            self.loadedTheme?.keyNormalBackgroundImage = ENNinePatchImageFactory.createResizableNinePatchImage(keyNormalBackgroundImage, resize: 0.30)
            self.loadedTheme?.keyPressedBackgroundImage = ENNinePatchImageFactory.createResizableNinePatchImage(keyPressedBackgroundImage, resize: 0.30)
            self.loadedTheme?.specialKeyNormalBackgroundImage = ENNinePatchImageFactory.createResizableNinePatchImage(specialKeyNormalBackgroundImage, resize: 0.30)
            self.loadedTheme?.specialKeyPressedBackgroundImage = ENNinePatchImageFactory.createResizableNinePatchImage(specialKeyPressedBackgroundImage, resize: 0.30)
            
            var shiftNormalImage: UIImage? = nil
            var shiftPressedImage: UIImage? = nil
            var capslockImage: UIImage? = nil
            var spaceImage: UIImage? = nil
            var specialImage: UIImage? = nil
            var enterImage: UIImage? = nil
            var deleteImage: UIImage? = nil
            var globalImage: UIImage? = nil
            var previewImage: UIImage? = nil
            var emojiIcon: UIImage? = nil
            
            //테마에 따라 없을 수도 있는 이미지들 --------------------------------------------------------------------------------------------------------------------------------------------
            do {
                let shiftPress = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_shift_1.png"))
                shiftPressedImage = UIImage.init(data: shiftPress, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_shift_1", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            catch {
                shiftPressedImage = UIImage.init(named: "aikbd_btn_keyboard_shift", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            
            do {
                let capslock = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_shift_2.png"))
                capslockImage = UIImage.init(data: capslock, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_shift_2", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            catch {
                capslockImage = UIImage.init(named: "aikbd_btn_keyboard_shift", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            
            do {
                let preview = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_preview.png"))
                previewImage = UIImage.init(data: preview, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_preview", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            catch {
                previewImage = UIImage.init(named: "aikbd_btn_keyboard_preview", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            //여기까지 --------------------------------------------------------------------------------------------------------------------------------------------
            
            
            //아래는 무조건 있어야 하는 이미지들 -------------------------------------------------------------------------------------------------------------------------
            do {
                let shiftNormal = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_shift.png"))
                let space = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_space.png"))
                let special = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_sign.png"))
                let enter = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_enter.png"))
                let delete = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_delete.png"))
                let global = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_text.png"))
                let emoji = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_keyboard_icon.png"))
                
                shiftNormalImage = UIImage.init(data: shiftNormal, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_shift", in: Bundle.frameworkBundle, compatibleWith: nil)
                spaceImage = UIImage.init(data: space, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_space", in: Bundle.frameworkBundle, compatibleWith: nil)
                specialImage = UIImage.init(data: special, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_sign", in: Bundle.frameworkBundle, compatibleWith: nil)
                enterImage = UIImage.init(data: enter, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_enter", in: Bundle.frameworkBundle, compatibleWith: nil)
                deleteImage = UIImage.init(data: delete, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_delete", in: Bundle.frameworkBundle, compatibleWith: nil)
                globalImage = UIImage.init(data: global, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_text", in: Bundle.frameworkBundle, compatibleWith: nil)
                emojiIcon = UIImage.init(data: emoji, scale: 3.0) ?? UIImage.init(named: "aikbd_btn_keyboard_icon", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            catch {
                shiftNormalImage = UIImage.init(named: "aikbd_btn_keyboard_shift", in: Bundle.frameworkBundle, compatibleWith: nil)
                spaceImage = UIImage.init(named: "aikbd_btn_keyboard_space", in: Bundle.frameworkBundle, compatibleWith: nil)
                specialImage = UIImage.init(named: "aikbd_btn_keyboard_sign", in: Bundle.frameworkBundle, compatibleWith: nil)
                enterImage = UIImage.init(named: "aikbd_btn_keyboard_enter", in: Bundle.frameworkBundle, compatibleWith: nil)
                deleteImage = UIImage.init(named: "aikbd_btn_keyboard_delete", in: Bundle.frameworkBundle, compatibleWith: nil)
                globalImage = UIImage.init(named: "aikbd_btn_keyboard_text", in: Bundle.frameworkBundle, compatibleWith: nil)
                emojiIcon = UIImage.init(named: "aikbd_btn_keyboard_icon", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            
            
            self.loadedTheme?.keyShiftNormalImage = shiftNormalImage
            self.loadedTheme?.keyShiftPressedImage = shiftPressedImage
            self.loadedTheme?.keyCapslockImage = capslockImage
            self.loadedTheme?.keySpaceImage = spaceImage
            self.loadedTheme?.keySpecialImage = specialImage
            self.loadedTheme?.keyEnterImage = enterImage
            self.loadedTheme?.keyDeleteImage = deleteImage
            self.loadedTheme?.keyGlobalImage = globalImage
            self.loadedTheme?.keyEmojiIcon = emojiIcon
            self.loadedTheme?.previewBackgroundImage = previewImage
            
            do {
                var colorJsonData: Data? = nil
                if isDefault {
                    colorJsonData = try Data.init(contentsOf: URL.init(fileURLWithPath: Bundle.frameworkBundle.path(forResource: "theme_color", ofType: "txt") ?? ""))
                }
                else {
                    colorJsonData = try Data.init(contentsOf: folder.appendingPathComponent("theme_color.txt"))
                }
                
                if let colorJsonData = colorJsonData {
                    let colorJSON = String.init(data: colorJsonData, encoding: .utf8)?.dictionary
                    self.loadedTheme?.themeColors = ENThemeColors.init(json: colorJSON, with: globalImage)
                }
            }
            catch {}
            
            
            backgroundImage = nil
            keyNormalBackgroundImage = nil
            keyPressedBackgroundImage = nil
            specialKeyNormalBackgroundImage = nil
            specialKeyPressedBackgroundImage = nil
            
            shiftNormalImage = nil
            shiftPressedImage = nil
            capslockImage = nil
            spaceImage = nil
            specialImage = nil
            enterImage = nil
            deleteImage = nil
            globalImage = nil
            previewImage = nil
            emojiIcon = nil
            
            
            
            DispatchQueue.main.async {
                handler?(self.loadedTheme!)
            }
        }
    }
    
}



//MARK:- 테마 파일 다운로드 관련

extension ENKeyboardThemeManager {
    
    
    /// 테마 파일을 다운로드
    /// - Parameters:
    ///   - theme: 다운로드할 테마파일의 정보가 들어 있는 객체
    ///   - complete: 테마 파일의 다운로드가 완료된 경우 실행될 클로저
    /// - Returns: 테마파일 다운로드 완료 된 경우 클로저를 통해 true를, 실패한 경우 false를 보내준다.
    public func download(theme: ENKeyboardThemeFileInfo, complete: @escaping (_ success:Bool) -> ()) {
        var loadedKeyboardTheme: Bool = true
        var loadedCustomTheme: Bool = true
        
        var resultLoadedKeyboardTheme: Bool = true
        var resultLCustomTheme: Bool = true
        
        
        if let keyboardUrl = theme.keyboardUrl {
            loadedKeyboardTheme = false
            
            if theme.name == "default" {
                self.unzipTheme(name: theme.name, filePath: keyboardUrl, type: .keyboard) { result in
                    loadedKeyboardTheme = true
                    resultLoadedKeyboardTheme = result
                }
            }
            else {
                self.downloadThemeFile(name: theme.name, url: keyboardUrl, type: .keyboard) { result in
                    loadedKeyboardTheme = true
                    resultLoadedKeyboardTheme = result
                }
            }
            
            
        }
        
        if let customUrl = theme.customUrl {
            loadedCustomTheme = false
            
            if theme.name == "default" {
                self.unzipTheme(name: theme.name, filePath: customUrl, type: .custom) { result in
                    loadedCustomTheme = true
                    resultLCustomTheme = result
                }
            }
            else {
                self.downloadThemeFile(name: theme.name, url: customUrl, type: .custom) { result in
                    loadedCustomTheme = true
                    resultLCustomTheme = result
                }
            }
            
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if loadedKeyboardTheme && loadedCustomTheme {
                timer.invalidate()
                complete((resultLoadedKeyboardTheme && resultLCustomTheme))
            }
        }
    }
    
    
    
    /// 테마 파일을 이미 다운로드 했는지 여부를 확인한다.
    /// - Parameter theme: 다운로드할 테마파일의 정보가 들어 있는 객체
    /// - Returns: 이미 다운로드 받은 테마인 경우 true, 그 외의 경우 false
    public func alreadyDownlaoded(theme: ENKeyboardThemeFileInfo) -> Bool {
        let keyboardUrl = themeFolder(name: theme.name, type: .keyboard)
        let customUrl = themeFolder(name: theme.name, type: .custom)
        
        if let _ = theme.customUrl {
            return
                FileManager.default.fileExists(atPath: keyboardUrl.path) &&
                FileManager.default.fileExists(atPath: customUrl.path)
        }
        else {
            return FileManager.default.fileExists(atPath: keyboardUrl.path)
        }
    }
    
    
    
    /// 테마파일을 다운로드 받을 경로를 가져온다.
    /// - Returns: 테마 파일을 다운로드 받을 경로.
    func downloadPath() -> URL {
        var url = ENKeyboardSDKCore.shared.groupDirectoryURL
        if let _ = url {
            url!.appendPathComponent("download")
            
            return url!
        }
        else {
            return URL.init(string: "")!
        }
        
    }
    
    
    /// 테마및 테마내 타입별 다운로드 받을 경로를 생성해준다.
    /// - Parameters:
    ///   - name: 다운로드 받을 테마 이름
    ///   - type: 다운로드 받는 테마 타입
    /// - Returns: 해당 테마를 다운로드 받을 실제 경로.
    func themeFolder(name:String, type: ENKeyboardThemeType) -> URL {
        var url = ENKeyboardSDKCore.shared.groupDirectoryURL
        
        if let _ = url {
            url!.appendPathComponent("theme")
            url!.appendPathComponent(name)
//            url!.appendPathComponent(type.rawValue)
            
            return url!
        }
        else {
            return URL.init(string: "")!
        }
    }
    
    
    
    /// 다운로드된 테마파일 정보를 삭제 한다.
    /// - Parameter theme: 삭제할 테마파일 정보
    public func removeDownloadedTheme(theme: ENKeyboardThemeFileInfo) {
        let keyboardUrl = themeFolder(name: theme.name, type: .keyboard)
        let customUrl = themeFolder(name: theme.name, type: .custom)
        
        if FileManager.default.fileExists(atPath: keyboardUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: keyboardUrl.path)
            }
            catch {}
        }
        
        if FileManager.default.fileExists(atPath: customUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: customUrl.path)
            }
            catch {}
        }
        
        if let keyboardUrl = theme.keyboardUrl, let url = URL.init(string: keyboardUrl) {
            var destinationURL = downloadPath()
            destinationURL.appendPathComponent(url.lastPathComponent)
            
            do {
                try FileManager.default.removeItem(at: destinationURL)
            }
            catch {}
        }
        
        if let customUrl = theme.customUrl, let url = URL.init(string: customUrl) {
            var destinationURL = downloadPath()
            destinationURL.appendPathComponent(url.lastPathComponent)
            
            do {
                try FileManager.default.removeItem(at: destinationURL)
            }
            catch {}
        }
        
    }
    
    
    /// 테마 파일을 다운로드 받는다.
    /// - Parameters:
    ///   - name: 테마 이름
    ///   - url: 다운로드 받을 테마 파일의 주소
    ///   - type: 테마 타입 객체
    ///   - complete: 테마의 다운로드가 완료된 경우 실행될 클로저
    /// - Returns: 테마 파일의 다운로드가 완료된 경우 true, 그외의 경우 false
    func downloadThemeFile(name:String, url: String, type: ENKeyboardThemeType, complete: @escaping (_ success:Bool) -> ()) {
        
        do {
            var destinationURL = downloadPath()
            DHLogger.log("download at [\(destinationURL.absoluteString)]")
            
            
            try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            
            guard let sourceUrl = URL(string: url) else {
                complete(false)
                return
            }
            
            destinationURL.appendPathComponent(sourceUrl.lastPathComponent)
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: destinationURL.path)
                }
                catch{
                    DHLogger.log("Download - File remove error:\(error)")
                    complete(false)
                }
            }
            
            DHApiClient.shared.downloadFile(src: sourceUrl, dest: destinationURL) { [weak self] result in
                guard let self else { return }
                if result {
                    self.unzipTheme(name: name, filePath: destinationURL.absoluteString, type: type, complete: complete)
                }
                else {
                    complete(false)
                }
            }
            
        } catch {
            DHLogger.log("Download Error :\(error)")
            complete(false)
        }
        
    }
    
    
    
    /// 다운로드 받은 테마 파일의 압축을 풀어준다.
    /// - Parameters:
    ///   - name: 테마 파일 이름
    ///   - filePath: 다운로드 받을 테마 파일의 경로
    ///   - type: 테마 파일 타입
    ///   - complete: 테마 파일의 압축 해제가 완료된 경우 실행될 클로저
    /// - Returns: 테마 파일의 압축 해제가 완료된 경우 true, 그외의 경우 false
    func unzipTheme(name:String, filePath: String, type: ENKeyboardThemeType, complete: @escaping (_ success:Bool) -> ()) {
        let sourceURL = name == "default" ? URL(fileURLWithPath: filePath) : URL(string: filePath)!
        let destinationURL = themeFolder(name: name, type: type)
        
//        if FileManager.default.fileExists(atPath: destinationURL.path) {
//            do {
//                try FileManager.default.removeItem(atPath: destinationURL.path)
//            }
//            catch {
//                DHLogger.log("UnZip - File remove error:\(error)")
//                complete(false)
//                return
//            }
//        }
        
        do {
            try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.unzipItem(at: sourceURL, to: destinationURL)
            
            complete(true)
        } catch {
            DHLogger.log("Extraction of ZIP archive failed with error:\(error)")
            complete(false)
        }
    }
}



//MARK:- 포토 테마 관련

extension ENKeyboardThemeManager {
    
    func photoThemeDirectory() -> URL {
        var url = ENKeyboardSDKCore.shared.groupDirectoryURL
        if let _ = url {
            url!.appendPathComponent("photoTheme")
            url!.appendPathComponent("photoThemeBackground.png")
            
            return url!
        }
        else {
            return URL.init(string: "")!
        }
        
    }
    
    func photoThemePath() -> URL {
        var url = photoThemeDirectory()
        url.appendPathComponent("photoThemeBackground.png")
        return url
    }
    
    public func savePhotoThemeBackground(image:UIImage, complete: @escaping (_ success:Bool) -> ()) {
        let saveUrl = photoThemePath()
        
        if FileManager.default.fileExists(atPath: saveUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: saveUrl.path)
            }
            catch {
                DHLogger.log("PhotoTheme Image Save - File remove error:\(error)")
                complete(false)
                
                return
            }
        }
        
        if let data = image.pngData() {
            do {
                try FileManager.default.createDirectory(at: photoThemeDirectory(), withIntermediateDirectories: true, attributes: nil)
                try data.write(to: saveUrl)
                complete(true)
            }
            catch {
                DHLogger.log("PhotoTheme Image Save - File save error:\(error)")
                complete(false)
            }
        }
    }
    
    func getPhotoThemeBackgroundImage(theme:ENKeyboardTheme) -> UIImage? {
        let photoImage = UIImage.init(contentsOfFile: self.photoThemePath().path)
        theme.backgroundImage = photoImage
        
        return croppedImageForPhotoTheme(theme: theme)
    }
    
    
    public func savePhotoTheme(with theme:ENKeyboardTheme, originImage:UIImage?, complete: @escaping (_ success:Bool) -> ()) {
        if let origin = originImage {
            self.savePhotoThemeBackground(image: origin) { success in
                ENSettingManager.shared.isUsePhotoTheme = true
                ENSettingManager.shared.photoThemeInfo = theme
                
                complete(success)
            }
        }
        else {
            complete(false)
        }
    }
    
    public func croppedImageForPhotoTheme(theme:ENKeyboardTheme) -> UIImage? {
        var rect:CGRect = .zero
        guard let photo = theme.backgroundImage else {
            return nil
        }
        
        let imageOffsetY = theme.imageOffsetY
        let imageOffsetX = theme.imageOffsetX
        let imageUseHeight = theme.imageUseHeight
        let imageUseWidth = theme.imageUseWidth
        
        switch photo.imageOrientation {
        case .left, .leftMirrored:
            rect = CGRect.init(x: photo.size.height - (imageOffsetY + imageUseHeight),
                               y: imageOffsetX,
                               width: imageUseHeight,
                               height: imageUseWidth)
            break
            
        case .right, .rightMirrored:
            rect = CGRect.init(x: imageOffsetY,
                               y: photo.size.width - (imageOffsetX + imageUseWidth),
                               width: imageUseHeight,
                               height: imageUseWidth)
            break
            
        case .down, .downMirrored:
            rect = CGRect.init(x: imageOffsetX,
                               y: photo.size.height - (imageOffsetY + imageUseHeight),
                               width: imageUseWidth,
                               height: imageUseHeight)
            break
        default:
            rect = CGRect.init(x: imageOffsetX,
                                   y: imageOffsetY,
                                   width: imageUseWidth,
                                   height: imageUseHeight)
            break
        }
        
        guard let imageRef: CGImage = photo.cgImage?.cropping(to: rect) else {
            return nil
        }
        
        return UIImage(cgImage: imageRef, scale: photo.scale, orientation: photo.imageOrientation)//.image(alpha: alpha)
    }
    
}
