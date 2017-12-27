import UIKit

class BeerViewController:UITableViewController {
    @IBOutlet weak var brewer:UILabel!
    @IBOutlet weak var alcoholPercentage:UILabel!
    @IBOutlet weak var color:UILabel!
    
    var beer:Beer!
    
    override func viewDidLoad() {
        brewer.text = beer.brewer
        alcoholPercentage.text = String(beer.alcoholPercentage)
        color.text = beer.color.rawValue
    }
    
}
