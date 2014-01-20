#import "OptsLayer.h"

@implementation OptsLayer

-(id) init{
	self=[super initWithColor:ccc4(0,0,0,255)];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
     float mod = 1;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"title-ipad.png"];
        titleSprite.position = ccp(screenHeight/2,680);
        [self addChild:titleSprite];
        mod = 1.25;
    }
    

    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([[prefs valueForKey:@"orient"] isEqualToString:@"flat"]) {
        
        angled = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"angled.png"] selectedSprite:[CCSprite spriteWithFile:@"angled.png"] disabledSprite:[CCSprite spriteWithFile:@"angled.png"] target:self selector:@selector(onAngled:)];
        
        flat = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"flat_selected.png"] selectedSprite:[CCSprite spriteWithFile:@"flat_selected.png"] disabledSprite:[CCSprite spriteWithFile:@"flat_selected.png"] target:self selector:@selector(onFlat:)];
        
        vertical = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"vertical.png"] selectedSprite:[CCSprite spriteWithFile:@"vertical.png"] disabledSprite:[CCSprite spriteWithFile:@"vertical.png"] target:self selector:@selector(onVertical:)];
    } else if([[prefs valueForKey:@"orient"] isEqualToString:@"vert"]) {
        angled = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"angled.png"] selectedSprite:[CCSprite spriteWithFile:@"angled.png"] disabledSprite:[CCSprite spriteWithFile:@"angled.png"] target:self selector:@selector(onAngled:)];
        
        flat = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"flat.png"] selectedSprite:[CCSprite spriteWithFile:@"flat.png"] disabledSprite:[CCSprite spriteWithFile:@"flat.png"] target:self selector:@selector(onFlat:)];
        
        vertical = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"vertical_selected.png"] selectedSprite:[CCSprite spriteWithFile:@"vertical_selected.png"] disabledSprite:[CCSprite spriteWithFile:@"vertical_selected.png"] target:self selector:@selector(onVertical:)];
        

    } else {
        angled = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"angled_selected.png"] selectedSprite:[CCSprite spriteWithFile:@"angled_selected.png"] disabledSprite:[CCSprite spriteWithFile:@"angled_selected.png"] target:self selector:@selector(onAngled:)];
        
        flat = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"flat.png"] selectedSprite:[CCSprite spriteWithFile:@"flat.png"] disabledSprite:[CCSprite spriteWithFile:@"flat.png"] target:self selector:@selector(onFlat:)];
        
        vertical = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"vertical.png"] selectedSprite:[CCSprite spriteWithFile:@"vertical.png"] disabledSprite:[CCSprite spriteWithFile:@"vertical.png"] target:self selector:@selector(onVertical:)];

    }
    
    CCMenuItemFont *soundText = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"Sound.png"] selectedSprite:[CCSprite spriteWithFile:@"Sound.png"] disabledSprite:[CCSprite spriteWithFile:@"Sound.png"] target:self selector:@selector(onSoundBut:)];

    if([[prefs valueForKey:@"sound"] isEqualToString:@"off"]) {
        soundOnOff = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"off.png"] selectedSprite:[CCSprite spriteWithFile:@"off.png"] disabledSprite:[CCSprite spriteWithFile:@"off.png"] target:self selector:@selector(onSoundBut:)];
    } else {
        soundOnOff = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"on.png"] selectedSprite:[CCSprite spriteWithFile:@"on.png"] disabledSprite:[CCSprite spriteWithFile:@"on.png"] target:self selector:@selector(onSoundBut:)];
    }
    
    CCMenu *soundMenu = [CCMenu menuWithItems:soundText, soundOnOff, nil];
    [soundMenu alignItemsHorizontallyWithPadding:10.0];
    soundMenu.position = ccp(screenHeight/2-(130*mod), screenWidth/2+(112*mod));
    [self addChild:soundMenu z: 2];
    
    CCMenuItemFont *invertedText = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"invert.png"] selectedSprite:[CCSprite spriteWithFile:@"invert.png"] disabledSprite:[CCSprite spriteWithFile:@"invert.png"] target:self selector:@selector(onInvertBut:)];
    
    if([[prefs valueForKey:@"invert"] isEqualToString:@"on"]) {
        invertOnOff = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"on.png"] selectedSprite:[CCSprite spriteWithFile:@"on.png"] disabledSprite:[CCSprite spriteWithFile:@"on.png"] target:self selector:@selector(onInvertBut:)];
    } else {
        invertOnOff = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"off.png"] selectedSprite:[CCSprite spriteWithFile:@"off.png"] disabledSprite:[CCSprite spriteWithFile:@"off.png"] target:self selector:@selector(onInvertBut:)];
    }
    
    CCMenu *invertMenu = [CCMenu menuWithItems:invertedText, invertOnOff, nil];
    [invertMenu alignItemsHorizontallyWithPadding:10.0];
    invertMenu.position = ccp(screenHeight/2+(110*mod), screenWidth/2+(112*mod));
    [self addChild:invertMenu z: 2];
    
	CCMenuItemFont *saveOpts = [CCMenuItemFont itemFromString:@"Done" target:self selector: @selector(saveOpts:)];
  //  CCMenuItemFont *cancelOpts = [CCMenuItemFont itemFromString:@"Cancel" target:self selector: @selector(cancelOpts:)];
    saveOpts.fontName = @"American Typewriter";
    saveOpts.fontSize = 32;
 //   cancelOpts.fontName = @"American Typewriter";
 //   cancelOpts.fontSize = 32;
	menu = [CCMenu menuWithItems:saveOpts, nil];

    
    
    
    CCSprite *orientLabel = [CCSprite spriteWithFile:@"orientation.png"];
    orientLabel.position = ccp(screenHeight/2-(130*mod), screenWidth/2+(70));
    [self addChild:orientLabel];
    
    CCMenu *menu2 = [CCMenu menuWithItems:vertical, angled, flat, nil];
    [menu2 alignItemsHorizontallyWithPadding:(20.0*mod)];
    menu2.position = ccp(screenHeight/2-(65*mod), screenWidth/2-(10*mod));
    [self addChild:menu2 z: 2];
    
	menu.position = ccp(screenHeight/2+(160*mod), screenWidth/2-(100*mod));
	[menu alignItemsHorizontallyWithPadding: 130.0f];
	[self addChild:menu z: 2];
    
	return self;
}

