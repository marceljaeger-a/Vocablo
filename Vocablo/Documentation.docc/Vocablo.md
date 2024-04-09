# ``Vocablo``

An App for learning vocabularies with Spaced Repetition.

@Metadata{
    @Available(macOS, introduced: "14.0")
    @SupportedLanguage(swift)
}

## Overview



## Topics

- ``VocabloApp``

### Navigation
- ``ContentNavigationView``
- ``Sidebar``
- ``Detail``
- ``VocabulariesDestination``
- ``LearningDestination``

### Views
- ``VocabularyListRow``
- ``VocabularyListView``
- ``VocabularyRow``
- ``EditVocabularyView``
- ``VocabularyQueryView``

### View modifiers
- ``CopyableVocabuariesModifier``
- ``CuttableVocabulariesModifier``
- ``PasteVocabulariesModifier``
- ``OnReceiveControlActiveStateModifier``
- ``LearningNavigationDestinationModifier``

### View envrionment
- ``OnAddingVocabularySubjectKey``
- ``SearchingTextKey``

### View helpers
- ``AppStorageKeys``
- ``ListSelectingValue``
- ``LearningNavigationModel``

### Focus
- ``SelectedListKey``
- ``SelectedVocabulariesKey``

### Data models

- ``Vocabulary``
- ``VocabularyList``
- ``SwiftData/ModelContainer``
- ``SwiftData/ModelContext``
- ``SchemaV1``

### Data types
- ``WordGroup``
- ``ListSortingKey``
- ``VocabularySortingKey``
- ``SortingOrder``

### Learning API

- ``LearningService``
- ``Learnable``
- ``LearningState``
- ``LearningLevel``
- ``LearningValue``
- ``IsAnswerVisibleFocusedValue``
- ``LearningValueFocusedValue``
- ``LearningValueView``
- ``LearningContextView``
- ``FeedbackView``
- ``NewWordLabel``
- ``LeftWordsTextView``
- ``QuestionMarkButton``
- ``ShowAnserButton``
- ``AnswerTrueButton``
- ``AnswerFalseButton``


