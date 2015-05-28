tests-infoRetrievalPackage
testSendAuthenticationInfoV3MilenageResync
	| operationName dialogue invoke invokeResponse |

	subscriber credentials: (SubscriberMilenageCredentials new
		sqn: 16rFFFFFFFFFFFF;
		opc: (ByteArray new: 16);
		ki: (ByteArray new: 16);
		yourself).

	operationName := 'sendAuthenticationInfoV3'.
	dialogue := testEndPoint newDialogue.
	invoke := dialogue requestTcInvokeNamed: operationName parameters:  self createAuthV3ParamsResync class: 1 timeout: 500.
	invoke
		onReturn: [self assert: false ];
		onError: [self assert: false];
		onReject: [self assert: false];
		onReturnLast: [:result | invokeResponse := result resultObject authenticationSetList quintupletList ].
	dialogue
		requestTcBeginDestinationAddress: self hlrAddr
		originatingAddress: self localAddr
		applicationContextName: (self applicationContextFor: operationName).
		

	self assert: invokeResponse size = 1.
	self assert: subscriber credentials seq equals: 2125201402220.
	self assert: subscriber credentials ind equals: 31.