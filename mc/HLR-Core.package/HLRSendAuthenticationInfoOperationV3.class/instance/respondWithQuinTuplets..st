as yet unclassified
respondWithQuinTuplets: aSubscriber
	| credentials result resultList autn ik ck xres |
	result := 'SendAuthenticationInfoResV3' asAsn1ValueTypedIn: dialogue asn1Model.
	result beSelfExpanding.
	resultList := result authenticationSetList quintupletList.

	credentials := aSubscriber credentials.	"We increment the index for the new batch"

	"Move it by one so it eventually will increase the SEQ"
	credentials incrementSqn.

	"Temporaries for the result"
	autn := ByteArray new: 16.
	ik := ByteArray new: 16.
	ck := ByteArray new: 16.
	xres := ByteArray new: 8.

	resultList addUsing: [ :tuple | 
		| rand |
		rand := RAND rand: 16.

		credentials
				generate: rand
				autn: autn
				ik: ik
				ck: ck
				xres: xres.
		tuple
				rand: rand;
				xres: xres;
				ck: ck;
				ik: ik;
				autn: autn].

	hlr database updateSQN: aSubscriber.

	invocation returnResultLast: result.
	dialogue requestTcEnd: false.
	self signalSuccess: 'done'.