#import "ShipLayer.h"

@implementation ShipLayer
@synthesize rightChev, leftChev, rightChevMenu, leftChevMenu;

-(id) init{
	self = [super init];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    currentLoc = 0;
    
    CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"chooser_layout.png"];
    [self addChild:backgroundSprite z:0];
     backgroundSprite.position = ccp(screenHeight/2,screenWidth/2);
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"ship_list" ofType:@"plist"];
    NSArray *shipArray = [NSArray arrayWithContentsOfFile:plistPath];
     NSLog(@"%@", shipArray);
    NSDictionary *shipData = [shipArray objectAtIndex:0];
    
   
    
    CCSprite *shipImage = [CCSprite spriteWithFile:[shipData objectForKey:@"image_name"]];
    shipImage.position = ccp(135,245);
    [self addChild:shipImage z:1];
    
    CCLabelTTF *shipName = [CCLabelTTF labelWithString:[shipData objectForKey:@"name"] fontName:@"American Typewriter" fontSize:26];
    shipName.position = ccp(320, 288);
    [self addChild:shipName z:1];
    
    CCLabelTTF *shipQuote = [CCLabelTTF labelWithString:[shipData objectForKey:@"funny_quote"] dimensions:CGSizeMake(140, 100) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap fontName:@"American Typewriter" fontSize:14];
    shipQuote.position = ccp(124, 130);
    [self addChild:shipQuote z:1];
    
    
    
    CCLabelTTF *shipDesc = [CCLabelTTF labelWithString:[shipData objectForKey:@"description"] dimensions:CGSizeMake(170, 120) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap fontName:@"American Typewriter" fontSize:14];
    shipDesc.position = ccp(320, 130);
    [self addChild:shipDesc z:1];
    
    CCLabelTTF *shipArmor = [CCLabelTTF labelWithString:@"Armor:" dimensions:CGSizeMake(140, 100) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap fontName:@"American Typewriter" fontSize:22];
    shipArmor.position = ccp(300, 210);
    [self addChild:shipArmor z:1];
    
    for(int i = 0; i<[[shipData objectForKey:@"armor"] intValue]; i++) {
        CCSprite *armorDot = [CCSprite spriteWithFile:@"point_dot.png"];
        armorDot.position = ccp(345+(i*16), 245);
        [self addChild:armorDot z:1];
        
    }
    
    CCLabelTTF *shipHandling = [CCLabelTTF labelWithString:@"Handling:" dimensions:CGSizeMake(140, 100) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap fontName:@"American Typewriter" fontSize:22];
    shipHandling.position = ccp(300, 188);
    [self addChild:shipHandling z:1];
    
    for(int i = 0; i<[[shipData objectForKey:@"handling"] intValue]; i++) {
        CCSprite *handlingDot = [CCSprite spriteWithFile:@"point_dot.png"];
        handlingDot.position = ccp(345+(i*16), 223);
        [self addChild:handlingDot z:1];
        
    }
    
    CCLabelTTF *shipSize = [CCLabelTTF labelWithString:@"Size:" dimensions:CGSizeMake(140, 100) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap fontName:@"American Typewriter" fontSize:22];
    shipSize.position = ccp(300, 168);
    [self addChild:shipSize z:1];
    
    for(int i = 0; i<[[shipData objectForKey:@"size"] intValue]; i++) {
        CCSprite *sizeDot = [CCSprite spriteWithFile:@"point_dot.png"];
        sizeDot.position = ccp(345+(i*16), 203);
        [self addChild:sizeDot z:1];
        
    }
    
    /*
if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    /*
    backgroundSprite = [CCSprite spriteWithFile:@"ipad_background.png"];
    backgroundSprite.position = ccp(screenHeight/2,screenWidth/2);
    [self addChild:backgroundSprite];
    
} else {
    /*
    backgroundSprite = [CCSprite spriteWithFile:@"bg1_p2.jpg"];
    backgroundSprite.position = ccp(240,160);
    [self addChild:backgroundSprite];
}*/
    
    /*
    CCSprite *titleSprite = [CCSprite spriteWithFile:@"title.png"];
    titleSprite.position = ccp(240,220);
    [self addChild:titleSprite];*/
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL upgraded = FALSE;
    if([[prefs valueForKey:@"upgraded"] isEqualToString:@"upgraded"]) {
        upgraded = TRUE;
        
    }
    
      //  [CCSprite sp]
    /*
    
	CCLabelTTF *titleCenterTop = [CCLabelTTF labelWithString:@"Space Fighter" fontName:@"American Typewriter" fontSize:32];
    titleCenterTop.color = ccc3(10,255,10);
    
	CCMenuItemFont *startNew = [CCMenuItemFont itemFromString:@"Race!" target:self selector: @selector(onNewGame:)];
    startNew.fontName = @"American Typewriter";
    startNew.fontSize = 34;
	CCMenu *menu = [CCMenu menuWithItems:startNew, nil];
      
 //
//	titleCenterTop.position = ccp(240, 270);
//	[self addChild: titleCenterTop];

    
	menu.position = ccp(390, 50);
	[menu alignItemsVerticallyWithPadding: 20.0f];
	[self addChild:menu z: 2];
    */
