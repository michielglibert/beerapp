enum Color: String {
    case blond = "Blond"
    case blondbrown = "Blond/Brown"
    case brown = "Brown"
}

//source: https://stackoverflow.com/questions/32952248/get-all-enum-values-as-an-array
extension Color {
    static var colors: [Color] {
        var colors: [Color] = []
        switch (Color.blond) {
        case .blond: colors.append(.blond); fallthrough
        case .blondbrown: colors.append(.blondbrown); fallthrough
        case .brown: colors.append(.brown)
        }
        return colors
    }
}
