import Foundation

class Beer {

    var name: String
    var rating: Int
    var favorite: Bool
    var brewer:String
    var color:Color
    var alcoholPercentage:Double
    var dateAdded:Date
    var location:Location?
    
    init(name: String, rating:Int, favorite:Bool, brewer: String, color: Color, alcoholPercentage: Double) {
        self.name = name
        self.rating = rating
        self.favorite = favorite
        self.brewer = brewer
        self.color = color
        self.alcoholPercentage = alcoholPercentage
        self.dateAdded = Date()
    }
    
    convenience init(name: String, rating:Int, favorite:Bool, brewer: String, color: Color, alcoholPercentage: Double, location: Location) {
        self.init(name: name, rating: rating, favorite: favorite, brewer: brewer, color: color, alcoholPercentage: alcoholPercentage)
        self.location = location
    }
}

