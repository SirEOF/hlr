test-locationUpdatingPackage
testInsertSubscriberData
	| res  onSuccessCount onFailureCount |

	res := OrderedCollection new.
	onSuccessCount := 0.
	onFailureCount := 0.

	testEndPoint
		onDialogue: [:diag |
			diag onInvoke: [:invocation |
				res add: invocation argument.
				invocation returnResultLast: nil.
				diag requestTcContinue]].

	"Fire and forget the operation"
	HLRInsertSubscriberData new
		hlr: testHlr;
		hlrAddress: '3548999973';
		remoteGlobalTitle: '46707963173';
		dialogueHandler: hlrEndPoint;
		subscriber: subscriber;
		onSuccess: [onSuccessCount := onSuccessCount + 1];
		onFailure: [onFailureCount := onFailureCount + 1];
		startWithNewDialogue.

	self assert: res size = 3.
	self assert: res first keys size = 1.
	self assert: res first imsi = subscriber imsiAsTBCD.
	self assert: onSuccessCount = 1.
	self assert: onFailureCount = 0.