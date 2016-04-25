// SlotLabel.m
// Copyright (c) 2016 Pinn Technologies, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SlotLabel.h"

@implementation SlotLabel

#pragma mark - Superclass
- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit
{
    self.characters = [[NSMutableArray alloc] init];
    self.font = [UIFont systemFontOfSize:12];
    self.textColor = [UIColor blackColor];
    self.shadowColor = [UIColor grayColor];
    self.shadowOffset = CGSizeMake(0, 0);
    self.strokeColor = [UIColor grayColor];
    self.strokeWidth = 0.0f;
    self.verticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.horizontalAlignment = NSTextAlignmentCenter;
    self.animationSpeed = SL_DEFAULT_ANIMATION_SPEED;
    self.animationColor = nil;
}

- (void)prepareForInterfaceBuilder
{
    [self setText:@"hello"];
}

#pragma mark - Public
- (void)animateToString:(NSString*)string
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sizeToFitString:string];
        for (int i = 0; i < [string length]; i++) {
            char character = [string characterAtIndex:i];
            [self.characters[i] animateToCharacter:character];
        }
        // Clears out the padding characters if any
        for (NSUInteger i = [string length]; i < [self.characters count]; i++) {
            [self.characters[i] animateToCharacter:' '];
        }
    });
}

- (void)setText:(NSString*)string
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [self sizeToFitString:string];
    for (int i = 0; i < [string length]; i++) {
        char character = [string characterAtIndex:i];
        [self.characters[i] setToCharacter:character];
    }
    // Clears out the padding characters if any
    for (NSUInteger i = [string length]; i < [self.characters count]; i++) {
        [self.characters[i] setToCharacter:' '];
    }
    //    });
}

- (void)sizeToFitString:(NSString*)string
{
    if ([string length] > [self.characters count]) {
        [self removeAllCharacters];
        [self addCharacters:[string length]];
    }
}

- (void)removeAllCharacters
{
    for (SlotCharacter* character in self.characters) {
        [character removeFromSuperview];
    }
    [self.characters removeAllObjects];
}

- (void)setNumberOfCharacters:(NSUInteger)amount
{
    // If the amount being set is already the amount then do nothing
    if (amount == self.numberOfCharacters) {
        return;
    }

    [self removeAllCharacters];
    [self addCharacters:amount];
}

- (NSUInteger)numberOfCharacters
{
    return self.characters.count;
}

- (void)setFont:(UIFont*)font
{
    _font = font;
    for (SlotCharacter* character in self.characters) {
        [character setFont:font];
    }
}

- (void)setTextColor:(UIColor*)color
{
    _textColor = color;
    for (SlotCharacter* character in self.characters) {
        [character setTextColor:color];
    }
}

- (void)setShadowColor:(UIColor*)color
{
    _shadowColor = color;
    for (SlotCharacter* character in self.characters) {
        [character setShadowColor:color];
    }
}

- (void)setShadowOffset:(CGSize)size
{
    _shadowOffset = size;
    for (SlotCharacter* character in self.characters) {
        [character setShadowOffset:size];
    }
}

- (void)setStrokeColor:(UIColor*)color
{
    _strokeColor = color;
    for (SlotCharacter* character in self.characters) {
        [character setStrokeColor:color];
    }
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    _strokeWidth = strokeWidth;
    for (SlotCharacter* character in self.characters) {
        [character setStrokeWidth:strokeWidth];
    }
}

- (void)setAnimationSpeed:(CGFloat)animationSpeed
{
    _animationSpeed = animationSpeed;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (SlotCharacter* character in self.characters) {
            [character setAnimationSpeed:animationSpeed];
        }
    });
}

- (void)setAnimationColor:(UIColor*)color
{
    _animationColor = color;
    for (SlotCharacter* character in self.characters) {
        character.animationColor = color;
    }
}

- (void)setVerticalAlignment:(UIControlContentVerticalAlignment)alignment
{
    _verticalAlignment = alignment;
    for (SlotCharacter* character in self.characters) {
        [character setVerticalAlignment:alignment];
    }
}

#pragma mark - Private
- (void)addCharacters:(NSInteger)amount
{
    for (int i = 0; i < amount; i++) {
        SlotCharacter* character = [[SlotCharacter alloc] initWithFrame:CGRectMake(self.frame.size.width / amount * i,
                                                                            0,
                                                                            self.frame.size.width / amount,
                                                                            self.frame.size.height)];
        if (i % 2 == 0) {
            [character setBackgroundColor:[UIColor lightGrayColor]];
        }
        [character sizeToFit];
        [self skinCharacter:character];
        [character setToCharacter:' '];
        [self.characters addObject:character];
        [self addSubview:character];
    }
}

- (void)skinCharacter:(SlotCharacter*)character
{
    [character setFont:self.font];
    [character setTextColor:self.textColor];
    [character setShadowColor:self.shadowColor];
    [character setShadowOffset:self.shadowOffset];
    [character setStrokeColor:self.strokeColor];
    [character setStrokeWidth:self.strokeWidth];
    [character setAnimationColor:self.animationColor];
    [character setAnimationSpeed:self.animationSpeed];
    [character setVerticalAlignment:self.verticalAlignment];
}

@end
