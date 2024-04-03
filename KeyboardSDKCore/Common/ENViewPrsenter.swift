//
//  ENViewPrsenter.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/18.
//

import UIKit


/// ViewController 출력 Protocol.
public protocol ENViewPrsenter: AnyObject {
    func enPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: @escaping () -> Void)
    func enPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool)
    func enDismiss(animated flag: Bool, popToRoot: Bool, completion: @escaping () -> Void)
    func enDismiss(animated flag: Bool, popToRoot: Bool)
}



public extension ENViewPrsenter where Self:UIViewController {
    
    
    /// 지정된 뷰컨트롤러를 화면에 표시한다. NavigationViewController의 하위 뷰인 경우 push를, 그외의 경우에는 present로 처리한다.
    /// - Parameters:
    ///   - viewControllerToPresent: 화면에 표시할 뷰 컨트롤러
    ///   - flag: animation 표현 여부, 기본값은 true
    ///   - completion: 뷰 컨트롤러가 화면에 표시된 이후 실행될 클로저, 기본값은 nil
    func enPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool = true, completion: @escaping () -> Void) {
        if let nav = self.navigationController {
            nav.pushViewController(viewControllerToPresent, animated: flag, completion: completion)
        }
        else {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    
    /// 지정된 뷰컨트롤러를 화면에 표시한다. NavigationViewController의 하위 뷰인 경우 push를, 그외의 경우에는 present로 처리한다.
    /// - Parameters:
    ///   - viewControllerToPresent: 화면에 표시할 뷰 컨트롤러
    ///   - flag: animation 표현 여부, 기본값은 true
    func enPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool = true) {
        if let nav = self.navigationController {
            nav.pushViewController(viewControllerToPresent, animated: flag)
        }
        else {
            self.present(viewControllerToPresent, animated: flag)
        }
    }
    
    
    
    /// 현재 뷰 컨트롤러를 화면에서 지우고 이전 화면으로 돌아간다. NavigationViewController의 하위 뷰인 경우 pop을, 그외의 경우에는 dismiss로 처리한다.
    /// - Parameters:
    ///   - flag: animation 표현 여부, 기본값은 true
    ///   - completion: 뷰 컨트롤러가 화면에서 지워진 이후 실행될 클로저
    func enDismiss(animated flag: Bool = true, popToRoot: Bool = false, completion: @escaping () -> Void) {
        if let nav = self.navigationController {
            if popToRoot {
                nav.popToRootViewController(animated: flag, completion: completion)
            }
            else {
                nav.popViewController(animated: flag, completion: completion)
            }
        }
        else {
            self.dismiss(animated: flag, completion: completion)
        }
    }
    
    /// 현재 뷰 컨트롤러를 화면에서 지우고 이전 화면으로 돌아간다. NavigationViewController의 하위 뷰인 경우 pop을, 그외의 경우에는 dismiss로 처리한다.
    /// - Parameters:
    ///   - flag: animation 표현 여부, 기본값은 true
    func enDismiss(animated flag: Bool = true, popToRoot: Bool = false) {
        if let nav = self.navigationController {
            if popToRoot {
                nav.popToRootViewController(animated: flag)
            }
            else {
                nav.popViewController(animated: flag)
            }
        }
        else {
            self.dismiss(animated: flag)
        }
    }
}
