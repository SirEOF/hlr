execution
invokeDeleteSubscriberData
	| invoke param operation |
	operation := dialogue rosOperationNamed: 'deleteSubscriberDataV3'.
	param := operation newArgumentValue
				imsi: imsi toTBCD.

	param beSelfExpanding ss_List
		addUsing: [:item | item contents: ssData ssCode asByteArray ].
		
	invoke := dialogue
		requestTcInvoke: operation
		parameters: param
		class: 1 
		timeout: 500.
	invoke
		onReturnLast: [self deleteSubscriberSuccess];
		onError: [self failure].