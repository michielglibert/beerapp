import UIKit
import MapKit
import CoreLocation

class AddLocationViewController:UIViewController {
    @IBOutlet weak var mapView:MKMapView!
    
    let currentLocation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    
    var location:Location?
    
    @IBAction func done() {
        let alert = UIAlertController(title: "Add location", message: "Give a name to your location", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            field.placeholder = "Name"
        }
        
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (ACTION) in
            let name = alert.textFields![0].text
            self.location = Location(name: name!, latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
            self.performSegue(withIdentifier: "didAddLocation", sender: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        //Ask for location authorization
        locationManager.requestWhenInUseAuthorization()
        
        //If enabled, delegate and update location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        /*
        annotation.coordinate = (locationManager.location?.coordinate)!
        /*annotation.coordinate = CLLocationCoordinate2D(latitude: 51.112622, longitude: 3.716439)
        */annotation.title = "Place"
        annotation.subtitle = "The place"
        mapView.addAnnotation(annotation)
        var region = MKCoordinateRegion()
        region.center = annotation.coordinate
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)*/
    }
}

extension AddLocationViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError("Error getting location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: (manager.location?.coordinate)!, span: span)
        mapView.setRegion(region, animated: true)
        
        currentLocation.coordinate = region.center
    }
}

