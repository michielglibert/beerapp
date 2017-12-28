import UIKit

class FavoritesViewController:UIViewController {
    @IBOutlet weak var tableView:UITableView!
    
    var beerService = BeerService()
    var beers = [Beer]()
    
    override func viewDidLoad() {
        beers = beerService.getBeers().filter({$0.favorite == true})
    }
    
}

extension FavoritesViewController:UITableViewDataSource {
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
