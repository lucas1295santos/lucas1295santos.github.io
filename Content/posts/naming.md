---
date: 2020-11-14 00:00
description: Naming is one of the most underrated and overlooked skills that a good programmer should have, yet is a skill that we use every day by giving names to variables, functions, services, and so on. Good names make messy code easier to understand, and makes good code a delight to read. In this post, I'll share some insights on how to detect bad naming, and how to improve it.
---
# A reflection about code quality

Naming is one of the most underrated and overlooked skills that a good programmer should have, yet is a skill that we use every day by giving names to variables, functions, services, and so on. Good names make messy code easier to understand, and makes good code a delight to read. In this post, I'll share some insights on how to detect bad naming, and how to improve it.

During my years at the academy studying software engineering I invested a lot of time and effort in problem-solving skills, thinking about the Object-Oriented modeling, the data structures that would be employed, the efficiency of the algorithms, and the data types on each variable. And it was time really well spent, those decisions are really important and complex, so to get it right, you should practice a lot. But during all that time, I never had a professor saying to me that I should think about the names I'd use in my code. Maybe that's because when you are an undergraduate, the code you write is not meant to last. Once the assignment is done, you'll never see it again.

When you code professionally, most of the time you'll extend and modify code that other people wrote, and the code that you write is going to be extended and modified by other people. Furthermore, your code is meant to last because you are creating a valuable asset to the company. This is the turning point where you have to understand that the code you write is for both humans and machines.

In the industry, code that successfully compiles and attend to the requisites is not enough, the code needs to be readable. Unreadable code is objectively worst, because in the future a developer will spend a lot of time understanding the unreadable code before even beginning to modify it, and that means developer time and effort being wasted.

Last, think about all the times you were in the situation of having to jump headfirst on a messy code to solve some problem, it is never a pleasant experience. As developers, we are the ones to blame when code gets that bad, and we are the ones that can improve it.

# Signs of bad naming

