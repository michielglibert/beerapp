import UIKit

class ProfileViewController:UIViewController {
    @IBOutlet weak var beerAmountLabel:UILabel!
    @IBOutlet weak var favoriteAmountLabel:UILabel!
    
    var beerService = BeerService()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beerAmountLabel.text = String(beerService.getBeers().count)
        favoriteAmountLabel.text = String(beerService.getBeers().filter({$0.favorite == true}).count)
    }
}
