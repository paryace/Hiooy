
/*
 File: SectionHeaderView.m
 Abstract: A view to display a section header, and support opening and closing a section.
 
 Version: 2.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionHeaderView

@synthesize titleLabel=_titleLabel, disclosureButton=_disclosureButton, delegate=_delegate, section=_section;
@synthesize numberLabel = _numberLabel;
@synthesize addBtn = _addBtn;
@synthesize totalBtn = _totalBtn;

#define kTag 666


+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


-(id)initWithFrame:(CGRect)frame title:(NSString*)title number:(int)number section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        /*
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];   // leak
        */
        
        _delegate = delegate;        
        self.userInteractionEnabled = YES;
        
        // Create and configure the title label.
        _section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        //titleLabelFrame.origin.x += 35.0;
        titleLabelFrame.origin.x += (35.0 + 30);
        titleLabelFrame.size.width -= (35.0+110);
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _titleLabel = label;
        //_titleLabel.backgroundColor = [UIColor redColor];
        
        // Create and configure the total button.
        UIButton *totalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        totalButton.frame = _titleLabel.frame;
        [totalButton addTarget:self action:@selector(btn_GoToTotalInfo_TouchInside:) forControlEvents:UIControlEventTouchUpInside];
        totalButton.showsTouchWhenHighlighted = YES; 
        totalButton.tag = kTag + sectionNumber;     // 统计btn
        [self addSubview:totalButton];
        _totalBtn = totalButton;
        //_totalBtn.backgroundColor = [UIColor blueColor];
        
        // Create and configure the number label.
        CGRect numberLabelFrame = self.bounds;
        numberLabelFrame.origin.x = numberLabelFrame.size.width - 35.0;
        numberLabelFrame.size.width = 35.0;
        //CGRectInset(numberLabelFrame, 0.0, 5.0);
        UILabel *numberlabel = [[UILabel alloc] initWithFrame:numberLabelFrame];
        numberlabel.text = [NSString stringWithFormat:@"[%d]", number];
        numberlabel.font = [UIFont boldSystemFontOfSize:17.0];
        numberlabel.textColor = [UIColor whiteColor];
        numberlabel.backgroundColor = [UIColor clearColor];
        [self addSubview:numberlabel];
        _numberLabel = numberlabel;
        _numberLabel.hidden = YES;
        
        // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(2.0, 0.0, 50.0, 40.0);
        [button setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _disclosureButton = button;
        //_disclosureButton.backgroundColor = [UIColor blueColor];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        numberLabelFrame = self.bounds;
        numberLabelFrame.origin.x = numberLabelFrame.size.width - 60;  // 100
        numberLabelFrame.size.width = 58;
        addButton.frame = numberLabelFrame;
        [addButton setTitle:NSLocalizedString(@"add", nil) forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [addButton addTarget:self action:@selector(btn_AddNewDevice_TouchInside:) forControlEvents:UIControlEventTouchUpInside];
        addButton.tag = kTag + sectionNumber;
        [self addSubview:addButton];
        _addBtn = addButton;
        //_addBtn.backgroundColor = [UIColor purpleColor];
        
        // Set the colors for the gradient layer.
        static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            color = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
        
    }
    
    return self;
}

- (void)resetDeviceNumber:(int)number {
    
    _numberLabel.text = [NSString stringWithFormat:@"[%d]", number];
    
}

- (IBAction)toggleOpen:(id)sender {
    //NSLog(@"toggleOpenWithUserAction...111");
    [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    
    //NSLog(@"toggleOpenWithUserAction...222");
    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}

- (void)btn_AddNewDevice_TouchInside:(id)sender {

    NSLog(@"addNewDevice...");
    if ([self.delegate respondsToSelector:@selector(addNewDevice:)]) {
        [self.delegate addNewDevice:sender];
    }
    
}

- (void)btn_GoToTotalInfo_TouchInside:(id)sender {

    NSLog(@"goToTotalInfo...");
    if ([self.delegate respondsToSelector:@selector(goToTotalInfo:)]) {
        [self.delegate goToTotalInfo:sender];
    }
    
}


@end
