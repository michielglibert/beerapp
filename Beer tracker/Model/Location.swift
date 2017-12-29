class Location {
    var street: String
    var number: String
    var place: String
    var country: String
    
    init(name: String, rating:Int, favorite:Bool, street: String, number: String, place: String, country: String) {
        self.street = street
        self.number = number
        self.place = place
        self.country = country
    }
}
