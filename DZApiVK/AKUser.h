//
//  AKUser.h
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKServerObject.h"

@interface AKUser : AKServerObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* user_id;

@property (strong, nonatomic) NSURL* imageURL;






@end
