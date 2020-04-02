import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct Lucas1295santosGithubIo: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://lucas1295santos.github.io/")!
    var name = "Lucas1295santosGithubIo"
    var description = "A description of Lucas1295santosGithubIo"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try Lucas1295santosGithubIo().publish(
  withTheme: .foundation,
  additionalSteps: [
    .deploy(using: .git("git@github.com-lucas1295santos:lucas1295santos/lucas1295santos.github.io.git"))
  ]
)
