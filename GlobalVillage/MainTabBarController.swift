import UIKit

class MainTabBarController: DICTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabItems = tabBar.items as [UITabBarItem]
        
        let tabBarImage0_selected = UIImage(named: "tabBar_puzzleMan_active")
        let tabBarImage0 = UIImage(named: "tabBar_puzzleMan_inActive")
        let tabBarImage1_selected = UIImage(named: "tabBar_connections_active")
        let tabBarImage1 = UIImage(named: "tabBar_connections_inactive")
        let tabBarImage2_selected = UIImage(named: "tabBar_connect_active")
        let tabBarImage2 = UIImage(named: "tabBar_connect_inactive")
        println("loaded")
        tabItems[0].title = "me"
        tabItems[0].image = tabBarImage0
        tabItems[0].selectedImage = tabBarImage0_selected
        tabItems[1].title = "connections"
        tabItems[1].image = tabBarImage1
        tabItems[1].selectedImage = tabBarImage1_selected
        tabItems[2].title = "connect"
        tabItems[2].image = tabBarImage2
        tabItems[2].selectedImage = tabBarImage2_selected
   }
}