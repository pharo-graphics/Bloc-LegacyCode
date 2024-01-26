Extension { #name : #BlElement }

{ #category : #'*Bloc-Styles' }
BlElement >> needsPropertiesComputation [
	<return: #Boolean>

	^ self properties needsPropertiesComputation
]

{ #category : #'*Bloc-Styles' }
BlElement >> needsStyle [
	^ self styles needsStyle
]

{ #category : #'*Bloc-Styles' }
BlElement >> properties [

	^ self userData
		at: #blocProperties
		ifAbsentPut: [
			BlElementCurrentProperties new
				element: self;
				yourself ]
]

{ #category : #'*Bloc-Styles' }
BlElement >> requestPropertiesComputation [
	self properties markDirty.

	self isAttachedToSceneGraph
		ifTrue: [ self space requestPropertiesComputation: self ]
		ifFalse: [  ].
]

{ #category : #'*Bloc-Styles' }
BlElement >> requestStyle [
	self styles markDirty.

	self isAttachedToSceneGraph
		ifTrue: [ self space requestStyle: self ]
		ifFalse: [  ].
]

{ #category : #'*Bloc-Styles' }
BlElement >> style [
	self
		deprecated: 'Please use #styles instead'
		transformWith: '`@receiver style' -> '`@receiver styles'.

	^ self styles
]

{ #category : #'*Bloc-Styles' }
BlElement >> styles [
	"Return current element styles.
	See ${class:BlStyles}$ to learn more about styles"
	<return: #BlElementStyles>
	
	"Style and properties computation are not used and will be removed"
	^ nil
	"^ self userData
		at: #blocStyles
		ifAbsentPut: [ BlElementStyles new element: self ]"
]
