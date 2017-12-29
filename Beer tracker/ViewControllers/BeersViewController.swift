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
        
        switch title {
        case "Beers"?:
            beers = beerService.getBeers()
            break
        case "Favorites"?:
            //Makes sure that the add button is removed if in the favorites tab
            self.navigationItem.rightBarButtonItems = nil
            beers = beerService.getBeers().filter({$0.favorite == true})
            break
        default:
            fatalError("Unknown identifier")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Checks the title and filters the beers if true
        if title == "Favorites" {
            beers = beerService.getBeers().filter({$0.favorite == true})
        }
        
        tableView.reloadData()
        
    }
    
    @IBAction func unwindFromAddBeer(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        //If beer was added wil refer to this controller, will refer to other controller for edited
        case "beerEditedOrAdded"?:
            let addBeerViewController = segue.source as! AddBeerViewController
            beerService.addBeer(beer: addBeerViewController.beer!)
            beers = beerService.getBeers()
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
            beers = beerService.getBeers()
            tableView.deleteRows(at: [IndexPath(row: beers.count - 1, section: 0)], with: .automatic)
        default:
            fatalError("Unknown segue")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addBeer"?:
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
            beers = beerService.getBeers()
        } else {
            beers = beerService.getBeers().filter({ (beer) -> Bool in
                return beer.name.contains(searchText)
            })
        }

        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        
        beers = beerService.getBeers()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}
