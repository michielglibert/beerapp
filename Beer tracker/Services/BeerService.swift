//Although this class is pretty unnecessary right now, I have developed the app this way so it can be used in the future
class BeerService {
    func getBeers() -> [Beer] {
        return DummyData.beers
    }
    
    func addBeer(beer: Beer) {
        DummyData.beers.append(beer)
    }
    
    /*
    //Not used
    func editBeer(beer: Beer) {
        if let index = beers.index(where: {$0 === beer}) {
            beers[index] = beer
        }
    }*/
    
    func removeBeer(beer: Beer) {
        if let index = DummyData.beers.index(where: {$0 === beer}) {
            DummyData.beers.remove(at: index)
        }
    }
}
