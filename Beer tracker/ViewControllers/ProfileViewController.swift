import UIKit

class ProfileViewController:UIViewController {
    @IBOutlet weak var beerAmount:UILabel!
    @IBOutlet weak var favoriteAmount:UILabel!
    @IBOutlet weak var blondeAmount:UILabel!
    @IBOutlet weak var blondebrownAmount:UILabel!
    @IBOutlet weak var brownAmount:UILabel!
    
    var beerService = BeerService()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beerAmount.text = String(beerService.getBeers().count)
        favoriteAmount.text = String(beerService.getBeers().filter({$0.favorite == true}).count)
        blondeAmount.text = String(beerService.getBeers().filter({$0.color == Color.blond}).count)
        blondebrownAmount.text = String(beerService.getBeers().filter({$0.color == Color.blondbrown}).count)
        brownAmount.text = String(beerService.getBeers().filter({$0.color == Color.brown}).count)
    }
}
