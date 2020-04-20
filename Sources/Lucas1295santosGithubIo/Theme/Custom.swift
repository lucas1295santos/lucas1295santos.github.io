import Plot
import Publish

extension Theme {
    /// The default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
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
        let paths: [Path] = ["/css/styles.css", "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"]
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
        let paths: [Path] = ["/css/styles.css", "/css/highlight/styles/sunburst.css"]
        return HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site, stylesheetPaths: paths),
            .body(
                .script(
                    .src("/css/highlight/highlight.pack.js")
                ),
                .script(
                    "hljs.initHighlightingOnLoad();"
                ),
                .class("item-page"),
                .wrapper(
                    .article(
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        )
                    )
                ),
                .footer(for: context.site)
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

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )
        )
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
}
