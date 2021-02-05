import Plot
import Publish

extension Theme {
    static var custom: Self {
        Theme(
            htmlFactory: CustomHTMLFactory(),
            resourcePaths: ["Resources/css/styles.css"]
        )
    }
}

private struct CustomHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        let paths: [Path] = [
            "/css/styles.css",
            "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css",
        ]
        return HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site, stylesheetPaths: paths),
            .body(
                .wrapper(
                    .h1(.text("Software engineering with Swift at the heart ❤️")),
                    .div(
                        .class("flex-container"),
                        .itemList(
                            for: context.allItems(
                                sortedBy: \.date,
                                order: .descending
                            ),
                            on: context.site
                        ),
                        .div(
                            .class("about"),
                            .ul(
                                .li(.img(.src(Path.forImage(named: "fotinha", withExtension: .jpg)))),
                                .li(.h3("About")),
                                .li(.p("Lucas Oliveira is a Software Engineer at iFood who enjoys sharing knowledge, iOS development, trying new frameworks and libraries, and recently is really excited about using Swift outside Apple platforms as well")),
                                .li(.h3("Social")),
                                SocialButtons.make()
                            )
                        )
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .wrapper(
                    .h1(.text(section.title)),
                    .itemList(for: section.items, on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        let paths: [Path] = [
            "/css/styles.css",
            "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css",
            "/css/highlight/styles/sunburst.css",
        ]
        return HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site, stylesheetPaths: paths),
            .body(
                .itemHeader(for: context.site),
                .class("item-page"),
                .wrapper(
                    .article(
                        .div(
                            .class("content"),
                            .text(item.date.toString),
                            .contentBody(item.body)
                        )
                    )
                ),
                .footer(for: context.site),
                .script(
                    .src("/css/highlight/highlight.pack.js")
                ),
                .script(
                    .src("https://getinsights.io/js/insights.js")
                ),
                .script(
                    """
                    hljs.initHighlightingOnLoad();
                    insights.init('p1qng0PUS7iZ0oX8');
                    insights.trackPages();
                    """
                )
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .wrapper(.contentBody(page.body)),
                .footer(for: context.site)
            )
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        return nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        return nil
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .p(
                        .markdown(item.description)
                    ),
                    .p(
                        .class("post-date"),
                        .text("Published at: \(item.date.toString)")
                    )
                ))
            }
        )
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .div(
                .ul(
                    SocialButtons.make()
                )
            ),
            .p(
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            ),
            .p(.a(
                .text("RSS feed"),
                .href("/feed.rss")
            ))
        )
    }
    
    static func itemHeader<T: Website>(for site: T) -> Node {
        return .div(
            .class("item-header"),
            .a(
                .text("Home"),
                .href(.home)
            )
        )
    }
}