/*
    rightChev = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"right_chev.png"] selectedSprite:nil target:self selector:@selector(moveRight:)] retain];
    
    leftChev = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"left_chev.png"] selectedSprite:nil target:self selector:@selector(moveLeft:)] retain];
    */
    /*
    currentMenu3 = [[CCMenu menuWithItems:level3, nil] retain];
    level3Label = [[CCLabelTTF labelWithString:@"Alioth Prime Debris Field" fontName:@"American Typewriter" fontSize:28] retain];
    level3Label.color = ccc3(10,255,10);
    level3Label.position = ccp(screenHeight/2, (screenWidth/2)+100);
    currentMenu3.position = ccp(screenHeight/2, screenWidth/2);
    
    currentMenu4 = [[CCMenu menuWithItems:level4, nil] retain];
    level4Label = [[CCLabelTTF labelWithString:@"Jiāng Mine Field" fontName:@"American Typewriter" fontSize:28] retain];
    level4Label.color = ccc3(10,255,10);
    level4Label.position = ccp(screenHeight/2, (screenWidth/2)+100);
    currentMenu4.position = ccp(screenHeight/2, screenWidth/2);
    
    [self addChild:level1Label];
    [self addChild:currentMenu z: 2];*/
    
    
 //   CCMenu *menuDiff2 = [CCMenu menuWithItems:level3, level4, nil];
  //  CCMenu *menuDiff2 = [CCMenu menuWithItems:level3, level4, nil];
    /*
    CCLabelTTF *level4Label = [CCLabelTTF labelWithString:@"Jiāng Mine Field" fontName:@"American Typewriter" fontSize:20];
    level4Label.color = ccc3(255,255,255);
    level4Label.position = ccp(200, 272);
    [self addChild:level4Label];
    
    menuDiff.position = ccp(200, 250);
   [menuDiff alignItemsHorizontallyWithPadding:60.0f];
    //[menuDiff alignItemsInColumns:[NSNumber numberWithInt:2],[NSNumber numberWithInt:2], nil];
    menuDiff2.position = ccp(200, 90);
    [menuDiff2 alignItemsHorizontallyWithPadding:60.0f];

 //  menuDiff.position = ccp(100, 130);
//    [menuDiff alignItemsInColumns:<#(NSNumber *), ...#>, nil:20.0f];
    
    [self addChild:menuDiff z: 2];
    [self addChild:menuDiff2 z: 2];
    */

    rightChevMenu = [[CCMenu menuWithItems:rightChev, nil] retain];
    leftChevMenu = [[CCMenu menuWithItems:leftChev, nil] retain];
    rightChevMenu.position = ccp(screenHeight-50, screenWidth/2);
    leftChevMenu.position = ccp(50, screenWidth/2);
    [self addChild:rightChevMenu z:3];
	return self;
}

-(void)moveRight:(id)sender {
    
    /*
    NSLog(@"Current Loc: %d",currentLoc);
    if(currentLoc<4) {
        switch (currentLoc) {
            case 0: {
                [self removeChild:self.currentMenu cleanup:YES];
                [self addChild:self.currentMenu2 z:2];
                [self removeChild:self.level1Label cleanup:YES];
                [self addChild:self.level2Label z:2];
                [self addChild:leftChevMenu];
                break;
            }
            case 1: {
                [self removeChild:self.currentMenu2 cleanup:YES];
                [self addChild:self.currentMenu3 z:2];
                [self removeChild:self.level2Label cleanup:YES];
                [self addChild:self.level3Label z:2];
                break;
            }
            case 2: {
                [self removeChild:self.currentMenu3 cleanup:YES];
                [self addChild:self.currentMenu4 z:2];
                [self removeChild:self.level3Label cleanup:YES];
                [self addChild:self.level4Label z:2];
                [self removeChild:self.rightChevMenu cleanup:YES];
                break;
            }
                
        }
    currentLoc++;
    } else {
         [self removeChild:self.rightChevMenu cleanup:YES];
    }
     
     */
}
-(void)moveLeft:(id)sender {
    
    /*
    if(currentLoc>0) {
        switch (currentLoc) {
            case 1: {
                [self removeChild:self.currentMenu2 cleanup:YES];
                [self addChild:self.currentMenu z:2];
                [self removeChild:self.level2Label cleanup:YES];
                [self addChild:self.level1Label z:2];
                [self removeChild:self.leftChevMenu cleanup:YES];
                break;
            }
            case 2: {
                [self removeChild:self.currentMenu3 cleanup:YES];
                [self addChild:self.currentMenu2 z:2];
                [self removeChild:self.level3Label cleanup:YES];
                [self addChild:self.level2Label z:2];
                break;
            }
            case 3: {
                [self removeChild:self.currentMenu4 cleanup:YES];
                [self addChild:self.currentMenu3 z:2];
                [self removeChild:self.level4Label cleanup:YES];
                [self addChild:self.level3Label z:2];
                [self addChild:rightChevMenu];
                break;
            }
        }
        currentLoc--;
    } else {
        [self removeChild:self.leftChevMenu cleanup:YES];
    }
     
     */
}

- (void)onCredits:(id)sender{
	[SceneManager goMenu];
}

-(void)upgrade:(id)sender {
    [SceneManager goBuy];
}

- (void)onNewGame:(id)sender{
	//[SceneManager goGame:map];
}

@end