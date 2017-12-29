import UIKit

class AddBeerViewController:UITableViewController {
    @IBOutlet weak var name:UITextField!
    @IBOutlet weak var brewer:UITextField!
    @IBOutlet weak var alcoholPercentage:UITextField!
    @IBOutlet weak var color:UITextField!
    @IBOutlet weak var rating:CosmosView!
    @IBOutlet weak var saveButton:UIBarButtonItem!
    
    var beer:Beer?
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
            saveButton.isEnabled = true
        }
        
        let collection = [name, brewer, alcoholPercentage, color]
        var counter = 0
        
        //Sets the delegate and adds a tag for each textfield
        //Done for the method textFieldShouldReturn()
        collection.forEach { field in
            field?.delegate = self
            field?.tag = counter
            name.returnKeyType = .next
            counter = counter + 1
        }
        
        createBeerPicker()
        createToolbar()
    }
    
    @IBAction func save() {
        if beer == nil {
            performSegue(withIdentifier: "addBeer", sender: self)
        } else {
            performSegue(withIdentifier: "editBeer", sender: self)
        }
        
        name.text! = ""
        brewer.text! = ""
        alcoholPercentage.text! = ""
        color.text! = ""
        rating.rating = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if beer == nil {
            beer = Beer(name: name.text!, rating: Int(rating.rating), favorite: false, brewer: brewer.text!, color: Color(rawValue: color.text!)!, alcoholPercentage: Double(alcoholPercentage.text!)!)
        } else {
            beer?.name = name.text!
            beer?.rating = Int(rating.rating)
            beer?.brewer = brewer.text!
            beer?.color = Color(rawValue: color.text!)!
            beer?.alcoholPercentage = Double(alcoholPercentage.text!)!
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
