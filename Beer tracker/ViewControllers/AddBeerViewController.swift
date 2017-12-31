import UIKit

class AddBeerViewController:UITableViewController {
    @IBOutlet weak var name:UITextField!
    @IBOutlet weak var brewer:UITextField!
    @IBOutlet weak var alcoholPercentage:UITextField!
    @IBOutlet weak var color:UITextField!
    @IBOutlet weak var rating:CosmosView!
    @IBOutlet weak var saveButton:UIBarButtonItem!
    
    var beer:Beer?
    var location:Location?
    var selectedColor:Color?
    var selectedRating:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let beer = beer {
            title = "Edit beer"
            name.text = beer.name
            brewer.text = beer.brewer
            alcoholPercentage.text = String(beer.alcoholPercentage)
            color.text = beer.color.rawValue
            rating.rating = Double(beer.rating)
            location = beer.location
            saveButton.isEnabled = true
        }
        
        let collection = [name, brewer, alcoholPercentage, color]
        var counter = 0
        
        //Sets the delegate and adds a tag for each textfield
        //Done for the method textFieldShouldReturn()
        collection.forEach { field in
            field?.delegate = self
            field?.tag = counter
            field?.returnKeyType = .next
            counter = counter + 1
        }
        
        
        //Source: https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBeerViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        createBeerPicker()
        createToolbar()
    }
    
    @IBAction func save() {
        if beer == nil {
            if location == nil {
                let alert = UIAlertController(title: "No location set", message: "Are you sure you want to add this beer without a location?", preferredStyle: .alert)
            
                let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (ACTION) in
                    self.addBeer()
                }
            
                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
                alert.addAction(ok)
                alert.addAction(cancel)
            
                self.present(alert, animated: true, completion: nil)
            } else {
                addBeer()
            }            
        } else {
            performSegue(withIdentifier: "didEditBeer", sender: self)
        }
    }
    
    func addBeer() {
        self.performSegue(withIdentifier: "didAddBeer", sender: self)
        
        self.name.text! = ""
        self.brewer.text! = ""
        self.alcoholPercentage.text! = ""
        self.color.text! = ""
        self.rating.rating = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didAddBeer"?:
            beer = Beer(name: self.name.text!, rating: Int(rating.rating), favorite: false, brewer: self.brewer.text!, color: Color(rawValue: self.color.text!)!, alcoholPercentage: Double(self.alcoholPercentage.text!)!)
            if location != nil {
                beer?.location = location
            }
            break
        case "didEditBeer"?:
            beer?.name = name.text!
            beer?.rating = Int(rating.rating)
            beer?.brewer = brewer.text!
            beer?.color = Color(rawValue: color.text!)!
            beer?.alcoholPercentage = Double(alcoholPercentage.text!)!
            break
        case "showMap"?:
            break
        default:
            print(segue.identifier!)
            fatalError("Unknown segue")
        }
    }
    
    //Creates a picker for the textfield
    func createBeerPicker() {
        let colorPicker = UIPickerView()
        colorPicker.delegate = self
        color.inputView = colorPicker
    }
    
    //When tapped the textfield shows it's initial value
    @IBAction func showText() {
        color.text = Color.blond.rawValue
    }
    
    //Adds toolbar to picker
    //Source: https://www.youtube.com/watch?v=HkDDGfMiuOA
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                         action: #selector(AddBeerViewController.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        color.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func unwindFromAddLocation(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didAddLocation"?:
            let addLocationViewController = segue.source as! AddLocationViewController
            location = addLocationViewController.location
            let indexPath = IndexPath(row: 0, section: 5)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.textLabel?.text = location?.name
            break
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
        return Color.colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Color.colors[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = Color.colors[row]
        color.text = selectedColor?.rawValue
    }
    
    func validate() {
        if name.text!.count > 0 && brewer.text!.count > 0 && alcoholPercentage.text!.count > 0 && color.text!.count > 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
    }
    
    
}

extension AddBeerViewController: UITextFieldDelegate {
    //Method checks the next field when return is pressed
    //source: https://stackoverflow.com/questions/31766896/switching-between-text-fields-on-pressing-return-key-in-swift
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
    }
    
    //Makes it so the textfield with tag 2 only allows numbers as input
    //source: https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.tag == 2 {
            let allowedCharacters = NSCharacterSet(charactersIn: "0123456789.")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
}
