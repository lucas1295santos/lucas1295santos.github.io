---
date: 2020-05-24 00:00
description: I'm on a quest to study data structures in Swift, and one really cool feature that Swift arrays implement is copy-on-write!
---
# Quick tip #1: Array copy-on-write

I'm studying data structures, and its implementations in Swift following the Udacity course [Data Structures & Algorithms in Swift](https://www.udacity.com/course/data-structures-and-algorithms-in-swift--ud1011) (I'm on early lessons, but from what I've seen so far, I recommend it). And one really nice thing that I learned on the arrays lesson, is that Swift arrays implement copy-on-write. But what does that mean?

Copy-on-write is a pattern that aims to save storage or memory allocation whenever it is possible by delaying copying a resource as long as it is possible. The copy only happens when someone writes on that resource, in other words, when someone edit, delete or add any information to it.

It is way easier to understand with some code, so here it goes.
``` swift
var originalArray = [1,2,3]
var copyArray = originalArray

originalArray.withUnsafeBufferPointer { (pointer) in
  print("originalArray: \(pointer)")
}
copyArray.withUnsafeBufferPointer { (pointer) in
  print("copyArray: \(pointer)")
}

print("Editing copyArray...")
copyArray[2] = 20

originalArray.withUnsafeBufferPointer { (pointer) in
    print("originalArray: \(pointer)")
}
copyArray.withUnsafeBufferPointer { (pointer) in
    print("copyArray: \(pointer)")
}
```
In the example above, I use [withUnsafeBufferPointer](https://developer.apple.com/documentation/swift/array/2994771-withunsafebufferpointer) to get access to the pointer of the starting address of the array.
When the code is executed, it outputs the following:
```
originalArray: UnsafeBufferPointer(start: 0x0000600002ca3320, count: 3)
copyArray: UnsafeBufferPointer(start: 0x0000600002ca3320, count: 3)
Editing copyArray...
originalArray: UnsafeBufferPointer(start: 0x0000600002ca3320, count: 3)
copyArray: UnsafeBufferPointer(start: 0x0000600002cd95a0, count: 3)
```
You can see that prior to the edition of `copyArray` both arrays are stored at the same memory address, and only after I did a write operation on it all the values from `originalArray` were copied over to another memory address, so than the copy could be edited without changing anything at the original.

Since this all happens under the hood, in most cases it makes no practical difference if you are aware of this language characteristic. But maybe you have a really specific situation where you want to give more context to the code by reassigning one array to a different name, and now you know that you will be paying basically nothing for it in terms of memory usage.

Thank you for reading, take care, and good coding!