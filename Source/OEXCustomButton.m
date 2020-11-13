//
//  OEXCustomButton.m
//  edXVideoLocker
//
//  Created by Rahul Varma on 09/06/14.
//  Copyright (c) 2014 edX. All rights reserved.
//

#import "OEXStyles.h"
#import "OEXCustomButton.h"
#import "OEXTextStyle.h"

@implementation OEXCustomButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        // set custom font

        switch(self.tag)
        {
            case 103:   //Trouble Logging in ?
                self.titleLabel.font = [[OEXStyles sharedStyles] semiBoldFontOfSize:self.titleLabel.font.pointSize];
                break;

            case 104:   //SIGN IN
                self.titleLabel.font = [[OEXStyles sharedStyles] regularFontOfSize:self.titleLabel.font.pointSize];
                break;

            case 105:   //New Here? Sign Up
                self.titleLabel.font = [[OEXStyles sharedStyles] semiBoldFontOfSize:self.titleLabel.font.pointSize];
                break;

            case 106:   //EULA
                self.titleLabel.font = [[OEXStyles sharedStyles] regularFontOfSize:self.titleLabel.font.pointSize];
                break;

            case 107:   //Facebook
                self.titleLabel.font = [[OEXStyles sharedStyles] regularFontOfSize:self.titleLabel.font.pointSize];
                break;

            case 108:   //Google
                self.titleLabel.font = [[OEXStyles sharedStyles] regularFontOfSize:self.titleLabel.font.pointSize];
                break;

            case 207:   // Rareview - MY COURSE
                self.titleLabel.font = [[OEXStyles sharedStyles] regularFontOfSize:self.titleLabel.font.pointSize];
                break;

            case 303:   //FrontView Course - new course content
                self.titleLabel.font = [[OEXStyles sharedStyles] boldFontOfSize:self.titleLabel.font.pointSize];
                break;

            case 401:   //Download View Controller
                self.titleLabel.font = [[OEXStyles sharedStyles] regularFontOfSize:OEXTextSizeBase];
                break;

            default:
                break;
        }
    }
    return self;
}

@end
