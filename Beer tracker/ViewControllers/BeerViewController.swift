import UIKit
import MapKit

class BeerViewController:UITableViewController {
    @IBOutlet weak var brewer:UILabel!
    @IBOutlet weak var alcoholPercentage:UILabel!
    @IBOutlet weak var color:UILabel!
    @IBOutlet weak var rating:CosmosView!
    @IBOutlet weak var favorite:UISwitch!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var mapView:MKMapView!
    
    var beer:Beer!
    let beerService = BeerService()
    let formatter = DateFormatter()
    
    override func viewDidAppear(_ animated: Bool) {
        //If the person selects the same beer on favorites and beers tab this makes sure that
        //everything gets updated
        updateView()
    }
    
    override func viewDidLoad() {
        updateView()
        rating.settings.updateOnTouch = false
        favorite.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        beer.favorite = mySwitch.isOn
    }
    
    @IBAction func onEditClick() {
        let actions = UIAlertController(title: beer.name, message: "What do you want to do", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.default) { (ACTION) in
            self.performSegue(withIdentifier: "editBeer", sender: nil)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.destructive) { (ACTION) in
            self.performSegue(withIdentifier: "didRemoveBeer", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (ACTION) in
            
        }
        
        actions.addAction(editAction)
        actions.addAction(removeAction)
        actions.addAction(cancelAction)
        
        //Ipad support for actionsheet
        actions.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        self.present(actions, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromEditBeer(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didEditBeer"?:
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
        favorite.isOn = beer.favorite
        date.text = formatter.string(from: beer.dateAdded)
        
        if beer.location != nil {
            //Remove all annotations
            mapView.removeAnnotations(mapView.annotations)
            
            //Add the annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake((beer.location?.latitude)!, (beer.location?.longitude)!)
            annotation.title = beer.location?.name
            mapView.addAnnotation(annotation)
            
            //Set the region
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
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
