import CoreData
import Foundation
import UIKit

class InitialViewController: UINavigationController, ViewControllerWithContext {
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        /*if (segue.identifier == "Load View") {
            
        }*/
        println("works")
    }
}