import UIKit

class BeersViewController:UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    var beers: [Beer] = [
        Beer(name: "Duvel", rating: 4, favorite: true, brewer: "Duvel moortgat", color: Beer.Color.blond, alcoholPercentage: 8.5),
        Beer(name: "Jupiler", rating: 5, favorite: false, brewer: "AB Inbev", color: Beer.Color.blond, alcoholPercentage: 5.2)
    ]
    
    var currentBeers = [Beer]()
    
    override func viewDidLoad() {
        currentBeers = beers
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
        if(searchText.isEmpty) {
            currentBeers = beers
        } else {
            currentBeers = beers.filter({ (beer) -> Bool in
                return beer.name.contains(searchText)
            })
        }

        tableView.reloadData()
    }
}
