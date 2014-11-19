import UIKit

class LoadingScreenViewController: DICViewController {
    
    func perfomrSegue(response:Bool) {
        let storyBoardId: String = (response)
            ? "LaunchLoggedInSegue"
            : "LaunchFirstLaunchSegue"
        performSegueWithIdentifier(storyBoardId, sender: self)
    }
}