import Plot
import Publish

class SocialButtons {
    static func make() -> Node<HTML.ListContext> {
        .li(
            .class("social-media-buttons"),
            .a(
                .class("social-media-button"),
                .i(
                    .class("fa fa-twitter")
                ),
                .href("https://twitter.com/oliveira__lucas")
            ),
            .a(
                .class("social-media-button"),
                .i(
                    .class("fa fa-github")
                ),
                .href("https://github.com/lucas1295santos")
            ),
            .a(
                .class("social-media-button"),
                .i(
                    .class("fa fa-linkedin")
                ),
                .href("https://linkedin.com/in/lucas-santos-168769106")
            )
        )
    }
}
