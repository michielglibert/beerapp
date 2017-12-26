class Beer {
    
    enum Kleur: String {
        case blond = "Blond"
        case blondbruin = "Blond/Bruin"
        case bruin = "Bruin"
    }
    
    var naam:String
    var brouwer:String
    var kleur:Kleur
    var alcoholPercentage:Double
    var rating:Int
    var favoriet:Bool
    
    init(naam: String, brouwer: String, kleur: Kleur, alcoholPercentage: Double, rating: Int, favoriet: Bool) {
        self.naam = naam
        self.brouwer = brouwer
        self.kleur = kleur
        self.alcoholPercentage = alcoholPercentage
        self.rating = rating
        self.favoriet = favoriet
    }
}
