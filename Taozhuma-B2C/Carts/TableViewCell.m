//
//  TableViewCell.m
//  MailWorldClient
//
//  Created by liyoro on 13-10-15.
//  Copyright (c) 2013年 liyoro. All rights reserved.
//

#import "TableViewCell.h"
#import "IQKeyBoardManager.h"

@interface TableViewCellView : UIView {
    __weak TableViewCell *cell;
}
@end

@implementation TableViewCellView

- (id)initWithCell:(TableViewCell *)cell_ {
    if ((self = [super initWithFrame:CGRectZero])) {
        cell = cell_;
    }
    
    return self;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"SDF");
    
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [cell drawContentView:rect];
}

@end

@implementation TableViewCell

@synthesize showsDivider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        contentView = [[TableViewCellView alloc] initWithCell:self];
        [contentView setOpaque:YES];
        [self addSubview:contentView];
        
        [self setShowsDivider:YES];
    }
    return self;
}

- (void)setShowsDivider:(BOOL)shows {
    showsDivider = shows;
    
    // Update content view frame.
    [self setFrame:[self frame]];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [IQKeyBoardManager installKeyboardManager];
    
    CGRect bounds = [self bounds];
    if (showsDivider) bounds.size.height -= 1; // leave room for the seperator line
    [contentView setFrame:bounds];
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect {
    // subclasses should implement this
}

@end
