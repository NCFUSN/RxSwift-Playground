//: Playground - noun: a place where people can play

import UIKit
import RxCocoa
import RxSwift
import Foundation


/*
“Observable is just a sequence, with some special powers. One of them, in fact the most important one, is that it is asynchronous. Observables produce events, the process of which is referred to as emitting, over a period of time. ”

Excerpt From: By Marin Todorov. “RxSwift - Reactive Programming with Swift.” iBooks.
 
 */



func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "just, of, from") {
    
    // Creating observables
    
    let one = 1
    let two = 2
    let three = 3
    
    // observable value
    let observable: Observable<Int> = Observable<Int>.just(one)
    
    // observable values
    let observable2 = Observable.of(one, two, three)
    
    // observable array
    let observable3 = Observable.of([one, two, three])
    
    // “The from operator creates an observable of individual type instances from a regular array of elements.”
    let observable4 = Observable.from([one, two, three])
}

// Subscribing to observables. “an observable won’t send events until it has a subscriber”,“subscribing to an observable is really more like calling next() on an Iterator in the Swift standard library. Subscribe returns Disposable”

// similar to:

let sequence = 0..<3
var iterator = sequence.makeIterator()
while let n = iterator.next() {
    
    print(n)
}

example(of: "subscribe") {
    
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one, two, three)
    
    observable.subscribe { event in
        
        // get element
        if let element = event.element {
            
            print(element)
        }
    }
}

// get every element

example(of: "subscribe. get elements") {
    
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one, two, three)
    
    /*
    observable.subscribe { event in
        print(event)
    } */
    
    // use subscript
    
    observable.subscribe(onNext: { element in
        print(element)
    })
    
    observable
        .subscribe(
            onNext: {
                
                element in
                print(element)
        },
            onCompleted: {
                
                // onCompleted has no element
                print("Completed")
        }
    
    )
}

// never. “the never operator creates an observable that doesn’t emit anything and never terminates. It can be use to represent an infinite duration. ”

example(of: "never") {
    
    let observable = Observable<Any>.never()
    observable
    .subscribe(
        onNext: { element in
            print(element)
    },
        onCompleted: {
            
            print("Completed")
    })
}

// Disposing and terminating

// “Remember that an observable doesn’t do anything until it receives a subscription. It’s the subscription that triggers an observable to begin emitting events, up until it emits an .error or .completed event and is terminated. You can manually cause an observable to terminate by canceling a subscription to it.

example(of: "dispose") {
    
    let observable = Observable.of("A", "B", "C")
    let subscription = observable.subscribe {
        
        event in
        print(event)
    }
    subscription.dispose()
}

example(of: "DisposeBag") {
    
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C")
        .subscribe {
            print($0)
    }
    .disposed(by: disposeBag)
}

// “Why bother with disposables at all? If you forget to add a subscription to a dispose bag, or manually call dispose on it when you’re done with the subscription, or in some other way cause the observable to terminate at some point, you will probably leak memory”

// “Another way to specify all events that an observable will emit to subscribers is by using the create operator.”

// “The create operator takes a single parameter named subscribe. Its job is to provide the implementation of calling subscribe on the observable. In other words, it defines all the events that will be emitted to subscribers. Option-click on create.”

example(of: "create") {

let disposeBag = DisposeBag()
Observable<String>.create { observer in
    
    observer.onNext("1")
    observer.onCompleted()
    observer.onNext("?")
    return Disposables.create()
    }
    
    .subscribe(
    
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
    )
    .disposed(by: disposeBag)
}

// Observable factories

example(of: "deferred") {
    
    let disposeBag = DisposeBag()
    var flip = false
    let factory: Observable<Int> = Observable.deferred {
        flip = !flip //inverting
        if flip {
            
            return Observable.of(1,2,3)
            
        } else {
            
            return Observable.of(4,5,6)
        }
    }
    
    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
        .disposed(by: disposeBag)
        print()
    }
}

// Using Traits

// “Traits are observables with a narrower set of behaviors than regular observables. Their use is optional; you can use a regular observable anywhere you might use a trait instead. Their purpose is to provide a way to more clearly convey your intent to readers of your code or consumers of your API. The context implied by using a trait can help make your code more intuitive.”

// “There are three kinds of traits in RxSwift: Single, Maybe, and Completable.”

// “Singles will emit either a .success(value) or .error event. .success(value) is actually a combination of the .next and .completed events.”

// “This is useful for one-time processes that will either succeed and yield a value or fail, such as downloading data or loading it from disk.”

// “A Completable will only emit a .completed or .error event. It doesn't emit any value.”

// “You could use a completable when you only care that an operation completed successfully or failed, such as a file write.”

// “And Maybe is a mashup of a Single and Completable. It can either emit a .success(value), .completed, or .error. If you need to implement an operation that could either succeed or fail, and optionally return a value on success, then Maybe is your ticket.”

example(of: "Single") {
    
    let disposeBag = DisposeBag()
    enum FileReadError: Error {
        
        case notFound, unreadable, encodingFailed
    }
    
    func loadText(from name: String) -> Single<String> {
        return Single.create { single in
            
            let disposable = Disposables.create()
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                
                single(.error(FileReadError.notFound))
                return disposable
            }
            
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            guard let contents = String(data: data, encoding: .utf8) else {
                
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            
            single(.success(contents))
            return disposable
        }
    }
    
    loadText(from: "Copyright")
        
        .subscribe {
        
        switch $0 {
        case .success(let string):
        print(string)
        case .error(let error):
        print(error)
        }
    }
        .disposed(by: disposeBag)
}



