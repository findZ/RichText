//
//  ZHRichView.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHRichView.h"
#import "ZHRichLink.h"
#import "ZHRegexResult.h"
#import "ZHAttachmentView.h"
#import "ZHTextAttachment.h"
#import "ZHRichTextParser.h"


#define K_LINK_BACK_GROUND_VIEW_TAG 9999
#define K_ATTACHMENT_TAG  9999999

#define K_RICH_STRING_CONTENT_MAX_WIDTH    self.bounds.size.width



@interface ZHRichView ()
@property (nonatomic, strong) ZHRichTextParser *textParser;
@property (nonatomic, weak) UITextView *textView;
/**选中的*/
@property (nonatomic, strong) ZHRichLink *selectLink;
@end

@implementation ZHRichView
- (ZHRichTextParser *)textParser
{
    if (!_textParser) {
        _textParser = [[ZHRichTextParser alloc] init];
    }
    return _textParser;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}
- (void)setupSubView
{
    UITextView *textView = [[UITextView alloc] init];
    // 修改左右内间距
    textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.userInteractionEnabled = NO;
    textView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:textView];
    self.textView = textView;
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    longPressGr.minimumPressDuration = 1.2;
    [self addGestureRecognizer:longPressGr];
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _textView.frame = self.bounds;
    
}
#pragma mark - seter
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textView.textColor = textColor;
}
- (void)setFont:(UIFont *)font
{
    _font = font;
    self.textView.font = font;
}
- (void)setText:(NSString *)text
{
    _text = text;
    self.attributedText = [self.textParser attributedStringWithString:text];
    
}
- (void)setAttributedText:(NSAttributedString *)attributedText{
    
    _attributedText = attributedText;
    _textView.attributedText = attributedText;
    [self removeAllAttachment];
    self.selectLink = nil;
    
    _links = [self getAllLinks:attributedText];
    
    _attachments = [self getAllAttachment:attributedText];
}

#pragma mark - 内部方法
- (NSArray *)getAllLinks:(NSAttributedString *)attributedString
{
    NSMutableArray *links = [NSMutableArray array];
    
    [attributedString enumerateAttribute:ZHRichLinkUrl inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(ZHRegexResult *value, NSRange range, BOOL * _Nonnull stop) {
        NSString *linkString = value.string;
        if (!linkString.length) return ;//过滤空字符
        //创建一个链接
        ZHRichLink *link = [[ZHRichLink alloc] init];
        link.text = linkString;
        link.range = range;
        link.type = ZHRichLinkTypeURL;
        [links addObject:link];
        
    }];
    [attributedString enumerateAttribute:ZHRichPhoneNumber inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(ZHRegexResult *value, NSRange range, BOOL * _Nonnull stop) {
        NSString *linkString = value.string;
        if (!linkString.length) return ;//过滤空字符
        //创建一个链接
        ZHRichLink *link = [[ZHRichLink alloc] init];
        link.text = linkString;
        link.range = range;
        link.type = ZHRichLinkTypePhoneNumber;
        [links addObject:link];
        
    }];
    
    [attributedString enumerateAttribute:ZHRichEmailAddress inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(ZHRegexResult *value, NSRange range, BOOL * _Nonnull stop) {
     NSString *linkString = value.string;
     if (!linkString.length) return ;//过滤空字符
     //创建一个链接
     ZHRichLink *link = [[ZHRichLink alloc] init];
     link.text = linkString;
     link.range = range;
     link.type = ZHRichLinkTypeEmail;
     [links addObject:link];
     }];
    
    return links;
    
}
- (NSArray *)getAllAttachment:(NSAttributedString *)attributedString
{
    __block CGFloat btnY = 0;
    __weak typeof(self) weakSelf = self;
    NSMutableArray *attachments = [NSMutableArray array];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        if (!attrs[@"NSAttachment"]) {
            NSRange subRange =  NSMakeRange(0, range.location + range.length);
            NSAttributedString *subAttibuted = [attributedString attributedSubstringFromRange:subRange];
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            CGRect rect = [subAttibuted boundingRectWithSize:CGSizeMake(K_RICH_STRING_CONTENT_MAX_WIDTH, 0) options:options context:nil];
            UIFont *font = attrs[NSFontAttributeName];
            btnY = CGRectGetMaxY(rect) - font.lineHeight;
        }
        
        if (attrs[@"NSAttachment"]){
            ZHTextAttachment *attachment = attrs[@"NSAttachment"];
            if (!attachment.emotion) {
                ZHAttachmentView *btn = [[ZHAttachmentView alloc] initWithFrame:CGRectMake(0, btnY, attachment.bounds.size.width, attachment.bounds.size.height)];
                btn.image = attachment.image;
                btn.originalImage = attachment.originalImage;
                btn.tag = K_ATTACHMENT_TAG;
                btn.urlString = attachment.imageUrl;
                [btn addTarget:weakSelf action:@selector(imageBtnClick:)];
                [weakSelf addSubview:btn];
            }
        }
    }];
    return attachments;
}

