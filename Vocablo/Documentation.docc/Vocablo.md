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
- ``DuplicateWarningLabel``
- ``DuplicateVocabulariesPopover``
- ``DuplicateVocabulariesPopoverButton``

### View Utilities

- ``SelectionContext``
- ``SelectionContextEnvrionmentKey``
- ``SheetContext``
- ``SheetContextEnvironmentKey``
- ``OpacityBool``

### Learning API

- ``Learnable``
- ``LearningState``
- ``LearningLevel``
- ``LearningValue``
- ``LearningValueManager``

### ActionReactingService 

- <doc:Essentials-of-ActionReactingService>
- ``ActionReactingService``
- ``ActionPublisher``
- ``ActionReactingServiceKey``
- ``OnActionModifier``
- <doc:Some-ActionPublisher>

### DuplicateRecognitionService 

- ``DuplicateRecognitionService``
- ``Duplicateable``

### AppVersionManager API (Beta)

- ``AppVersionManager``

### Deprecated

- ``DetailView``
- ``VocabulariesListView``
- ``TagMultiPicker``
- ``ListTableView``
