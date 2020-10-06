import UIKit


public extension UIViewController {
    
    // MARK: - Storyboard
    
    static func storyboard(_ name: String = "Main") -> UIStoryboard {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard
    }
    
    static func viewController(_ viewControllerName: String, storyboardName: String = "Main") -> UIViewController {
        let storyboard = self.storyboard(storyboardName)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName)
        
        return viewController
    }
    
    
    // MARK: - Top ViewController
    
    static var topViewController: UIViewController? {
        let viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        return self.topViewControllerFromViewController(viewController)
    }
    
    fileprivate static func topViewControllerFromViewController(_ controller: UIViewController? = nil) -> UIViewController? {
        
        guard controller != nil else {
            return nil
        }
        
        if (controller!.presentedViewController != nil) {
            return self.topViewControllerFromViewController(controller!.presentedViewController!)
        }
        
        if (controller! is UISplitViewController) {
            let splitViewController: UISplitViewController = (controller! as! UISplitViewController)
            
            if splitViewController.viewControllers.count > 0 {
                
                let vcsArray: Array<UIViewController> = splitViewController.viewControllers
                return self.topViewControllerFromViewController(vcsArray.last!)
            } else {
                return controller!
            }
        }
        
        if (controller is UINavigationController) {
            let navigationController: UINavigationController = (controller as! UINavigationController)
            
            if navigationController.viewControllers.count > 0 {
                return self.topViewControllerFromViewController(navigationController.topViewController!)
            } else {
                return controller!
            }
        }
        
        if (controller is UITabBarController) {
            let tabBarController: UITabBarController = (controller as! UITabBarController)
            
            if tabBarController.viewControllers!.count > 0 {
                if tabBarController.selectedViewController != nil {
                    return self.topViewControllerFromViewController(tabBarController.selectedViewController!)
                } else {
                    return self.topViewControllerFromViewController(tabBarController.viewControllers![0])
                }
            } else {
                return controller!
            }
        }
        
        return controller!
    }
    

    // MARK: - Show or Hide NavBar

    func showNavBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func hideNavBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    // MARK: - Alert
    
    static func showAlert(title: String = "",
                          message: String,
                          viewController: UIViewController = UIViewController.topViewController!) {
               
        viewController.showAlert(title: title, message: message)
    }
    
    
    
    func showAlert(title: String = "", message: String) {
        
        let alert: UIAlertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "COMMON_OK".localized, style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
