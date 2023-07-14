//
//  CIFCardStatusQuery.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CIFCardStatusQuery.h"

static const UInt8 STATUS_BITS = 0xF0;
static const CIFCardStatus STATUS_MAP[12] = 
	{
		CIFCardStatus_Startup,
		CIFCardStatus_BridgeStop,
		CIFCardStatus_BridgeStart,
		CIFCardStatus_Standby,
		CIFCardStatus_E2PUpdate,
		CIFCardStatus_VideoEnable,
		CIFCardStatus_VideoStandby,
		CIFCardStatus_VideoDisable,
		CIFCardStatus_VideoStart,
		CIFCardStatus_VideoShow,
		CIFCardStatus_VideoStop,
		CIFCardStatus_ExternPowerLow
	};


@implementation CIFCardStatusQuery

- (id) init {
	self = [super init];
	if (self) {
		status = CIFCardStatus_Startup;
	}
	return self;
}

- (UInt16) getCommand {
	return 1565;
}


- (UInt16) getResponseLength {
	return 1;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
	UInt8 code = ([buffer getUInt8At:0] & STATUS_BITS) >> 4;
	status = STATUS_MAP[code];

}

- (CIFCardStatus) getStatus {
	return status;
}

@end
