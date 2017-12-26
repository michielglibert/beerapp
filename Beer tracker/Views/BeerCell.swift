import UIKit

class BeerCell: UITableViewCell {
    @IBOutlet weak var nameLabel:UILabel!
    
    var beer: Beer! {
        didSet {
            nameLabel.text = beer.name
        }
    }
}