A few Saturdays ago I was on a software engineering lecture implementing a [Josephus Problem](https://en.wikipedia.org/wiki/Josephus_problem) empirical algorithm along with the professor, and I and my classmates were having a hard time understanding the rationale behind the implementation, and to explain that, followed a long and confusing discussion about the strategy behind the implementation in terms of variables like `n` `k` and `curVal`. Meanwhile, I was wondering how much shorter the discussion would be if the variables were named after what they represented.

Next, we'll take a look at how good naming would make the Josephus Problem implementation way easier to understand. If you already know the problem, just skip to the implementation, if not, I'll give a brief explanation.

### Josephus Problem explanation

Captured soldiers are put on a circle to be executed. The executioner will pick a number and will start counting the captured soldiers around the circle in a specific direction. When he gets to the selected number, the soldier being counted gets executed. The process will repeat until there is only one soldier left in the circle, this last soldier gets freed. For a more in-depth study on the problem, go to [GeoGebra](https://www.geogebra.org/m/ExvvrBbR), they even have a didactic video and simulation of it.

### Josephus Problem implementation

The following implementation written in Java was the empirical implementation provided by the professor.

```swift
class JosephusProblem {
    var n: Int
    var k: Int
    var circle: [Bool] = []
    var alive: Int = 0
    var curVal: Int = 0

    init(n: Int, k: Int) {
        self.n = n
        self.k = k
        start()
    }

    func start() -> Int {
        circle = []
        for _ in 0 ..< n {
            circle.append(true)
        }
        alive = n
        curVal = 0
        return curVal
    }

    func next() -> Int {
        if (alive == 0) {
            return -1
        }
        for _ in 0 ..< k {
            repeat {
                curVal = (curVal + 1) % n
            } while (!circle[curVal])
        }
        circle[curVal] = false
        alive -= 1
        return curVal
    }

    func print(n: Int) -> String {
        var progression = ""
        for _ in 0 ..< n {
            progression.append(" ")
            progression.append(String(next()))
        }
        return progression
    }
}
```

Executing the function `print` after inciating with parameters `JosephusProblem(8, 2)` would display the output:

```
 2 4 6 0 3 7 5 1
```

Meaning that the soldiers would be executed starting by the one at position 2, in that order, until the one at position 1 is freed.

Was it easy to understand how the code above implements a possible solution to the problem? The first time I read it, it wasn't easy. To help myself understand, I renamed all the variables and functions like this:

```swift
class JosephusProblem {
    var numberOfSoldiers: Int
    var countingConstant: Int
    var soldierStatus: [SoldierStatus] = []
    var numberOfSoldiersAlive: Int = 0
    var currentSoldierPosition: Int = 0

    init(numberOfSoldiers: Int, countingConstant: Int) {
        self.numberOfSoldiers = numberOfSoldiers
        self.countingConstant = countingConstant
        setUp()
    }

    func setUp() -> Int {
        soldierStatus = []
        for _ in 0 ..< numberOfSoldiers {
            soldierStatus.append(.alive)
        }
        numberOfSoldiersAlive = numberOfSoldiers
        currentSoldierPosition = 0
        return currentSoldierPosition
    }

    func getNextExecutedSoldierPosition() -> Int {
        if (numberOfSoldiersAlive == 0) {
            return -1
        }
        for _ in 0 ..< countingConstant {
            repeat {
                currentSoldierPosition = (currentSoldierPosition + 1) % numberOfSoldiers
            } while (soldierStatus[currentSoldierPosition] == .dead)
        }
        soldierStatus[currentSoldierPosition] = .dead
        numberOfSoldiersAlive -= 1
        return currentSoldierPosition
    }

    func getNextExecutions(numberOfExecutions: Int) -> String {
        var executions = ""
        for _ in 0 ..< numberOfExecutions {
            executions.append(" ")
            executions.append(String(getNextExecutedSoldierPosition()))
        }
        return executions
    }
}

enum SoldierStatus {
    case dead
    case alive
}
```

Notice how easier the code got only by renaming variables and functions. No logic was modified and yet some complexity vanished. Let's go through the major renames that got the code easier to understand.

### Use contextual names

Renaming `n` to `numberOfSoldiers` and `k` to `countingConstant` and `curVal` to `currentSoldierPosition` added context to the algorithm, and that is super valuable as it makes the code intuitive.

```swift
// Consider the code bellow that is part of the class initialization
// Before naming refactor
circle = []
for _ in 0 ..< n {
    circle.append(true)
}
// After naming refactor
soldierStatus = []
for _ in 0 ..< numberOfSoldiers {
    soldierStatus.append(.alive)
}
```

Reading this expression before the refactor you may need to go further in inspecting the code to check what is `n`, and to understand what are the boolean values on `circle` so we can know what does it mean to have a `circle` full of *true* values.

After the refactor the code kind of explains itself. And that's beautiful!

### Use enums to give even more context

Enums are one of the most powerful features in Swift, and they are awesome to improve code clarity and readability because you can name each case according to a state from the application using problem domain-specific language.

```swift
// Before refactor
while (!circle[curVal])
// After refactor
while (soldierStatus[currentSoldierPosition] == .dead)
```

# Good practices in naming

Now that you got a pretty good idea on why naming matters, the next natural question is: "how would I choose good names?" - I'll show you a handful of good practices and principles to choose good names, but mostly you'll have to figure it out case by case. But if you ever find yourself in doubt, you can always figure if your naming is bad by showing your code to peers.

Remember that you are writing code that other humans will read, reuse, extend, modify or, even delete. So always aim for following these general rules:

* Intent revealing: your code should make explicit what it does.
* Accurate: choosing names that imply that the code does something that it doesn't is the same as setting up a trap.
* Consistent: consistent names make it easier to find patterns and deduce behavior. If you have three functions that just return a value, don't call them `getX`, `retrieveY`, and `fetchZ`. People will assume that they do three different things, so choose a pattern and stick with it.

### Conform to language/framework standards

You are sharing the codebase with fellow developers that are used to the project's language and framework standards, being from reading docs, open-source projects, or previous work experience. Conforming to those standards allows the developers to benefit from this experience to accelerate their understanding of the code.

Usually, it is easy to find the language standards documents. You can read Swift's naming standards on the [Swift API guidelines](https://swift.org/documentation/api-design-guidelines/#naming).

### Don't abbreviate

Abbreviations might seem obvious to whoever created it, or to the team that is immersed in the context of the code, but for a new-comer or an outsider, abbreviated names may mean nothing. Furthermore, by abbreviating you are not even gaining much, because we all work with IDEs with auto-completion enabled, so if the name of your class is long, you'll probably just type the first 4 letters and auto-complete the rest of it. The only exception is when you are naming after broadly known abbreviations like `UI`. It is safe to assume that any mobile or web developer knows what a `UI` is.

### Use verbs for functions

Functions are encapsulated actions that your program can perform, so by definition, you should name them as verbs. By doing this, you are improving readability by making the code syntax feel more natural.

```swift
func fetchOrder(by: , completion: )
func setupLayout()
func dequeue() -> Value?
```

### Name the design patterns you use

If you are using the delegate pattern to solve the communication between a payments view and its controller, don't try to reinvent the wheel, and simply name the protocol as `PaymentsViewDelegate`. The next developer who reads this code, probably knows what a delegate is and how it works, and just like this, he can skip reading the full implementation, because he already has a pretty good idea on where to go next. Conversely, if the implementation feels like a design pattern, but is not, do not name it after the design pattern, else you are setting up a trap for someone else in the future.

### Show your code to peers

Sometimes it is really hard to choose a good name, and showing the code to someone that is not as immersed and biased on the subject as you are, might help a lot. Even the simple exercise of reading the code out loud will make bad naming clearer.

A great way of sharing the code with peers is by reading the code out loud and explaining how it works, the effort of contextualizing the problem and explaining the solution bit by bit may give you good insights. Pair programming also helps a lot, as often developers disagree with naming choices, leading to a rich discussion. And my favorite method is doing a pair code review, where you open a draft pull request and review the code along with one or more teammates, there are always lots of insights and suggestions of improvement.

 ### Go beyond this article

Here are some great resources that helped me be better at naming in software, and were inspirations for this article:
* Good motivation on why you should care about naming, and its general principles by Gergely Orosz from the Pragmatic Engineer. [Read the post!](https://blog.pragmaticengineer.com/readable-code)
* The section *Naming Things* from chapter 7 of *The Pragmatic Programmer* provides good examples, and questions that you should be doing while renaming code. [Buy it on Amazon!](https://ler.amazon.com.br/kp/embed?asin=B07VRS84D1&preview=newtab&linkCode=kpe&ref_=cm_sw_r_kb_dp_W89RFbA9SYG0F)
* Chapter 2 *Meaningful names* from *Clean Code* is also a great reference, and was the chapter that made me realize the importance of taking the time and effort to name software. [Buy it on Amazon!](https://ler.amazon.com.br/kp/embed?asin=B001GSTOAM&preview=newtab&linkCode=kpe&ref_=cm_sw_r_kb_dp_cf-RFbNB5S5HN)