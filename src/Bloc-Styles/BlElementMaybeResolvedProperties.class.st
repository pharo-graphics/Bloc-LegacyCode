Class {
	#name : #BlElementMaybeResolvedProperties,
	#superclass : #BlElementProperties,
	#category : #'Bloc-Styles-Basic-Properties'
}

{ #category : #actions }
BlElementMaybeResolvedProperties >> applyOnElement: anElement [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
BlElementMaybeResolvedProperties >> fontSize [
	<return: #BlElementFontSizeProperty>

	^ (self
		propertyAt: BlElementFontSizeProperty
		ifNone: [ BlElementFontSizeProperty default ]) fontSize
]

{ #category : #accessing }
BlElementMaybeResolvedProperties >> propertyAt: aPropertyType ifFound: aFoundBlock [
	^ self 
		propertyAt: aPropertyType
		ifFound: aFoundBlock
		ifNone: [ nil ]
]

{ #category : #accessing }
BlElementMaybeResolvedProperties >> propertyAt: aPropertyType ifFound: aFoundBlock ifNone: aNoneBlock [
	self subclassResponsibility
]

{ #category : #accessing }
BlElementMaybeResolvedProperties >> propertyAt: aPropertyType ifNone: aNoneBlock [
	^ self 
		propertyAt: aPropertyType
		ifFound: [ :aProperty | aProperty ]
		ifNone: aNoneBlock
]
