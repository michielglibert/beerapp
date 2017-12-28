import UIKit

class BeerViewController:UITableViewController {
    @IBOutlet weak var brewer:UILabel!
    @IBOutlet weak var alcoholPercentage:UILabel!
    @IBOutlet weak var color:UILabel!
    @IBOutlet weak var rating:CosmosView!
    @IBOutlet weak var favorite:UISwitch!
    
    var beer:Beer!
    
    override func viewDidLoad() {
        brewer.text = beer.brewer
        alcoholPercentage.text = String(beer.alcoholPercentage)
        color.text = beer.color.rawValue
        rating.rating = Double(beer.rating)
        rating.settings.updateOnTouch = false
        favorite.isOn = beer.favorite
        favorite.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        beer.favorite = mySwitch.isOn
    }
    
    
    
}
