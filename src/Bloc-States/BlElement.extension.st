Extension { #name : #BlElement }

{ #category : #'*Bloc-States' }
BlElement >> states [

	"Style and properties computation are not used and will be removed"
	^ nil

	"^ self userData
		at: #blocStates
		ifAbsentPut: [ BlElementStates new element: self ]"
]
