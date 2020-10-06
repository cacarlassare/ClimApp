
import UIKit

open class ControllersSliderViewController: UIViewController, UITabBarControllerDelegate  {
    
    fileprivate var pageViewController: UIPageViewController?
    fileprivate var controllers: [UIViewController] = [UIViewController]()
    fileprivate var currentlyShowingIndex: Int = 0
    open var preloadsViewControllers: Bool = false
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.configPageViewController()
    }

    
    fileprivate func configPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.pageViewController?.delegate = self
        self.pageViewController?.dataSource = self
        self.pageViewController?.view.frame = self.view.bounds
                
        self.addChild(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController?.didMove(toParent: self)
        self.pageViewController?.view.backgroundColor = self.view.backgroundColor
    }
    
    
    func updateControllers() {
        guard self.controllers.count > 0 else {
            return
        }
        
        for controller in self.controllers {
            controller.loadViewIfNeeded()
        }
        
        self.pageViewController?.setViewControllers([self.controllers[0]], direction: .forward, animated: false, completion: nil)
    }
    
    func addController(controller: UIViewController) {
        self.controllers.append(controller)
    }
    
    func removeController(controller: UIViewController) {
        if let index = self.controllers.firstIndex(of: controller) {
            self.controllers.remove(at: index)
        }
    }
    
    func removeAllControllers() {
        self.controllers.removeAll()
        self.currentlyShowingIndex = 0
    }
}

extension ControllersSliderViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard self.controllers.count > previousIndex else {
            return nil
        }
        
        currentlyShowingIndex -= 1
        
        return self.controllers[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = self.controllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        currentlyShowingIndex += 1
        
        return self.controllers[nextIndex]
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
            return currentlyShowingIndex
    }
        
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }

}
