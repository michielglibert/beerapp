import UIKit

class BeersViewController:UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    var beerService = BeerService()
    var beers = [Beer]()
    
    private var indexPathToEdit: IndexPath!
    
    override func viewDidLoad() {
        self.navigationItem.title = parent?.parent?.parent?.restorationIdentifier
        title = parent?.parent?.parent?.restorationIdentifier
        
        if title == "Favorites" {
            //Makes sure that the add button is removed
            self.navigationItem.rightBarButtonItems = nil
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beers = getBeersForView()
        tableView.reloadData()
        
    }
    
    @IBAction func unwindFromAddBeer(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didAddBeer"?:
            let addBeerViewController = segue.source as! AddBeerViewController
            beerService.addBeer(beer: addBeerViewController.beer!)
            beers = getBeersForView()
            tableView.insertRows(at: [IndexPath(row: beers.count - 1, section: 0)], with: .automatic)
        default:
            fatalError("Unknown segue")
        }
    }
    
    @IBAction func unwindFromBeer(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didRemoveBeer"?:
            let beerViewController = segue.source as! BeerViewController
            beerService.removeBeer(beer: beerViewController.beer)
            beers = getBeersForView()
            tableView.deleteRows(at: [IndexPath(row: beers.count - 1, section: 0)], with: .automatic)
            break
        default:
            fatalError("Unknown segue")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addBeer"?:
            break
        case "showDefault"?:
            break
        case "showBeer"?:
            let beerViewController = (segue.destination as! UINavigationController).topViewController as! BeerViewController
            let selection = tableView.indexPathForSelectedRow!
            beerViewController.beer = beers[selection.row]
            //Title is defined here so it doesn't randomly pop-up when loading the view
            beerViewController.title = beerViewController.beer.name
            tableView.deselectRow(at: selection, animated: true)
            break
        default:
            fatalError("Unknown segue")
        }
    }
    
    func getBeersForView() -> [Beer] {
        switch title {
        case "Beers"?:
            return beerService.getBeers()
        case "Favorites"?:
            return beerService.getBeers().filter({$0.favorite == true})
        default:
            fatalError("Unknown identifier")
        }
    }
    
}

extension BeersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath) as! BeerCell
        cell.beer = beers[indexPath.row]
        return cell
    }
}

extension BeersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            beers = getBeersForView()
        } else {
            beers = getBeersForView().filter({ (beer) -> Bool in
                return beer.name.contains(searchText)
            })
        }

        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        beers = getBeersForView()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
}
