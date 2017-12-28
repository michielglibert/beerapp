class BeerService {
    var beers = DummyData.beers
    
    func getBeers() -> [Beer] {
        return beers
    }
    
    func addBeer(beer: Beer) {
        beers.append(beer)
    }
    
    func editBeer(beer: Beer) {
        if let index = beers.index(where: {$0 === beer}) {
            beers[index] = beer
        }
    }
    
    func removeBeer(beer: Beer) {
        if let index = beers.index(where: {$0 === beer}) {
            beers.remove(at: index)
        }
    }
}
