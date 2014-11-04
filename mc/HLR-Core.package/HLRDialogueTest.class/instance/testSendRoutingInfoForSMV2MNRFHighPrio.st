tests-infoRetrievalPackage
testSendRoutingInfoForSMV2MNRFHighPrio
	| operationName dialogue  invoke invokeResultMessage sriArg mwStatus  |
	
	subscriber
		mscNumber: '123';
		vlrNumber: '456';
		memoryCapcacityExceeded;
		mobileStationNotPresent.
	invokeResultMessage := 23.
	mwStatus := nil.

	self assert: subscriber isMobileStationNotReachable.
	self assert: subscriber messageWaitingSet isEmpty.

	sriArg := ASN1Dictionary new
				at: 'msisdn' put: subscriber msisdnAsE164;
				at: 'sm-RP-PRI' put: true;
				at: 'serviceCentreAddress' put: '912343' byteArrayFromHex;
				yourself.

	operationName := 'sendRoutingInfoForSMV2'.
	dialogue := testEndPoint createDialogue.
	invoke := dialogue
				requestTcInvokeNamed: operationName parameters:  sriArg
				class: 1 timeout: 500.
	invoke
		onReturn: [self assert: false ];
		onError: [self assert: false];
		onReject: [self assert: false];
		onReturnLast: [:result | invokeResultMessage := result ].

	dialogue onInvoke: [:invocation |
				mwStatus := invocation argument mw_Status].
	dialogue
		requestTcBeginDestinationAddress: self hlrAddr
		originatingAddress: self localAddr
		applicationContextName: (self applicationContextFor: operationName).

	"TODO.. make sure things return"
	self deny: invokeResultMessage result isNil.
	self assert: (mwStatus includesBit: 'sc-AddressNotIncluded').
	self assert: (mwStatus includesBit: 'mnrf-Set').
	self assert: (mwStatus includesBit: 'mcef-Set').
	self assert: subscriber messageWaitingSet isEmpty.