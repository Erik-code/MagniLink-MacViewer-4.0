//
//  AutofocusQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-05-09.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"


@interface AutofocusQuery : RegisterFileQuery {
@private AutofocusState autofocusState;
	
}

- (AutofocusState) getAutofocusState;

@end
