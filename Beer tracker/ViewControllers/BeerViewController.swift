import UIKit

class BeerViewController:UITableViewController {
    @IBOutlet weak var brewer:UILabel!
    @IBOutlet weak var alcoholPercentage:UILabel!
    @IBOutlet weak var color:UILabel!
    @IBOutlet weak var rating:CosmosView!
    @IBOutlet weak var favorite:UISwitch!
    
    var beer:Beer!
    
    override func viewDidLoad() {
        updateView()
        rating.settings.updateOnTouch = false
        favorite.isOn = beer.favorite
        favorite.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        beer.favorite = mySwitch.isOn
    }
    
    @IBAction func unwindFromAddBeer(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "beerEditedOrAdded"?:
            let addBeerViewController = segue.source as! AddBeerViewController
            beer = addBeerViewController.beer
            updateView()
            break
        default:
            fatalError("Unknown segue")
        }
    }
    
    func updateView() {
        title = beer.name
        brewer.text = beer.brewer
        alcoholPercentage.text = String(beer.alcoholPercentage)
        color.text = beer.color.rawValue
        rating.rating = Double(beer.rating)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editBeer"?:
            let addBeerViewController = segue.destination as! AddBeerViewController
            addBeerViewController.beer = beer
            break;
        default:
            fatalError("Unknown segue")
        }
    }
    
    
}
