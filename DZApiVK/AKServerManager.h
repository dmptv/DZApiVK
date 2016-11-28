//
//  AKServerManager.h
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKUser;

@interface AKServerManager : NSObject

@property (strong, nonatomic) AKUser* currentUser;

+ (AKServerManager*) sharedManager;

- (void) authorizeUser:(void(^)(AKUser* user)) completion;

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(AKUser* user)) success
       onFailure:(void(^)(NSError* error)) failure;

- (void) getGroupWall:(NSString*) groupID
           withOffset:(NSInteger) offset
                count:(NSInteger) count
             onSucces:(void(^)(NSArray* posts)) success
            onFailure:(void(^)(NSError* error)) failure;

- (void) postOnWall:(NSString*)groupID
            message:(NSString*)message
           onSucces:(void(^)(id result)) succes
          onFailure:(void(^)(NSError* error)) failure;

- (void) sendMessageForUserId:(NSString*)senderId
                      message:(NSString*)message
                    onSuccess:(void(^)(id result)) success
                   onFailure:(void(^)(NSError *error)) failure;

- (void) getHistoryMessagesFromUserId:(NSString*)senderId
                           senderName:(NSString*)senderDisplayName
                                count:(NSInteger)count
                               offset:(NSInteger)offset
                            onSuccess:(void(^)(NSArray *array)) success
                            onFailure:(void(^)(NSError *error)) failure;

- (void) getCommentsFromWall:(NSString*)groupID
                      postID:(NSString*)postID
                  withOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* comments))succsess
                   onFailure:(void(^)(NSError* error))failure;


- (void) commentToPost:(NSString*)postID
              fromWall:(NSString*)groupID
                message:(NSString*)message
              onSuccess:(void(^)(id result))succsess
              onFailure:(void(^)(NSError* error))failure;
























@end
