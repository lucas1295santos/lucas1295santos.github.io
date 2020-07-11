import Publish

extension Path {
    static func forImage(named name: String, withExtension imageExtension: ImageExtension) -> Path {
        return Path("../images/\(name)\(imageExtension.rawValue)")
    }
    
    static var home: Path {
        return ("https://www.lucasoliveira.tech/")
    }
}

enum ImageExtension: String {
    case jpg = ".jpg"
    case png = ".png"
}
