---
date: 2020-04-20 00:00
description: Recently, I discovered [Publish](https://github.com/johnsundell/publish), a static website generator that uses Swift, written by [John Sundell](https://swiftbysundell.com).<br></br> The main idea is to declare all the pieces of your website like a *Swift Package*, and then using [Plot](https://github.com/JohnSundell/Plot) to generate HTML code using the type-safety of Swift, and finally using [Ink](https://github.com/JohnSundell/Ink) to render posts written in **Markdown**. (like this one!) <br></br> It may sound like a lot of tools to handle, but in reality, Publish already does most of the work for you.

---
# This blog is written in Swift!

Recently, I discovered [Publish](https://github.com/johnsundell/publish), a static website generator that uses Swift, written by [John Sundell](https://swiftbysundell.com).<br></br> The main idea is to declare all the pieces of your website like a *Swift Package*, and then using [Plot](https://github.com/JohnSundell/Plot) to generate HTML code using the type-safety of Swift, and finally using [Ink](https://github.com/JohnSundell/Ink) to render posts written in **Markdown**. (like this one!) <br></br> It may sound like a lot of tools to handle, but in reality, Publish already does most of the work for you.

Before digging in how Publish works, I highly recommend that you read the README of [Publish's Github](https://github.com/johnsundell/publish) to have an overview on the framework, and all the step-by-step on how to **install** and **setup** a starter project.

 It is worth to note that there you can find a **HowTo** folder where the community register how to do things that they struggled at first, but then figured it out.

## Files structure

![alt text](https://raw.githubusercontent.com/lucas1295santos/lucas1295santos.github.io/master/images/post1_img1.png "Starter project file structure")

When you start a new publish website, it will create a file structure like the one above. The first thing we'll do, is to understand what is the basic website generated.

- *Package.swift* is a file where you should declare dependencies for your project. If you never worked with Swift Package Manager, you can think of this file as a *Podfile* where you declare the *Cocoa pods* that you want to import. You also can learn more at this great article at [Swift by Sundell](https://www.swiftbysundell.com/articles/managing-dependencies-using-the-swift-package-manager/).

- *Content* is where you'll add posts, audio, video or any type of content your website is about. This very blog post is currently on this folder.

- *Output* folder is generated after you run `publish generate`, and **this is the actual website**. You shouldn't really code or add anything here, Publish will generate everything when you use the `generate` command.

- *Resources* folder is where you can store assets that your pages will use, and `css` styles as well. Currently I have a *images* and *css* folders here. The image of the file structure above is stored at this folder.

- *Sources* folder is where you'll actually code! Currently there is a folder with your project's name, and a `main.swift` inside.

## main.swift

This files declares your website, and defines the publishing steps for it.

First, you should have a structure like it shows above. On this structure you will make general configurations.

``` swift
var url = URL(string: "https://your-website-url.com")!
var name = "Bla"
var description = "A description of Bla"
var language: Language { .english }
```


``` swift
struct Bla: Website {

}
```

![alt text](https://raw.githubusercontent.com/lucas1295santos/lucas1295santos.github.io/master/images/post1_img2.gif "sections dogs and cats")
