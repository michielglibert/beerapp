import UIKit

class BeersViewController:UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    var beers: [Beer] = [
        Beer(name: "Duvel", rating: 4, favorite: true, brewer: "Duvel moortgat", color: Color.blond, alcoholPercentage: 8.5),
        Beer(name: "Jupiler", rating: 5, favorite: false, brewer: "AB Inbev", color: Color.blond, alcoholPercentage: 5.2)
    ]
    
    var currentBeers = [Beer]()
    private var collapseDetailViewController = true
    
    override func viewDidLoad() {
        currentBeers = beers
    }
    
    @IBAction func unwindFromAddBeer(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "addBeer"?:
            let addBeerViewController = segue.source as! AddBeerViewController
            beers.append(addBeerViewController.beer!)
            currentBeers = beers
            tableView.insertRows(at: [IndexPath(row: beers.count - 1, section: 0)], with: .automatic)
        default:
            fatalError("Unknown segue")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addBeer":
            break;
        case "editBeer":
            break;
        case "showBeer"?:
            let beerViewController = (segue.destination as! UINavigationController).topViewController as! BeerViewController
            let selection = tableView.indexPathForSelectedRow!
            beerViewController.beer = beers[selection.row]
            //Titel wordt hier al gedefinieerd zodat hij niet plots tevoorschijn komt
            beerViewController.title = beerViewController.beer.name
            tableView.deselectRow(at: selection, animated: true)
        default:
            fatalError("Unknown segue")
        }
    }
}

extension BeersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collapseDetailViewController = false
    }
}

extension BeersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath) as! BeerCell
        cell.beer = currentBeers[indexPath.row]
        return cell
    }
}

extension BeersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            currentBeers = beers
        } else {
            currentBeers = beers.filter({ (beer) -> Bool in
                return beer.name.contains(searchText)
            })
        }

        tableView.reloadData()
    }
}