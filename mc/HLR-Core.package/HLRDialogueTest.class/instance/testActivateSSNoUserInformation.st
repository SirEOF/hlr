test-supplementary-services
testActivateSSNoUserInformation
	| operationName dialogue  invoke invokeResult param invocations |
	
	subscriber
		vlrNumber: '1234'.

	invocations := 0.
	param := ASN1Dictionary new
		at: 'ss-Code' put: SSData callWaiting asByteArray;
		at: 'basicService' put: (ASN1Dictionary new
					at: 'teleservice' put: #[16r10];
					yourself);
		yourself.

	testEndPoint
		onDialogue: [:diag |
			diag onInvoke: [:invocation |
				invocations := invocations + 1.
				invocation returnResultLast: nil.
				diag requestTcContinue]].

	operationName := 'activateSS'.
	dialogue := testEndPoint newDialogue.
	invoke := dialogue requestTcInvokeNamed: operationName parameters:  param class: 1 timeout: 5.
	invoke
		onReturn: [self assert: false ];
		onError: [self assert: false];
		onReject: [self assert: false];
		onReturnLast: [:result |  invokeResult := result].
	dialogue
		requestTcBeginDestinationAddress: self imsiAddr
		originatingAddress: self localAddr
		applicationContextName: (self applicationContextFor: operationName).

	self assert: invokeResult isNil.
	self assert: invocations equals: 0.