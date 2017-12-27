import UIKit

class AddBeerViewController:UITableViewController {
    @IBOutlet weak var name:UITextField!
    @IBOutlet weak var brewer:UITextField!
    @IBOutlet weak var alcoholPercentage:UITextField!
    @IBOutlet weak var color:UITextField!
    @IBOutlet weak var rating:UITextField!
    
    var beer:Beer?
    var selectedColor:Color?
    var selectedRating:Int?
    
    @IBAction func save() {
        if beer == nil {
            performSegue(withIdentifier: "addBeer", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBeerPicker()
        createRatingPicker()
    }
    
    func createBeerPicker() {
        let colorPicker = UIPickerView()
        colorPicker.tag = 1
        colorPicker.delegate = self
        color.inputView = colorPicker
    }
    
    func createRatingPicker() {
        let ratingPicker = UIPickerView()
        ratingPicker.tag = 2
        ratingPicker.delegate = self
        rating.inputView = ratingPicker
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addBeer"?:
            beer = Beer(name: name.text!, rating: 5, favorite: false, brewer: brewer.text!, color: Color.blond, alcoholPercentage: Double(alcoholPercentage.text!)!)
        default:
            fatalError("Unknown segue")
        }
    }
}

extension AddBeerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return Color.colors.count
        } else {
            return Rateable.ratings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return Color.colors[row].rawValue
        } else {
            return String(Rateable.ratings[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedColor = Color.colors[row]
            color.text = selectedColor?.rawValue
        } else {
            selectedRating = Rateable.ratings[row]
            rating.text = String(Rateable.ratings[row])
        }
    }
    
}

