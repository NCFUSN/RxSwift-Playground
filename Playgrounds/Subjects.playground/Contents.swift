//: Playground - noun: a place where people can play

import UIKit
import RxCocoa
import RxSwift
import Foundation

// What are subjects?

// “Subjects act as both an observable and an observer. ”. “There are four subject types in RxSwift: “PublishSubject: Starts empty and only emits new elements to subscribers. “BehaviorSubject: Starts with an initial value and replays it or the latest element to new subscribers.” “ReplaySubject: Initialized with a buffer size and will maintain a buffer of elements up to that size and replay it to new subscribers.” “Variable: Wraps a BehaviorSubject, preserves its current value as state, and replays only the latest/initial value to new subscribers.”

func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "PublishSubject") {
    
    // create a PublishSubject. “it will receive information and then turn around and publish it to subscribers, possibly after modifying that information in some way first.” “After being initialized, it’s ready to receive some.”
    
    let subject = PublishSubject<String>()
    
    // “This puts a new string onto the subject. But nothing is printed out yet, because there are no observers.”
    
    subject.onNext("Is anyone listening?")
    
    // “created a subscription to subject just like in the last chapter, printing .next events.”
    
    let subscriptionOne = subject
        .subscribe(onNext: { string in
            print(string)
    })
    
    // “because you defined the publish subject to be of type String, only strings may be put onto it. Now, because subject has a subscriber”. “add a new .next event onto a subject, passing the element as the parameter”
    
    subject.on(.next("1"))
    // --> Shortcut
    subject.onNext("2")
}

