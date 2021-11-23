![Refactoring](refactoring/cover.jpeg)

# Refactoring

If you never heard the word refactoring before, the [wikipedia definition for it](https://en.wikipedia.org/wiki/Code_refactoring) is a good place to start: _code refactoring is the process of restructuring existing computer code without changing its external behavior. Refactoring is intended to improve the design, structure, and/or implementation of the software (its non-functional attributes) while preserving its functionality_. Even without knowing this definition, you are likely already applying refactoring every now and then, being renaming variables, extracting blocks of code to functions, extracting methods to classes, or modularizing classes that belong together to their own package.

## Refactor cost

Although refactoring is a positive thing, as its objective is to improve the quality of the target code, refactoring a piece of code is not always feasible.

Refactoring has a significant cost because it demands developer working hours that won't translate directly into business impact: new functionalities, enabling new businesses, improvements on user experience. Instead, the impact of refactoring is indirect, and will only make a difference in the long run when developers will have an easier time changing that code, resulting in fewer bugs and faster deliveries. And even then, it might go under the radar if people are unable to correlate the success of the team to this well-laid foundation that was crafted in the past, so be sure to mention it to the team, and give credit where credit is due.

The software we write (mostly) has the objective to enable a business, thus the time and money available for the crafting of this software are constrained by the available budget and market timings related to the business's products. The nature of this relation will create cycles where functionality is rapidly added and technical debt is accumulated, and cycles where technical debt must be paid for and functionality can't be added as quickly.

Even with good and well-defined architecture, an efficient process of code-review in place, a coherent code style, and developers applying all the good coding practices, technical debt will still be created as features are added and evolved, but the debt will grow slower than it would if you didn't care about code quality. In the end, the good practices are there to slow down the increase of debt, so the happy cycle where functionality can be added blazing-fast lasts longer.

All in all, refactoring involves a trade-off between velocity now and velocity in the long term. And it is our responsibility as developers to continuously evaluate this trade-off, communicate it to the stakeholders, and when necessary, advocate for large refactors. Martin Fowler has written an awesome article about this subject called [Is High Quality Software Worth the Cost?](https://www.martinfowler.com/articles/is-quality-worth-cost.html), that in my opinion is a must-read for every software engineer and software engineering manager.

---

Albeit having described accumulating and paying the techicall debt as cycles, most of the time it won't happen as discretely as that. Stopping a whole product development team for an extensive period to work exclusively on code quality improvements is less than desirable, and for startups with smaller teams, it may not even be possible to do so.

With time, as code quality decays, features take longer to be implemented, tasks are forever postponed because of technical limitations, bugs occur frequently, and fixing then seems beyond hope as more will just pop out. This can easily become a vicious cycle as the developers will only make the code even worse by adding more and more stuff to it, and doing all kinds of quick-fixes and workarounds ([gambiarra](https://www.urbandictionary.com/define.php?term=Gambiarra) as we say in Brazil) to get things done. Sometimes the only way out of this messy code swamp is to go for a total rewrite and start all over again in a clean sheet, but as we all know this is tough.

Not only a big rewrite is a lot of work, but it can also be a big hit to the team morale as the pressure to finish it fast and start shipping new features mounts.

## Maintaining code quality

The ideal way to go about it is to never let things get so far out of hand to get to this doomed code state. Continous refactor and caring will go a long way to maintain the code in good quality. Of course, that doesn't mean that you'll never have to engage in a huge refactor or a rewrite again, sometimes the business evolves in a way that requirements change or takes gigantic proportions that weren't planned, and that's all fair and square.

The book [The Pragmatic Programmer](https://www.amazon.com/Pragmatic-Programmer-journey-mastery-Anniversary/dp/0135957052) has a section about Software Entropy, and they make a beautiful analogy that bad code is like a building with broken windows. The feeling of abandonment will quickly spread among the developers, in a way that no one will try to repair it, or even take care to not damage it further. The remedy proposed by the authors is to not leave broken windows: fix issues as soon as you see them, or at least document the flaws and work on them later (later in this context means _asap_, not never). It is important to make a statement that that codebase is not abandoned.

Most of the refactoring is better done alongside _product-driven_ tasks. You can utilize that you are working on a context anyway, and improve it by refactoring the bits that you found hard to understand, or that weren't flexible enough to accommodate your new use-case.

The book [Clean Code](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) makes a simple analogy to this attitude comparing it to a Boy Scout rule to always leave the camp cleaner than found. With enough people with this mindset, code quality can be improved over time.

## Healthy team, healthy code

Keeping a healthy codebase is not a task to be tackled by an individual, refactoring messy chunks of code may be impossible without a supporting team. The improvements made by one person can be quickly dimmed by other developers going in the opposite direction.

To be able to engage and keep developers comfortable in taking code quality seriously, it is important to have the whole team stand by it.

The engineering team should be supporting each other by reviewing code, designing solutions together, pair programming, keeping track of technical debt, and backing each other up to keep the shipping business impact while making code refactors.

Management has to be understanding by giving the development team the time and space necessary to keep deliverying at high quality and to shield the team from unnecessary feature demands.

Product managers and designers have to be aware of technical complexity and be versatile to keep balance on what is an amazing product and what is simple to develop.

## Takeaways

- Code decays even if you are in a really good team with an excellent tech stack, routine refactoring (housekeeping) is part of the job.
- It's easier and safer to change good code, so refactoring is not a waste of time, it is an investment of it.
- Your non-technical colleagues may be unaware of the importance of refactoring. Explain to them how flexible and scalable the code became, praise your teammates when they do take on a refactoring quest.
- Constantly improving code quality is easier than rewriting it every now and then.
- Maintaining a health codebase is a collective challenge; keeping the team engaged in applying good practices, code reviewing, refactoring, and so on, is as important (if not more) as the technical side of it.

## Beyond this article

Refactoring is a broad subject, so I'll be writing more about it. Next time, I'll go about hands-on refactoring techniques.

The book [Refactoring Improving the Design of Existing Code](https://martinfowler.com/books/refactoring.html) from Martin Fowler and Kent Beck is one of the main references on refactoring. For a bitesize read, [Refactoring Guru](https://refactoring.guru/refactoring) has awesome, easy to understand and applicable tips and tricks.

## Thanks for reading!

Liked this content? Follow me on [Twitter](https://twitter.com/oliveira__lucas) and be the first to know about new articles. Suggestions, feedback, and corrections are always welcome.
