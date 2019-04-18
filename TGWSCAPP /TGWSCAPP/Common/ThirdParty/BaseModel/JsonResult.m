//
//  JsonResult.m
//  PD.Models
//
//  Created by Cary on 13/11/13.
//  Copyright (c) 2013 EVT, Inc. All rights reserved.
//

#import "JsonResult.h"

@implementation JsonResult

- (NSString *)description
{
	return [@{
            @"message":_message ? _message : @"nil",
			@"rows":_rows ? _rows : @"nil",
            @"page":_page ? _page : @"nil",
            @"attr":_attr ? _attr : @"nil",
            @"signId":_signId ? _signId : @"nil",
			} description];
}

@end
