//
//  UCDWelcomePageAboutView.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/6/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "UCDWelcomePageViewAbout.h"
#import "UCDButton.h"
#import "UCDTextField.h"

@interface UCDWelcomePageViewAbout () <UITextFieldDelegate>

@end

@implementation UCDWelcomePageViewAbout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title.text = @"Tell us a little about you:";
        self.subtitle.text = @"You can change what ping knows about you at any time from Ping’s “Settings” pane.";
        
        self.doneButton = [[UCDButton alloc] init];
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [self addSubview:self.doneButton];
        
        self.occupationField = [[UCDTextField alloc] init];
        self.occupationField.delegate = self;
        self.occupationField.placeholder = @"Occupation";
        [self addSubview:self.occupationField];
        
        self.genderField = [[UCDTextField alloc] init];
        self.genderField.delegate = self;
        self.genderField.placeholder = @"Gender";
        [self addSubview:self.genderField];
        
        self.birthdayField = [[UCDTextField alloc] init];
        self.birthdayField.delegate = self;
        self.birthdayField.placeholder = @"Birthday";
        [self addSubview:self.birthdayField];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect doneButtonFrame = self.doneButton.frame;
    doneButtonFrame.origin.x = floorf((CGRectGetWidth(self.frame) / 2.0) - (CGRectGetWidth(self.doneButton.frame) / 2.0));
    doneButtonFrame.origin.y = floorf((CGRectGetMaxY(self.genderField.frame) + ((CGRectGetMinY(self.subtitle.frame) - CGRectGetMaxY(self.genderField.frame)) / 2.0)) - (CGRectGetHeight(self.doneButton.frame) / 2.0));
    self.doneButton.frame = doneButtonFrame;
    
    CGFloat fieldX = CGRectGetMinX(self.title.frame) + 10.0;
    CGFloat fieldWidth = CGRectGetWidth(self.title.frame) - 20.0;
    CGFloat fieldPadding = 10.0;
    
    [self.occupationField sizeToFit];
    CGRect occupationFieldFrame = self.occupationField.frame;
    occupationFieldFrame.origin.y = CGRectGetMaxY(self.title.frame) + fieldPadding;
    occupationFieldFrame.origin.x = fieldX;
    occupationFieldFrame.size.width = fieldWidth;
    self.occupationField.frame = occupationFieldFrame;
    
    [self.birthdayField sizeToFit];
    CGRect birthdayFieldFrame = self.birthdayField.frame;
    birthdayFieldFrame.origin.y = CGRectGetMaxY(self.occupationField.frame) + fieldPadding;
    birthdayFieldFrame.origin.x = fieldX;
    birthdayFieldFrame.size.width = fieldWidth;
    self.birthdayField.frame = birthdayFieldFrame;
    
    [self.genderField sizeToFit];
    CGRect genderFieldFrame = self.genderField.frame;
    genderFieldFrame.origin.y = CGRectGetMaxY(self.birthdayField.frame) + fieldPadding;
    genderFieldFrame.origin.x = fieldX;
    genderFieldFrame.size.width = fieldWidth;
    self.genderField.frame = genderFieldFrame;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return NO;
}

@end
