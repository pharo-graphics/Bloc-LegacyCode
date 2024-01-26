Class {
	#name : #BlElementStateEventHandler,
	#superclass : #BlCustomEventHandler,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Bloc-States'
}

{ #category : #accessing }
BlElementStateEventHandler class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
