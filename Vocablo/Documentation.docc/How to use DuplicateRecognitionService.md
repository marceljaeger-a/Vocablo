# How to use DuplicateRecognitionService

An article that shows you how you use this Service.

## Overview

The ``DuplicateRecognitionService`` is a simple structure that contains methodes for handling with duplicates within Arrays.

### Make a type conform to Duplicateable

``Duplicateable`` is a protocol that declerates a methode within you can define if an instance is a duplicate of an other instance.

```swift
extension Vocabulary: Duplicateable {
    static func isDuplicate(lhs: SchemaV1.Vocabulary, rhs: SchemaV1.Vocabulary) -> Bool {
        lhs.baseWord == rhs.baseWord && lhs.translationWord == rhs.translationWord && lhs.id != rhs.id
    }
}
```

### Use the Service

In the next example the methodes returns true because there is **the tree / der Baum** twice within the Array.

```swift
let duplicateRecognizer = DuplicateRecognitionService()

let vocabularies =
[
    Vocabulary(baseWord: "the tree", translationWord: "der Baum", wordGroup: .noun),
    Vocabulary(baseWord: "the apple", translationWord: "der Apfel", wordGroup: .noun),
    Vocabulary(baseWord: "the tree", translationWord: "der Baum", wordGroup: .noun),
    Vocabulary(baseWord: "the apple tree", translationWord: "der Apfelbaum", wordGroup: .noun)
]

let comparingVocabulary = Vocabulary(baseWord: "the tree", translationWord: "der Baum", wordGroup: .noun)

print(duplicateRecognizer.existDuplicate(of: comparingVocabulary, within: vocabularies))
//true
```
