/*
 * CCMenuItemLabelAndSprite
 */

#import "CCMenuItemLabelAndSprite.h"

@interface CCMenuItemLabelAndSprite()

- (void) repositionLabel;

@end

@implementation CCMenuItemLabelAndSprite

@synthesize disabledColor = disabledColor_;

+ (id) itemWithLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol>*)label normalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite{
    return [self itemFromLabel:label normalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:nil target:nil selector:nil];
}

+(id) itemFromLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol>*)label normalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite target:(id) r selector:(SEL) s{
    return [self itemFromLabel:label normalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:nil target:r selector:s];
}

+(id) itemFromLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol>*)label normalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite{
    return [self itemFromLabel:label normalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:disabledSprite target:nil selector:nil];
}

+(id) itemFromLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol>*)label normalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite target:(id) r selector:(SEL) s{
    return [[[self alloc] initFromLabel:label normalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:disabledSprite target:r selector:s] autorelease];
}

-(id) initFromLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol>*)label normalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite target:(id) r selector:(SEL) s{
    if ((self = [super initFromNormalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:disabledSprite target:r selector:s])) {
        colorBackup = ccWHITE;
        disabledColor_ = ccWHITE;
        self.label = label;
    }
    return self;
}

#if NS_BLOCKS_AVAILABLE

+(id) itemFromLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol>*)label normalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite block:(void(^)(id sender))block{
    return [self itemFromLabel:label normalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:nil block:block];
}

+(id) itemFromLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol>*)label normalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite block:(void(^)(id sender))block{
    return [[[self alloc ] initFromLabel:label normalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:disabledSprite block:block] autorelease];
}

-(id) initFromLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol>*)label normalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite block:(void(^)(id sender))block{
    block_ = [block copy];
    return [self initFromLabel:label normalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:disabledSprite target:block_ selector:@selector(ccCallbackBlockWithSender:)];
}

#endif // NS_BLOCKS_AVAILABLE

-(CCNode<CCLabelProtocol, CCRGBAProtocol>*) label{
	return label_;
}

-(void) setLabel:(CCNode<CCLabelProtocol, CCRGBAProtocol>*) label{
	if( label != label_ ) {
		[self removeChild:label_ cleanup:YES];
		[self addChild:label];
        
		label_ = label;
        
        [self repositionLabel];
	}
}

-(void) setString:(NSString *)string{
	[label_ setString:string];
    [self repositionLabel];
}

-(void) setPosition:(CGPoint)position{
    [super setPosition:position];
    [self repositionLabel];
}

-(void) repositionLabel{
    label_.position = ccp(normalImage_.position.x - normalImage_.contentSize.width/2, normalImage_.position.y - normalImage_.contentSize.height/2);
}

-(void) selected{
	// subclass to change the default action
	if(isEnabled_) {
		[super selected];
        // Move the label down 1 point to look like the button's pressed.
        label_.position = ccp(label_.position.x, label_.position.y-1);
	}
}

-(void) unselected{
	// subclass to change the default action
	if(isEnabled_) {
		[super unselected];
        // Move the label back up
		label_.position = ccp(label_.position.x, label_.position.y+1);
	}
}

-(void) setIsEnabled: (BOOL)enabled{
	if( isEnabled_ != enabled ) {
		if(enabled == NO) {
			colorBackup = [label_ color];
			[label_ setColor: disabledColor_];
		}
		else
			[label_ setColor:colorBackup];
	}
    
	[super setIsEnabled:enabled];
}

- (void) setOpacity: (GLubyte)opacity{
    [label_ setOpacity:opacity];
}

-(GLubyte) opacity{
	return [label_ opacity];
}

-(void) setColor:(ccColor3B)color{
	[label_ setColor:color];
}

-(ccColor3B) color{
	return [label_ color];
}

@end