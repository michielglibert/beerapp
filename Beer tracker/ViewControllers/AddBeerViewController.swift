import UIKit

class AddBeerViewController:UITableViewController {
    @IBOutlet weak var name:UITextField!
    @IBOutlet weak var brewer:UITextField!
    @IBOutlet weak var alcoholPercentage:UITextField!
    @IBOutlet weak var color:UITextField!
    @IBOutlet weak var rating:CosmosView!
    
    var beer:Beer?
    var selectedColor:Color?
    var selectedRating:Int?
    
    @IBAction func save() {
        if beer == nil {
            performSegue(withIdentifier: "addBeer", sender: self)
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let beer = beer {
            title = beer.name
            name.text = beer.name
            brewer.text = beer.brewer
            rating.rating = Double(beer.rating)
        }
        
        let collection = [name, brewer, alcoholPercentage, color]
        var counter = 0
        
        collection.forEach { field in
            field?.delegate = self
            field?.tag = counter
            name.returnKeyType = .next
            counter = counter + 1
        }
        
        createBeerPicker()
        createToolbar()
    }
    
    func createBeerPicker() {
        let colorPicker = UIPickerView()
        colorPicker.delegate = self
        color.inputView = colorPicker
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addBeer"?:
            beer = Beer(name: name.text!, rating: Int(rating.rating), favorite: false, brewer: brewer.text!, color: Color.blond, alcoholPercentage: Double(alcoholPercentage.text!)!)
        case "editBeer"?:
            break;
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
    
}

//source: https://stackoverflow.com/questions/31766896/switching-between-text-fields-on-pressing-return-key-in-swift
extension AddBeerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
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
