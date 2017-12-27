class Rateable {
    var name: String
    var rating: Int
    var favorite: Bool
    
    static var ratings:[Int] = [1,2,3,4,5]
    
    init (name: String, rating: Int, favorite: Bool) {
        self.name = name
        self.rating = rating
        self.favorite = favorite
    }
}
