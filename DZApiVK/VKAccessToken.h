//
//  VKAccessToken.h
//  DZApiVK
//
//  Created by Dima Tixon on 21/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* userID;


@end
