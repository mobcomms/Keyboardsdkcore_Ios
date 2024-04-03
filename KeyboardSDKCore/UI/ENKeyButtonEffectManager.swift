//
//  ENKeyButtonEffectManager.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/31.
//

import Foundation
import AudioToolbox

public class ENKeyButtonEffectManager {
    
    public static let shared:ENKeyButtonEffectManager = ENKeyButtonEffectManager()
    
    var feedback: UIImpactFeedbackGenerator? = nil
    var feedbackSoundID:SystemSoundID = 0
    
    
    func stateUpdate() {
        if ENSettingManager.shared.useHaptic {
            switch ENSettingManager.shared.hapticPower {
            case 0:
                feedback = nil
                break
            case 1:
                feedback = UIImpactFeedbackGenerator(style: .rigid)
                break
            case 2:
                feedback = UIImpactFeedbackGenerator(style: .medium)
                break
            case 3:
                feedback = UIImpactFeedbackGenerator(style: .heavy)
                break
            default:
                feedback = UIImpactFeedbackGenerator(style: .medium)
                break
            }
        }
        else {
            feedback = nil
        }
        
        let soundId = ENSettingManager.shared.soundID
        if ENSettingManager.shared.useSound, let url = getSelectedSoundFileUrl(soundId) {
            AudioServicesCreateSystemSoundID(url as CFURL, &feedbackSoundID)
        }
        else {
            feedbackSoundID = 0
        }
    }
 
    
    func excute() {
        if self.feedbackSoundID > 0 {
            AudioServicesPlaySystemSound(feedbackSoundID)
        }

        switch ENSettingManager.shared.hapticPower {
        case 0:
            provideHaptic(hapticVal: nil)
            break
        case 1:
            provideHaptic(hapticVal: .light)
            break
        case 2:
            provideHaptic(hapticVal: .medium)
            break
        case 3:
            provideHaptic(hapticVal: .heavy)
            break
        default:
            provideHaptic(hapticVal: .medium)
            break
        }
    }
    
    func provideHaptic(hapticVal: UIImpactFeedbackGenerator.FeedbackStyle?) {
        if let hap = hapticVal {
            let generator = UIImpactFeedbackGenerator(style: hap)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    public func excuteSound(with soundId: Int) {
        if let url = getSelectedSoundFileUrl(soundId) {
            AudioServicesCreateSystemSoundID(url as CFURL, &feedbackSoundID)
            
            if feedbackSoundID > 0 {
                AudioServicesPlaySystemSound(feedbackSoundID)
            }
        }
    }
    
    public func excuteHaptic(with hapticPower: Int) {
        switch hapticPower {
        case 0:
            feedback = nil
            break
        case 1:
            feedback = UIImpactFeedbackGenerator(style: .light)
            break
        case 2:
            feedback = UIImpactFeedbackGenerator(style: .medium)
            break
        case 3:
            feedback = UIImpactFeedbackGenerator(style: .heavy)
            break
        default:
            feedback = UIImpactFeedbackGenerator(style: .medium)
            break
        }
        feedback?.impactOccurred()
    }
    
    
    private func getSelectedSoundFileUrl(_ soundId:Int) -> URL? {
        let effect = "aikbd_sound\(soundId)"
        let type = "wav"
        
        if let path = Bundle.frameworkBundle.path(forResource: effect, ofType: type) {
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
}



