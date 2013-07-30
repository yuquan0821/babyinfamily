//
//  BabyPlaceHolderTextView.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-29.
//
//

#import "BabyPlaceHolderTextView.h"

@interface BabyPlaceHolderTextView ()
@property(nonatomic, retain) UILabel *placeholder;
@end

@implementation BabyPlaceHolderTextView
@synthesize placeholder = _placeholder;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_placeholder release], _placeholder = nil;
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    if ([self placeholder]) {
        [[self placeholder] removeFromSuperview];
        [self setPlaceholder:nil];
    }
    
    CGRect frame = CGRectMake(8, 8, self.bounds.size.width - 16, 0.0);
    UILabel *placeholder = [[UILabel alloc] initWithFrame:frame];
    [placeholder setLineBreakMode:UILineBreakModeWordWrap];
    [placeholder setNumberOfLines:0];
    [placeholder setBackgroundColor:[UIColor clearColor]];
    [placeholder setAlpha:1.0];
    [placeholder setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [placeholder setTextColor:[UIColor lightGrayColor]];
    [placeholder setText:@""];
    [self addSubview:placeholder];
    [self sendSubviewToBack:placeholder];
    
    [self setPlaceholder:placeholder];
    [placeholder release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFocus:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lostFocus:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}



- (void)textChanged:(NSNotification *)notification
{
    if ([[_placeholder text] length] == 0) {
        return;
    }
    
    if ([[self text] length] == 0) {
        [_placeholder setAlpha:1.0];
    } else {
        [_placeholder setAlpha:0.0];
    }
}

- (void)getFocus:(NSNotification *)notification
{
    if ([[self text] length] == 0) {
        [_placeholder setAlpha:1.0];
    } else {
        [_placeholder setAlpha:0.0];
    }
}

- (void)lostFocus:(NSNotification *)notification
{
    if ([[self text] length] == 0) {
        [_placeholder setAlpha:1.0];
    } else {
        [_placeholder setAlpha:0.0];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if ([[self text] length] == 0 && [[_placeholder text] length] > 0) {
        [_placeholder setAlpha:1.0];
    } else {
        [_placeholder setAlpha:0.0];
    }
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [_placeholder setFont:font];
}

- (NSString *)placeholderText
{
    return [_placeholder text];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    [_placeholder setText:placeholderText];
    
    CGRect frame = _placeholder.frame;
    CGSize constraint = CGSizeMake(frame.size.width, 42.0f);
    CGSize size = [placeholderText sizeWithFont:[self font] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    frame.size.height = size.height;
    [_placeholder setFrame:frame];
}

- (UIColor *)placeholderColor
{
    return [_placeholder textColor];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [_placeholder setTextColor:placeholderColor];
}

@end
