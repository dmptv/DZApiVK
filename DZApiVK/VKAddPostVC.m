//
//  VKAddPostVC.m
//  DZApiVK
//
//  Created by Dima Tixon on 07/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKAddPostVC.h"
#import "AKServerManager.h"

@interface VKAddPostVC () <UITextViewDelegate>

@end

@implementation VKAddPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postTextView.delegate = self;
    
    if ([self.postTextView.text isEqualToString:@""]) {
        self.sendPost.enabled = NO;
    }
    
}



- (IBAction)cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}




- (IBAction)sendPost:(id)sender {
    
    [[AKServerManager sharedManager] postOnWall:@"131176878" //58860049 131176878
                                        message:self.postTextView.text
                                       onSucces:^(id result) {
                                           NSLog(@"onSucces");
                                       }
                                      onFailure:^(NSError *error) {
                                          NSLog(@"error %@", [error localizedDescription]);
                                      }];

    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {

    if ([self.postTextView.text length] > 0) {
        self.sendPost.enabled = YES;
    } else {
        self.sendPost.enabled = NO;
    }

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
      // когда нажимаешь return то происходит переход на следующюю линию \n
    
    if([text isEqualToString:@"\n"]) {
        
        UITextView *textView = self.postTextView;
        
          // очищаем от текста после send action
        
        textView.text = nil;
        [textView.undoManager removeAllActions];
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}


@end







