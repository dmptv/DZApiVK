//
//  AddComCell.m
//  DZApiVK
//
//  Created by Dima Tixon on 17/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "AddComCell.h"
#import "AKServerManager.h"

#import <AFNetworking.h>

@implementation AddComCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commentTextField.delegate = self;

    [self setupView];
}

- (void) setupView {
    
//    UIImage* imageNormal = [UIImage imageNamed:@"normal"];
//    UIImage* imageSelected = [UIImage imageNamed:@"selected"];
//    
//    [self.sendButton setImage:imageNormal forState:UIControlStateNormal];
//    [self.sendButton setImage:imageNormal forState:UIControlStateDisabled];
//    [self.sendButton setImage:imageSelected forState:UIControlStateHighlighted];
//    [self.sendButton setImage:imageSelected forState:UIControlStateSelected];
    
    [self.sendButton addTarget:self
                        action:@selector(didTapButton:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureCellWithSendCallback:(void(^)(NSString* text))sendCallback { // 3
    self.sendCallback = sendCallback; // инициалируем блок
    

}

- (void) didTapButton:(UIButton*) button { // 4
    if (self.sendCallback) {
        // если (любой Объект существует)
        self.sendCallback(self.commentTextField.text);
    }
    
    NSLog(@"button tapped");
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.commentTextField.text length] > 0) {
        [self prepareAndSendMessage];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void) prepareAndSendMessage {
    
    self.sendButton.enabled = NO;
    self.commentTextField.text = nil;
    
    [self.commentTextField resignFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end






