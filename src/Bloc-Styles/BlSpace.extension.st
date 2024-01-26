Extension { #name : #BlSpace }

{ #category : #'*Bloc-Styles' }
BlSpace >> canComputeProperties: anElement [
	"Return true if properties of the given element can be computed"
	<return: #Boolean>

	^ anElement hasParent and: [ anElement parent needsPropertiesComputation not ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> doComputeProperties [
	| theElementToProcess |
	
	"if everything is clean, do nothing"
	(self needsPropertiesComputation)
		ifFalse: [ ^ self ].

	"only care about element that are attached to this space"
	theElementToProcess := self extractAttachedElements: self elementsNeedingPropertiesComputation.

	"first we should make sure that all parents have resolved properties"
	theElementToProcess := self extractUnresolvedToComputeProperties: theElementToProcess.

	"then we should eliminate child elements if their parent is already on the list"
	theElementToProcess := self extractRoots: theElementToProcess.
	
	self elementsNeedingPropertiesComputation removeAll.
	
	((theElementToProcess includes: self root) or: [ self root needsPropertiesComputation ])
		ifTrue: [ self doComputePropertiesFromRoot: self root ]
		ifFalse: [ self doComputePropertiesOf: theElementToProcess ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> doComputeProperties: anElement withGlobalProperties: aGlobalResolvedProperties [
	self
		assert: [ anElement hasParent ]
		description: [ 'Can not compute properties of an element without parent' ].

	self
		assert: [ anElement parent needsPropertiesComputation not ]
		description: [ 'Parent properties must be computed' ].

	self
		doComputeProperties: anElement
		withParentProperties: anElement parent properties maybeResolvedProperties propertiesToPropagateToChildren
		withGlobalProperties: aGlobalResolvedProperties
]

{ #category : #'*Bloc-Styles' }
BlSpace >> doComputeProperties: anElement withParentProperties: aParentResolvedProperties withGlobalProperties: aGlobalResolvedProperties [
	| theResolvedProperties thePropagatableProperties |

	self
		assert: [ aParentResolvedProperties isKindOf: BlElementPropagatableProperties ]
		description: [ 'Parent properties must be propagatable' ].
		
	self
		assert: [ aGlobalResolvedProperties isKindOf: BlElementPropagatableProperties ]
		description: [ 'Global properties must be propagatable' ].

	theResolvedProperties := anElement properties
		resolveWithParentProperties: aParentResolvedProperties
		orGlobal: aGlobalResolvedProperties.

	thePropagatableProperties := theResolvedProperties propertiesToPropagateToChildren.

	anElement childrenDo: [ :eachChild |
		self
			doComputeProperties: eachChild
			withParentProperties: thePropagatableProperties 
			withGlobalProperties: aGlobalResolvedProperties ].

	"we need to merge properties starting from global"
	((aGlobalResolvedProperties
		mergedWithProperties: aParentResolvedProperties)
			mergedWithProperties: theResolvedProperties)
				applyOnElement: anElement.

	anElement properties flushPropertiesToRemove
]

{ #category : #'*Bloc-Styles' }
BlSpace >> doComputePropertiesFromRoot: aRootElement [
	| theGlobalResolvedProperties |

	aRootElement properties
		resolveWithParentProperties: BlElementResolvedProperties new
		orGlobal: BlElementResolvedProperties new.
	
	theGlobalResolvedProperties := aRootElement properties maybeResolvedProperties propertiesToPropagateToChildren.
	
	self
		doComputeProperties: aRootElement
		withParentProperties: theGlobalResolvedProperties
		withGlobalProperties: theGlobalResolvedProperties
]

{ #category : #'*Bloc-Styles' }
BlSpace >> doComputePropertiesOf: aCollectionOfElements [
	| theGlobalResolvedProperties |

	self
		assert: [ (aCollectionOfElements includes: self root) not ]
		description: [ 'Must not include root' ].

	theGlobalResolvedProperties := self root properties maybeResolvedProperties propertiesToPropagateToChildren.
	aCollectionOfElements do: [ :eachElement |
		"it is possible that properties manipulate the graphical scene,
		therefore we have to check it here again"
		eachElement hasParent
			ifTrue: [
				self
					doComputeProperties: eachElement
					withGlobalProperties: theGlobalResolvedProperties ] ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> doStyle [
	| theElementsToStyle |
	
	self needsStyleComputation
		ifFalse: [ ^ self ].
	
	"only care about element that are attached to this space"
	theElementsToStyle := self elementsNeedingStyle.

	"first we should make sure that all parents are styled"
	theElementsToStyle := self extractUnstyled: theElementsToStyle.

	"then we should eliminate child elements if their parent is already on the list"
	theElementsToStyle := self extractRoots: theElementsToStyle.
	
	self elementsNeedingStyle removeAll.
	
	theElementsToStyle do: [ :eachElement | self doStyle: eachElement ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> doStyle: anElement [
	"anElement applyStyles"
]

{ #category : #'*Bloc-Styles' }
BlSpace >> elementsNeedingPropertiesComputation [

	^ self userData at: #elementsNeedingPropertiesComputation ifAbsentPut: [ Set new ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> elementsNeedingStyle [

	^ self userData at: #elementsNeedingStyle ifAbsentPut: [ Set new ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> extractUnresolvedToComputeProperties: aSetOfElements [
	^ self
		extractParents: aSetOfElements
		suchThat: [ :eachParent | eachParent needsPropertiesComputation ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> extractUnstyled: aSetOfElements [
	^ self
		extractParents: aSetOfElements
		suchThat: [ :eachParent | eachParent needsStyle ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> needsPropertiesComputation [
	<return: #Boolean>
	
	^ self elementsNeedingPropertiesComputation isNotEmpty
		or: [ self root needsPropertiesComputation ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> needsPropertiesComputation: anElement [
	"Return true if a given element or any of its children wants properties computation"
	<return: #Boolean>

	^ self elementsNeedingPropertiesComputation
		anySatisfy: [ :eachElement | 
			(eachElement = anElement
				or: [ eachElement hasParent: anElement ])
					and: [ anElement hasParent
						and: [ anElement parent needsPropertiesComputation not ] ] ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> needsStyleComputation [
	
	^ self elementsNeedingStyle isNotEmpty
]

{ #category : #'*Bloc-Styles' }
BlSpace >> needsStyleComputation: anElement [
	"Return true if a given element or any of its children wants style computation"
	<return: #Boolean>
	
	^ self elementsNeedingStyle
		anySatisfy: [ :eachElement | eachElement = anElement or: [ eachElement hasParent: anElement ] ]
]

{ #category : #'*Bloc-Styles' }
BlSpace >> requestPropertiesComputation: anElement [
	self elementsNeedingPropertiesComputation add: anElement.
	self requestNextPulse
]

{ #category : #'*Bloc-Styles' }
BlSpace >> requestStyle: anElement [		
	self elementsNeedingStyle add: anElement.
	self requestNextPulse
]