#pragma mark - 事件响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self];
    ZHRichLink *link = [self touchingLinkWithPoint:point];
    self.selectLink = link;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // 为了能实现单击的响应，应该延时移除视图。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAllLinkBackground];
    });
    [self clickSelectedLink];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeAllLinkBackground];
}

- (void)imageBtnClick:(UITapGestureRecognizer *)tap
{
    ZHAttachmentView *view = (ZHAttachmentView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(didClickImageWithView:)]) {
        [self.delegate didClickImageWithView:view];
    }
}
#pragma mark - 链接处理方法
- (void)clickSelectedLink
{
    if (self.selectLink)
    {//说明手指在某个链接上面
        switch (self.selectLink.type) {
            case ZHRichLinkTypeURL:
                if ([self.delegate respondsToSelector:@selector(didClickLinkWithUrlString:)]) {
                    [self.delegate didClickLinkWithUrlString:self.selectLink.text];
                }
                break;
            case ZHRichLinkTypePhoneNumber:
                if ([self.delegate respondsToSelector:@selector(didClickLinkWithPhoneNumberString:)]) {
                    [self.delegate didClickLinkWithPhoneNumberString:self.selectLink.text];
                }
                break;
            case ZHRichLinkTypeEmail:
                if ([self.delegate respondsToSelector:@selector(didClickLinkWithEmailString:)]) {
                    [self.delegate didClickLinkWithEmailString:self.selectLink.text];
                }
                break;
                
            default:
                break;
        }
    }
}
///根据触摸点找出被触摸的链接
- (ZHRichLink *)touchingLinkWithPoint:(CGPoint)point
{
    BOOL selected = NO;
    
    ZHRichLink *selectedLink = nil;
    for (ZHRichLink *link in self.links) {
        
        self.textView.selectedRange = link.range;
        NSArray *rects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
        self.textView.selectedRange = NSMakeRange(0, 0); // 重置选中范围，只是为了使用选中范围来获取rect而不是真的选中。
        for (UITextSelectionRect *selectionRect in rects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            if (CGRectContainsPoint(rect, point)) {
                selected = YES;
                selectedLink = link;
                break;
            }
        }
        
        if (selected) {
            for (UITextSelectionRect *selectionRect in rects) {
                CGRect rect = selectionRect.rect;
                if (rect.size.width == 0 || rect.size.height == 0) continue;
                
                UIView *cover = [[UIView alloc] initWithFrame:rect];
                cover.layer.cornerRadius = 5;
                cover.backgroundColor = link.selectedColor;
                cover.tag = K_LINK_BACK_GROUND_VIEW_TAG;
                [self insertSubview:cover atIndex:0];
                
            }
            break;
        }
        
    }
    return selectedLink;
}
- (void)removeAllLinkBackground
{
    for (UIView *child in self.subviews) {
        //移除链接的背景
        if (child.tag == K_LINK_BACK_GROUND_VIEW_TAG) {
            [child removeFromSuperview];
        }
    }
}
- (void)removeAllAttachment
{
    for (UIView *view in self.subviews) {
        if (view.tag == K_ATTACHMENT_TAG) {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - copy功能实现
- (void)handleTap:(UILongPressGestureRecognizer *)longPGR
{
    [self becomeFirstResponder];
    if (longPGR.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [longPGR locationInView:self.superview]; //手指点击位置
        CGFloat labelWidth = CGRectGetWidth(self.frame);
        CGFloat labelHeight = CGRectGetHeight(self.frame);
        [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(touchPoint.x - labelWidth / 2, touchPoint.y, labelWidth, labelHeight) inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
// 可以响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}
// 针对响应方法的实现
- (void)copy:(id)sender{
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (self.text) {
        pasteBoard.string = self.text;
    }
}
@end
