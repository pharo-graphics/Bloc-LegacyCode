Class {
	#name : #BlElementConjunctionState,
	#superclass : #BlElementCompositeState,
	#category : #'Bloc-States'
}

{ #category : #testing }
BlElementConjunctionState >> matches: aSetOfStates [
	^ (self left matches: aSetOfStates) and: [ self right matches: aSetOfStates ]
]

{ #category : #printing }
BlElementConjunctionState >> printOn: aStream [
	aStream
		nextPut: $(;
		print: self left;
		nextPutAll: ' & ';
		print: self right;
		nextPut: $)
]
