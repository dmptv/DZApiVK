//
//  VKPost.h
//  DZApiVK
//
//  Created by Kanat A on 21/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKServerObject.h"

@class AKUser;
@class VKGroup;

@interface VKPost : AKServerObject

@property (assign, nonatomic) NSInteger commentsCount;
@property (assign, nonatomic) NSInteger likesCount;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* from_id;
@property (strong, nonatomic) NSString* to_id;

@property (strong, nonatomic) NSString* Id;

@property (strong, nonatomic) AKUser* from_user;
@property (strong, nonatomic) VKGroup* from_group;

@property (strong, nonatomic) NSString* date;

@property (strong, nonatomic) NSArray* attachmentPhotos;


@end
