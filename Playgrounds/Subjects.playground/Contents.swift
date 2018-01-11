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
    
    // “Publish subjects come in handy when you simply want subscribers to be notified of new events from the point at which they subscribed, until they either unsubscribe, or the subject has terminated with a .completed or .error event.”
    
    let subscriptionTwo = subject
        .subscribe { event in
            print("2)", event.element ?? event)
    }
    subject.onNext("3")
    subscriptionOne.dispose()
    subject.onNext("4")
    
    //1. “This effectively terminates the subject’s observable sequence.”
    subject.onCompleted()
    
    //2 “This won’t be emitted and printed, though, because the subject has already terminated.”
    subject.onNext("5")
    
    //3 “Don’t forget to dispose of subscriptions when you’re done!”“Maybe the new subscriber 3) will kickstart the subject back into action? Nope, but you do still get the .completed event.”
    subscriptionTwo.dispose()
    let disposeBag = DisposeBag()
    
    //4 “Create a new subscription to the subject, this time adding it to a dispose bag.”
    subject
        .subscribe {
            print("3)", $0.element ?? $0)
    }
    .disposed(by: disposeBag)
    subject.onNext("?")
}

enum MyError: Error {
    
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    
    print(label, event.element ?? event.error ?? event)
}

example(of: "BehaviorSubject") {
    
    // “Since BehaviorSubject always emits the latest element, you can’t create one without providing a default initial value. If you can’t provide a default initial value at creation time, that probably means you need to use a PublishSubject instead.”
    
    let subject = BehaviorSubject(value: "Initialvalue")
    let disposeBag = DisposeBag()
    subject.onNext("X")
    
    subject
        .subscribe {
            print(label: "1)", event: $0)
    }
    .disposed(by: disposeBag)
    
    subject.onError(MyError.anError)
    subject
        .subscribe {
            print(label: "2)", event: $0)
    }
    .disposed(by: disposeBag)
}

// “Working with replay subjects”

// “Keep in mind when using a replay subject that this buffer is held in memory. You can definitely shoot yourself in the foot here, such as if you set a large buffer size for a replay subject of some type whose instances each take up a lot of memory, like images. ”

// “Another thing to watch out for is creating a replay subject of an array of items. Each emitted element will be an array, so the buffer size will buffer that many arrays. It would be easy to create memory pressure here if you’re not careful.”

example(of: "ReplaySubject") {
    
    // “create a new replay subject with a buffer size of 2. Replay subjects are initialized using the type method create(bufferSize:).”
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBage = DisposeBag()
    
    // “Add three elements onto the subject.”
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    // “Create two subscriptions to the subject.”
    subject
        .subscribe {
            print(label: "1)", event: $0)
    }
    .disposed(by: disposeBage)
    
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBage)
    
    subject.onNext("4")
    
    subject
        .subscribe {
            print(label: "3)", event: $0)
    }
    .disposed(by: disposeBage)
    
    subject.onError(MyError.anError)
    subject.dispose()
}

// Working with variables

// “Variable wraps a BehaviorSubject and stores its current value as state. You can access that current value via its value property, and, unlike other subjects and observables in general, you also use that value property to set a new element onto a variable. In other words, you don’t use onNext(_:).”

// “Because it wraps a behavior subject, a variable is created with an initial value, and it will replay its latest or initial value to new subscribers. In order to access a variable’s underlying behavior subject, you call asObservable() on it.”

// “Also unique to Variable, as compared to other subjects, is that it is guaranteed not to emit an error. So although you can listen for .error events in a subscription to a variable, you cannot add an .error event onto a variable. A variable will also automatically complete when it’s about to be deallocated, so you do not (and in fact, cannot) manually add a .completed event to it.”

example(of: "Variable") {
    
    // 1
    
    // “Create a variable with an initial value. The variable’s type is inferred, but you could have explicitly declared the type as Variable<String>("Initial value").”
    
    let variable = Variable("InitialValue")
    let disposeBag = DisposeBag()
    
    // 2 “Add a new element onto the variable.”
    
    variable.value = "New Initial value"
    
    // 3 “Subscribe to the variable, first by calling asObservable() to access its underlying behavior subject.”
    
    variable.asObservable()
        .subscribe {
            print(label: "1", event: $0)
    }
    .disposed(by: disposeBag)
    
    // 1
    variable.value = "1"
    // 2
    variable.asObservable()
        .subscribe {
            print(label: "2)", event: $0)
    }
    .disposed(by: disposeBag)
    // 3
    variable.value = "2"
    
}


