-(void)onVertical:(id)sender {
    [self pickVert];
}

-(void)onAngled:(id)sender {
    [self pickAngled];
}

-(void)onFlat:(id)sender {
    [self pickFlat];
}

- (void)saveOpts:(id)sender{
    [SceneManager goMenu];
}

-(void)onSoundBut:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([[prefs valueForKey:@"sound"] isEqualToString:@"off"]) {
        [soundOnOff setNormalImage:[CCSprite spriteWithFile:@"on.png"]];
        [prefs setValue:@"on" forKey:@"sound"];
        [prefs synchronize];
    } else {
        [soundOnOff setNormalImage:[CCSprite spriteWithFile:@"off.png"]];
        [prefs setValue:@"off" forKey:@"sound"];
        [prefs synchronize];
    }
    
}

-(void)onInvertBut:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([[prefs valueForKey:@"invert"] isEqualToString:@"off"]) {
        [invertOnOff setNormalImage:[CCSprite spriteWithFile:@"on.png"]];
        [prefs setValue:@"on" forKey:@"invert"];
        [prefs synchronize];
    } else {
        [invertOnOff setNormalImage:[CCSprite spriteWithFile:@"off.png"]];
        [prefs setValue:@"off" forKey:@"invert"];
        [prefs synchronize];
    }
    
}

-(void)pickVert {
    [angled setNormalImage:[CCSprite spriteWithFile:@"angled.png"]];
    [flat setNormalImage:[CCSprite spriteWithFile:@"flat.png"]];
    [vertical setNormalImage:[CCSprite spriteWithFile:@"vertical_selected.png"]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:@"vert" forKey:@"orient"];
    [prefs synchronize];
}

-(void)pickAngled {
    [angled setNormalImage:[CCSprite spriteWithFile:@"angled_selected.png"]];
    [flat setNormalImage:[CCSprite spriteWithFile:@"flat.png"]];
    [vertical setNormalImage:[CCSprite spriteWithFile:@"vertical.png"]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:@"angled" forKey:@"orient"];
    [prefs synchronize];
}

-(void)pickFlat {
    [angled setNormalImage:[CCSprite spriteWithFile:@"angled.png"]];
    [flat setNormalImage:[CCSprite spriteWithFile:@"flat_selected.png"]];
    [vertical setNormalImage:[CCSprite spriteWithFile:@"vertical.png"]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:@"flat" forKey:@"orient"];
    [prefs synchronize];
}

- (void)cancelOpts:(id)sender{
	[SceneManager goMenu];
}
@end