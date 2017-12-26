class Beer:Rateable {
    
    enum Color: String {
        case blond = "Blond"
        case blondbrown = "Blond/Brown"
        case brown = "Brown"
    }
    
    var brewer:String
    var color:Color
    var alcoholPercentage:Double
    
    init(name: String, rating:Int, favorite:Bool, brewer: String, color: Color, alcoholPercentage: Double) {
        self.brewer = brewer
        self.color = color
        self.alcoholPercentage = alcoholPercentage
        super.init(name: name, rating: rating, favorite: favorite)
    }
}
