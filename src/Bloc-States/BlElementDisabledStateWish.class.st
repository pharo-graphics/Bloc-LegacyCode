Class {
	#name : #BlElementDisabledStateWish,
	#superclass : #BlElementStateWish,
	#instVars : [
		'enabled'
	],
	#category : #'Bloc-States'
}

{ #category : #accessing }
BlElementDisabledStateWish >> enabled [
	^ enabled
]

{ #category : #accessing }
BlElementDisabledStateWish >> enabled: anObject [
	enabled := anObject
]
