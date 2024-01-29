# ``Vocablo``

An App for learning vocabularies with Spaced Repetition.

@Metadata{
    @Available(macOS, introduced: "14.0")
    @SupportedLanguage(swift)
}

## Overview



## Topics

- ``VocabloApp``

### SwiftData Models and Utilities

- ``Vocabulary``
- ``VocabularyList``
- ``SwiftData/ModelContainer``
- ``SwiftData/ModelContext``
- ``SchemaV1``


### Main Views

- ``VocabloScene``
- ``SettingsScene``
- ``ContentView``
- ``SidebarView``
- ``VocabularyListDetailView``
- ``EditVocabularyView``

### Sheets

- ``WelcomeSheet``
- ``LearningSheet``

### Sub Views

- ``VocabularyItem``

### View Components

- ``VocabularyTextField``
- ``VocabularyToggle``
- ``WordGroupPicker``
- ``CommandWordGroupPicker``
- ``LearningLevelPicker``
- ``LearningStateInfoButton``
- ``LearningStateExplenationPopoverButton``

### View Utilities

- ``SelectionContext``
- ``SelectionContextEnvrionmentKey``
- ``OpacityBool``

### Learning API

- ``Learnable``
- ``LearningState``
- ``LearningLevel``
- ``LearningValue``
- ``LearningValueManager``

### ActionReactingService API

- <doc:Essentials-of-ActionReactingService>
- ``ActionReactingService``
- ``ActionPublisher``
- ``ActionReactingServiceKey``
- ``OnActionModifier``
- <doc:Some-ActionPublisher>

### AppVersionManager API (Beta)

- ``AppVersionManager``

### Deprecated

- ``DetailView``
- ``VocabulariesListView``
- ``TagMultiPicker``
- ``ListTableView``
