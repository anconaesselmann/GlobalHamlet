import UIKit

class MainTabBarController: DICTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabItems = tabBar.items as [UITabBarItem]
        
        let tabBarImage0_selected = UIImage(named: "tabBar_puzzleMan_active")
        let tabBarImage0 = UIImage(named: "tabBar_puzzleMan_inactive")
        println("loaded")
        tabItems[0].title = "me"
        tabItems[0].image = tabBarImage0
        tabItems[0].selectedImage = tabBarImage0_selected
   }
}