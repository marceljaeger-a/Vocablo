# How to use ActionReactingService

An article that explain how the Service works and how you use it.

@Metadata {
    @Available(macOS,introduced: "14.0")
    @SupportedLanguage(swift)
    @PageColor(blue)
}

## Overview

This API is built for reacting to some actions of your app like **adding** a new ``Vocabulary``. 

It uses Combine and SwiftUI for its functionality:

- PassthroughSubject
- EnvrionmentValue
- View Modifier

### Creating a new Publisher for an Action

The ``ActionReactingService`` class defines instance properties those represent the publisher for specific actions. You create a new publisher with the ``ActionPublisher`` protocol.

```swift
struct AddingVocabularPublisher: ActionPublisher {
    
    typealias SubjectResult = Vocabulary

    var subject: ActionSubject = PassthroughSubject()

}
```

The protocol uses a PassthroughSubject and defines the generic type based on the ``ActionPublisher/SubjectResult`` which represent the **result** and based on the ``ActionPublisher/SubjectFailure`` which represent the **error** and which is **Never**.

You can create an instance of this structure and subscribe to a Subscriber. The ``ActionPublisher`` protocol defines the ``ActionPublisher/send(_:)-6b7ix`` methode which sends a value to the ``ActionPublisher/subject``, so all Subscriber would react on this.


### Implement your ActionPublisher within the ActionReactiveService

With the ``ActionReactingService`` you can easily manage your publishers and send values to the ``ActionPublisher`` instances with the defined ``ActionReactingService/send(action:input:)`` methode.

Define a Instance Stored Property within the ``ActionReactingService`` class.

```swift
final class ActionReactingService {
    
    //MARK: - Properties = ActionPublisher

    let addingVocabulary = AddingVocabularPublisher()
    
    ...
}
```

>You need to access to this property through a KeyPath so you should not define the Property as private!

### Use the ActionReactingService

In this App there is a ``ActionReactingServiceKey`` EnvironmentKey.
You can easily access to an instance of the ``ActionReactingService`` class within a View.

```swift
struct VocabularyListView: View {
    
    let list: VocabularyList

    @Environment(\.actionReactingService) var actionReactingService
    @Query private var vocabularies: Array<Vocabulary>
    
    init(list: VocabularyList) {
        self.list = list
            
        let filter: Predicate<Vocabulary> = #Predicate {
            list.persistentModelID == $0.persistentModelID
        }
        _vocabularies = Query(FetchDescriptor(predicate: filter))
    }
    
    private func addNewVocabulary() {
        let newVocabulary = Vocabulary(baseWord: "", translationWord: "", wordGroup: .noun)
        list.addVocabulary(newVocabulary)
        
        actionReactingService.send(action: \.addingVocabulary, input: newVocabulary)
    }
    
    var body: some View {
        List(vocabularies) { ... }

        ...
    }
}
```

> The custom Query of vocabularies is declerated here because of the better updating of the List after changes of the list´s vocabulary Array.

In this example any Subscriber does not subscribe to your ``ActionPublisher``. Let us create a Subscriber!

### Subscribe to an ActionPublisher

You can subscribe by using the ``OnActionModifier`` or ``SwiftUI/View/onAction(_:perform:)`` in your SwiftUI views. Or you can use the subjects directly for other Subscribers.

```swift
struct ContentView: View {
        
    @State var selectedList: VocabularyList? = nil
    @State var  latestVocabulary: Vocabulary? = nil

    var body: some View {
        NavigationSplitView {
            SidebarView(selectedList: selectedList)
        } detail: {
            if let selectedList {
                VocabularyListView(list: list)
            }
        }
        .onAction(\.addingVocabulary) { newVocabulary in 
            latestVocabulary = newVocabulary
        }
    }
}
```

