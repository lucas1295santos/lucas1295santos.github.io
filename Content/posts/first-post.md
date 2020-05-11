---
date: 2020-04-20 00:00
description: Recently, I discovered [Publish](https://github.com/johnsundell/publish), a static website generator that uses Swift, written by [John Sundell](https://swiftbysundell.com).<br></br> The main idea is to declare all the pieces of your website like a *Swift Package*, and then using [Plot](https://github.com/JohnSundell/Plot) to generate HTML code using the type-safety of Swift, and finally using [Ink](https://github.com/JohnSundell/Ink) to render posts written in **Markdown**. (like this one!) <br></br> It may sound like a lot of tools to handle, but in reality, Publish already does most of the work for you.

---
# This blog is written in Swift!

Recently, I discovered [Publish](https://github.com/johnsundell/publish), a static website generator that uses Swift, written by [John Sundell](https://swiftbysundell.com). The main idea is to declare all the pieces of your website like a *Swift Package* and then using [Plot](https://github.com/JohnSundell/Plot) to generate HTML code using the type-safety of Swift, and finally using [Ink](https://github.com/JohnSundell/Ink) to render posts written in **Markdown**. (like this one!)  It may sound like a lot of tools to handle, but in reality, Publish already does most of the work for you.

Before digging into how Publish works, I highly recommend that you read the README of [Publish's Github](https://github.com/johnsundell/publish) to have an overview on the framework, and all the step-by-step of how to **install** and **setup** a starter project.

 It is worth noting that there you can find a **HowTo** folder where the community registers how to do things that they struggled at first but then figured it out.

## Files structure

<img src="https://raw.githubusercontent.com/lucas1295santos/lucas1295santos.github.io/master/images/post1_img1.png" alt="File structure" style="width:200px;"/>

When you start a new **Publish** website, it will create a file structure like the one above. The first thing we'll do is to understand what is the basic website generated.

- *Package.swift* is a file where you should declare dependencies for your project. If you never worked with Swift Package Manager, you can think of this file as a *Podfile* where you declare the *Cocoa pods* that you want to import. You also can learn more at this great article at [Swift by Sundell](https://www.swiftbysundell.com/articles/managing-dependencies-using-the-swift-package-manager/).

- *Content* is where you'll add posts, audio, video, or any type of content your website is about. This very blog post is currently in this folder.

- *Output* folder is generated after you run `publish generate`, and **this is the actual website**. You shouldn't really code or add anything here, Publish will generate everything when you use the `generate` command.

- *Resources* folder is where you can store assets that your pages will use, and **CSS** styles as well. Currently, I have a *images* and *css* folders here. The image of the file structure above is stored int this folder.

- *Sources* folder is where you'll code! Currently, there is a folder with your project's name and a `main.swift` inside.

## main.swift

This file declares your website through a structure that implements `Website`, and defines the publishing steps for it.

``` swift
struct Bla: Website {
    // Website configurations go here
}
```

And outside of the Website defining structure, you'll have the publish step. This is what will be executed on `publish deploy`.

``` swift
try Bla().publish(
  withTheme: .custom,
  additionalSteps: [
    .deploy(using: .git("git@github.com-lucas1295santos:lucas1295santos/lucas1295santos.github.io.git"))
  ]
)
```

On the example above I did a really basic publish workflow, where I use **Github Pages** to host this website and make it available at this domain. I also declare that I want to use a theme called `custom` to render this website (I'll talk about that in a bit). But this can easily become a robust deployment pipeline if your website needs to.

``` swift
try Bla().publish(using: [
    .step1(),
    .step2(),
    .step3()
])
```

## Custom theme

To give your website some visual identity, you'll probably want to not use the default theme and create your own. I do this by instantiating a new `Theme` passing a `HTMLFactory` and the **CSS** resources that I'll use, making it available as a static variable of `Theme` just to make it easily accessible on my **main.swift**.

``` swift
extension Theme {
    static var custom: Self {
        Theme(
            htmlFactory: CustomHTMLFactory(),
            resourcePaths: ["Resources/css/styles.css"]
        )
    }
}
```

The `CustomHTLMFactory` on the code above is an implementation of the `HTMLFactory` protocol that generates the HTML layout for each piece of the website.

``` swift
private struct CustomHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {}
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {}
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {}
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {}
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {}
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {}
}
```

I'll not dig any deeper on how to use **Plot** to create the HTML layout required on each method from `HTMLFactory`, but I highly recommend that you take a look at the implementation of the `foundation` theme (the one that comes with **Publish**) at the file `Theme+Foundation.swift` on the `Publish` package. Copy it, try to change it a little bit, and you will get a hang on how it works in no time (especially if you know any HTML).

## Wrapping up

I'm excited about this framework, and it's being a joy to work with it! And I'm still learning everything that it can do, so I'll post more about it as I learn.

I Hope that this post gives you a good idea of what it is, and how to get started. And besides the documentations that I referenced throughout the post, you might want to check out [this hands-on video](https://youtu.be/JqdS-oi96Gk) from Kilo Loco about getting started on Publish. 

Thank you for reading, take care, and good coding!