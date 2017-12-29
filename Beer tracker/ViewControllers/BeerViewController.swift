import UIKit

class BeerViewController:UITableViewController {
    @IBOutlet weak var brewer:UILabel!
    @IBOutlet weak var alcoholPercentage:UILabel!
    @IBOutlet weak var color:UILabel!
    @IBOutlet weak var rating:CosmosView!
    @IBOutlet weak var favorite:UISwitch!
    @IBOutlet weak var date:UILabel!
    
    var beer:Beer!
    let beerService = BeerService()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        updateView()
        rating.settings.updateOnTouch = false
        favorite.isOn = beer.favorite
        favorite.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        beer.favorite = mySwitch.isOn
    }
    
    @IBAction func onEditClick() {
        let actionSheet = UIAlertController(title: beer.name, message: "What do you want to do", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.default) { (ACTION) in
            self.performSegue(withIdentifier: "editBeer", sender: nil)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.destructive) { (ACTION) in
            self.performSegue(withIdentifier: "didRemoveBeer", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (ACTION) in
            
        }
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(removeAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromAddBeer(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        //If beer was edited wil refer to this controller, will refer to other controller for added
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
        formatter.dateFormat = "dd-MM-yyyy"
        date.text = formatter.string(from: beer.dateAdded)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didRemoveBeer"?:
            break;
        case "editBeer"?:
            let addBeerViewController = segue.destination as! AddBeerViewController
            addBeerViewController.beer = beer
            break;
        default:
            fatalError("Unknown segue")
        }
    }
    
    
}
