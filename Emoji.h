#import "../PS.h"

@interface NSMutableAttributedString (Private)
- (void)fixFontAttributeInRange:(NSRange)range;
@end

@interface NSRefCountedRunArray : NSObject // ???
@end

@interface NSAttributeDictionary : NSDictionary
+ (NSAttributeDictionary *)newWithDictionary:(NSDictionary *)dictionary;
@end

@interface NSRLEArray : NSObject <NSCopying, NSMutableCopying> {
	NSRefCountedRunArray *theList;
}
- (id)initWithRefCountedRunArray:(NSRefCountedRunArray *)array;
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index effectiveRange:(NSRange)range;
- (id)objectAtIndex:(NSUInteger)index effectiveRange:(NSRange)range runIndex:(NSUInteger)runIndex;
@end

@interface NSMutableRLEArray : NSRLEArray
- (void)replaceObjectsInRange:(NSRange *)range withObject:(id)object length:(NSUInteger)length;
@end

@interface NSConcreteMutableAttributedString : NSMutableAttributedString {
	NSDictionary *mutableAttributes;
}
- (id)initWithString:(NSString *)string attributes:(NSAttributeDictionary *)attributes;
- (id)initWithAttributedString:(NSMutableAttributedString *)attributedString;
@end

@interface NSConcreteAttributedString : NSAttributedString
@end

@interface NSConcreteNotifyingMutableAttributedString : NSConcreteMutableAttributedString
@end

@interface NSConcreteTextStorage : NSTextStorage // coordinateEditing
- (void)removeAttribute:(NSString *)attribute range:(NSRange)range;
- (void)addAttribute:(NSString *)attribute value:(id)value range:(NSRange)range;
@end

@interface CKTextStorage : NSTextStorage
@end

@interface _UICascadingTextStorage : NSConcreteTextStorage
@property(retain, nonatomic) NSDictionary *defaultAttributes;
@property(retain, nonatomic) UIFont *font;
- (id)attribute:(NSString *)attribute atIndex:(NSUInteger)index effectiveRange:(NSRange)range;
- (NSAttributeDictionary *)attributesAtIndex:(NSUInteger)index effectiveRange:(NSRange)range;
- (void)setAttributes:(NSAttributeDictionary *)attributes range:(NSRange)range;
@end

@interface UIFieldEditor : NSObject
@property(retain, nonatomic) NSString *text;
@end

@interface NSCharacterSet (Private)
- (NSUInteger)count;
@end

@interface NSString (Private)
- (BOOL)_containsEmoji;
@end

@protocol textInputDelegate
- (NSString *)text;
@end

@interface UIKBScreenTraits : NSObject
+ (UIKBScreenTraits *)traitsWithScreen:(UIScreen *)screen orientation:(int)orientation;
@property(retain, nonatomic) id orientationKey; // iOS < 8
@end

@interface UIKBDimmingView : UIView
@end

@interface UIKeyboardInputMode : NSObject
@property(retain, nonatomic) NSString *identifier;
@end

@interface UIKBRenderFactory : NSObject
+ (BOOL)_enabled;
@end

@interface UIKBKeyplaneView : UIView
@end

@interface UIKBRenderConfig : NSObject
@end

@interface UIKBRenderGeometry : NSObject
@property CGRect paddedFrame;
@property CGRect displayFrame;
@property CGRect symbolFrame;
@property CGRect frame;
@end

@interface UIKBGeometry : NSObject
@property float x;
@property float y;
@property float w;
@property float h;
@property CGRect frame;
@property CGRect paddedFrame;
@end

@interface UIKBShape : NSObject
@property(retain, nonatomic) UIKBGeometry *geometry;
@property CGRect paddedFrame;
@property CGRect symbolFrame;
@property CGRect frame;
- (CGRect)originalFrame;
@end

@interface UIKBRenderTraits : NSObject
@property(retain, nonatomic) UIKBRenderGeometry *geometry;
@property(retain, nonatomic) NSArray *variantGeometries;
@end

@interface UIKBTree : NSObject
@property unsigned int interactionType;
@property unsigned int rendering;
@property int highlightedVariantIndex;
@property int state;
@property CGRect frame;
@property(retain, nonatomic) NSString *displayString;
@property(retain, nonatomic) NSString *representedString;
@property(retain, nonatomic) NSMutableArray *subtrees;
@property(retain, nonatomic) UIKBRenderGeometry *geometry;
@property(retain, nonatomic) UIKBShape *shape;
@property(retain, nonatomic) NSMutableDictionary *properties;
- (id)initWithType:(int)type;
- (NSString *)name;
- (BOOL)_renderAsStringKey;
- (UIKBTree *)subtreeWithName:(NSString *)name;
- (CGRect)_keyplaneFrame;
@end

@interface UIKeyboard : NSObject
+ (UIKeyboard *)activeKeyboard;
- (int)interfaceOrientation;
@end

@interface UIKBKeyView : UIView {
	UIKBTree *m_key;
}
@property CGRect drawFrame;
@property(retain, nonatomic) UIKBTree *key;
@property(retain, nonatomic) UIKBTree *keyplane;

- (void)emoji83_positionFixForKeyplane:(UIKBTree *)keyplane key:(UIKBTree *)key withFrame:(CGRect *)beforeFrame;
@end

@interface UIKeyboardLayoutStar : NSObject
+ (Class)_subclassForScreenTraits:(UIKBScreenTraits *)traits;
+ (UIKBTree *)keyboardFromFactoryWithName:(NSString *)name screen:(UIScreen *)screen;
+ (CGSize)keyboardSizeForInputMode:(UIKeyboardInputMode *)inputMode screenTraits:(UIKBScreenTraits *)traits;
- (int)orientation;
@end

@interface UIKeyboardImpl : NSObject
+ (UIScreen *)keyboardScreen;
+ (Class)layoutClassForCurrentInputMode;
+ (id)orientationKeyForOrientation:(int)orientation; // iOS < 8
- (id <textInputDelegate> )inputDelegate;
- (UIKeyboardLayoutStar *)_layout;
@end

@interface UIKeyboardEmojiCategory : NSObject {
	int _categoryType;
	NSArray *_emoji;
	int _lastVisibleFirstEmojiIndex;
}
@property int categoryType;
@property(getter=displaySymbol, readonly) NSString *displaySymbol;
@property(getter=displayName, readonly) NSString *displayName; // iOS 7
@property(retain) NSArray *emoji;
@property NSUInteger lastVisibleFirstEmojiIndex;
@property(getter=name,readonly) NSString *name;
@property(getter=recentDescription,readonly) NSString *recentDescription; // iOS 7+
+ (NSMutableArray *)categories;
+ (UIKeyboardEmojiCategory *)categoryForType:(int)categoryType;
+ (NSArray *)emojiRecentsFromPreferences;
+ (BOOL)hasVariantsForEmoji:(NSString *)emoji; // iOS 7+
+ (NSString *)localizedStringForKey:(NSString *)key;
+ (NSInteger)numberOfCategories;
- (NSString *)displaySymbol;
- (void)releaseCategories;
@end

@interface UIKeyboardEmoji : NSObject {
	NSString *_emojiString;
	BOOL _hasDingbat;
}
@property(retain) NSString *emojiString;
@property BOOL hasDingbat;
@property(assign) unsigned short glyph; // iOS < 7
+ (UIKeyboardEmoji *)emojiWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
+ (UIKeyboardEmoji *)emojiWithString:(NSString *)string hasDingbat:(bool)dingbat; // iOS 7+
- (id)initWithString:(NSString *)string hasDingbat:(bool)dingbat; // iOS 7+
- (BOOL)isEqual:(UIKeyboardEmoji *)emoji;
- (NSString *)key; // emojiString
@end

@interface UIKeyboardEmojiPage : UIView {
	NSInteger _numCols;
	NSInteger _numRows;
	NSInteger _numPages;
}
@property(retain, nonatomic) NSDictionary *emojiAttributes;
@property(retain, nonatomic) NSArray *emoji;
- (CGRect)rectForRow:(NSInteger)row Col:(NSInteger)col;
@end

@interface UIKeyboardEmojiImageView : UIImageView
@end

@protocol UIKeyboardEmojiPressIndicationDelegate;

@interface UIKeyboardEmojiView : UIControl {
	UIKeyboardEmoji *_emoji;
	UIView *_popup;
	UIKeyboardEmojiImageView *_imageView;
	UIKBRenderConfig *_renderConfig;
	UIView <UIKeyboardEmojiPressIndicationDelegate> *_delegate;
}
@property (retain) UIKeyboardEmoji *emoji;
@property (nonatomic, retain) UIKBRenderConfig *renderConfig;
@property (retain) UIView <UIKeyboardEmojiPressIndicationDelegate> *delegate;
@property (retain) UIView *popup;
@property (retain) UIKeyboardEmojiImageView *imageView;
+ (UIKeyboardEmojiView *)emojiViewForEmoji:(UIKeyboardEmoji *)emoji withFrame:(CGRect)frame;
+ (void)recycleEmojiView:(UIKeyboardEmojiImageView *)emojiView;
- (void)uninstallPopup;
- (id)createAndInstallKeyPopupView;
- (UIView *)popup;
- (void)setEmoji:(UIKeyboardEmoji *)emoji withFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame emoji:(UIKeyboardEmoji *)emoji;
@end

@interface UIKeyboardEmojiGraphics : NSObject
+ (UIImage *)imageWithRect:(CGRect)rect name:(NSString *)name pressed:(BOOL)presed;
- (UIImage *)categoryRecentsGenerator:(id)pressed;
- (UIImage *)categoryPeopleGenerator:(id)pressed;
- (UIImage *)categoryNatureGenerator:(id)pressed;
- (UIImage *)categoryObjectsGenerator:(id)pressed;
- (UIImage *)categoryPlacesGenerator:(id)pressed;
- (UIImage *)categorySymbolsGenerator:(id)pressed;
- (UIImage *)categoryWithSymbol:(NSString *)symbol pressed:(id)pressed;
@end

@interface UIKeyboardEmojiCategoryBar : UIKBKeyView {
	NSArray *_dividerViews;
	NSArray *_segmentViews;
	int _total;
	int _dividerTotal;
}
@end

@interface UIKeyboardEmojiCategoryBar_iPhone : UIKeyboardEmojiCategoryBar {
	NSArray *_unselectedImages;
	NSArray *_selectedImages;
}
- (void)updateSegmentImages;
@end

@interface NSString (Addition)
+ (NSString *)stringWithUnichar:(unsigned long)aChar;
- (unichar)_firstLongCharacter;
@end

@interface TIKeyboardLayoutFactory : NSObject {
	void *_layoutsLibraryHandle;
}
+ (TIKeyboardLayoutFactory *)sharedKeyboardFactory;
+ (NSString *)layoutsFileName;
@property(readonly, nonatomic) void *layoutsLibraryHandle;
@property(retain) NSMutableDictionary *internalCache;
- (UIKBTree *)keyboardWithName:(NSString *)name inCache:(NSMutableDictionary *)cache;
@end

static unsigned long PeopleEmoji[] = {
	0x1F600, 0, 0x1F601, 0, 0x1F602, 0, 0x1F603, 0, 0x1F604, 0, 0x1F605, 0, 0x1F606, 0, 0x1F607, 0, 0x1F608, 0,
	0x1F47F, 0, 0x1F609, 0, 0x1F60A, 0, 0x263A, 0, 0x1F60B,	0, 0x1F60C, 0, 0x1F60D, 0, 0x1F60E, 0, 0x1F60F, 0,
	0x1F610, 0, 0x1F611, 0, 0x1F612, 0, 0x1F613, 0, 0x1F614, 0, 0x1F615, 0, 0x1F616, 0, 0x1F617, 0, 0x1F618, 0,
	0x1F619, 0, 0x1F61A, 0, 0x1F61B, 0, 0x1F61C, 0, 0x1F61D, 0, 0x1F61E, 0, 0x1F61F, 0, 0x1F620, 0, 0x1F621, 0,
	0x1F622, 0, 0x1F623, 0, 0x1F624, 0, 0x1F625, 0, 0x1F626, 0, 0x1F627, 0, 0x1F628, 0, 0x1F629, 0, 0x1F62A, 0,
	0x1F62B, 0, 0x1F62C, 0, 0x1F62D, 0, 0x1F62E, 0, 0x1F62F, 0, 0x1F630, 0, 0x1F631, 0, 0x1F632, 0, 0x1F633, 0,
	0x1F634, 0, 0x1F635, 0, 0x1F636, 0, 0x1F637, 0, 0x1F638, 0, 0x1F639, 0, 0x1F63A, 0, 0x1F63B, 0, 0x1F63C, 0,
	0x1F63D, 0, 0x1F63E, 0, 0x1F63F, 0, 0x1F640, 0, 0x1F463, 0, 0x1F464, 0, 0x1F465, 0, 0x1F476, 0, 0x1F466, 0,
	0x1F467, 0, 0x1F468, 0, 0x1F469, 0, 0x1F46A, 0, 0x1F46B, 0, 0x1F46C, 0, 0x1F46D, 0, 0x1F46F, 0, 0x1F470, 0,
	0x1F471, 0, 0x1F472, 0, 0x1F473, 0, 0x1F474, 0, 0x1F475, 0, 0x1F46E, 0, 0x1F477, 0, 0x1F478, 0, 0x1F482, 0,
	0x1F47C, 0, 0x1F385, 0, 0x1F47B, 0, 0x1F479, 0, 0x1F47A, 0, 0x1F4A9, 0, 0x1F480, 0, 0x1F47D, 0, 0x1F47E, 0,
	0x1F647, 0, 0x1F481, 0, 0x1F645, 0, 0x1F646, 0, 0x1F64B, 0, 0x1F64E, 0, 0x1F64D, 0, 0x1F486, 0, 0x1F487, 0,
	0x1F491, 0, 0x1F48F, 0, 0x1F64C, 0, 0x1F44F, 0, 0x1F442, 0, 0x1F440, 0, 0x1F443, 0, 0x1F444, 0, 0x1F48B, 0,
	0x1F445, 0, 0x1F485, 0, 0x1F44B, 0, 0x1F44D, 0, 0x1F44E, 0, 0x261D, 0, 0x1F446, 0, 0x1F447, 0, 0x1F448, 0,
	0x1F449, 0, 0x1F44C, 0, 0x270C, 0, 0x1F44A, 0, 0x270A, 0, 0x270B, 0, 0x1F4AA, 0, 0x1F450, 0, 0x1F64F, 0,
	0x1F596, 0
};

static unsigned long NatureEmoji[] = {
	0x1F331, 0, 0x1F332, 0, 0x1F333, 0, 0x1F334, 0, 0x1F335, 0, 0x1F337, 0, 0x1F338, 0, 0x1F339, 0, 0x1F33A, 0, 
	0x1F33B, 0, 0x1F33C, 0, 0x1F490, 0, 0x1F33E, 0, 0x1F33F, 0, 0x1F340, 0, 0x1F341, 0, 0x1F342, 0, 0x1F343, 0, 
	0x1F344, 0, 0x1F330, 0, 0x1F400, 0, 0x1F401, 0, 0x1F42D, 0, 0x1F439, 0, 0x1F402, 0, 0x1F403, 0, 0x1F404, 0, 
	0x1F42E, 0, 0x1F405, 0, 0x1F406, 0, 0x1F42F, 0, 0x1F407, 0, 0x1F430, 0, 0x1F408, 0, 0x1F431, 0, 0x1F40E, 0, 
	0x1F434, 0, 0x1F40F, 0, 0x1F411, 0, 0x1F410, 0, 0x1F413, 0, 0x1F414, 0, 0x1F424, 0, 0x1F423, 0, 0x1F425, 0, 
	0x1F426, 0, 0x1F427, 0, 0x1F418, 0, 0x1F42A, 0, 0x1F42B, 0, 0x1F417, 0, 0x1F416, 0, 0x1F437, 0, 0x1F43D, 0, 
	0x1F415, 0, 0x1F429, 0, 0x1F436, 0, 0x1F43A, 0, 0x1F43B, 0, 0x1F428, 0, 0x1F43C, 0, 0x1F435, 0, 0x1F648, 0, 
	0x1F649, 0, 0x1F64A, 0, 0x1F412, 0, 0x1F409, 0, 0x1F432, 0, 0x1F40A, 0, 0x1F40D, 0, 0x1F422, 0, 0x1F438, 0, 
	0x1F40B, 0, 0x1F433, 0, 0x1F42C, 0, 0x1F419, 0, 0x1F41F, 0, 0x1F420, 0, 0x1F421, 0, 0x1F41A, 0, 0x1F40C, 0, 
	0x1F41B, 0, 0x1F41C, 0, 0x1F41D, 0, 0x1F41E, 0, 0x1F43E, 0, 0x26A1, 0, 0x1F525, 0, 0x1F319, 0, 0x2600, 0,
	0x26C5, 0, 0x2601, 0, 0x1F4A7, 0, 0x1F4A6, 0, 0x2614, 0, 0x1F4A8, 0, 0x2744, 0, 0x1F31F, 0, 0x2B50, 0,
	0x1F320, 0, 0x1F304, 0, 0x1F305, 0, 0x1F308, 0, 0x1F30A, 0, 0x1F30B, 0, 0x1F30C, 0, 0x1F5FB, 0, 0x1F5FE, 0,
	0x1F310, 0, 0x1F30D, 0, 0x1F30E, 0, 0x1F30F, 0, 0x1F311, 0, 0x1F312, 0, 0x1F313, 0, 0x1F314, 0, 0x1F315, 0,
	0x1F316, 0, 0x1F317, 0, 0x1F318, 0, 0x1F31A, 0, 0x1F31D, 0, 0x1F31B, 0, 0x1F31C, 0, 0x1F31E, 0
};

static unsigned long FoodAndDrinkEmoji[] = {
	0x1F345, 0, 0x1F346, 0, 0x1F33D, 0, 0x1F360, 0, 0x1F347, 0, 0x1F348, 0, 0x1F349, 0, 0x1F34A, 0, 0x1F34B, 0, 
	0x1F34C, 0, 0x1F34D, 0, 0x1F34E, 0, 0x1F34F, 0, 0x1F350, 0, 0x1F351, 0, 0x1F352, 0, 0x1F353, 0, 0x1F354, 0, 
	0x1F355, 0, 0x1F356, 0, 0x1F357, 0, 0x1F358, 0, 0x1F359, 0, 0x1F35A, 0, 0x1F35B, 0, 0x1F35C, 0, 0x1F35D, 0, 
	0x1F35E, 0, 0x1F35F, 0, 0x1F361, 0, 0x1F362, 0, 0x1F363, 0, 0x1F364, 0, 0x1F365, 0, 0x1F366, 0, 0x1F367, 0, 
	0x1F368, 0, 0x1F369, 0, 0x1F36A, 0, 0x1F36B, 0, 0x1F36C, 0, 0x1F36D, 0, 0x1F36E, 0, 0x1F36F, 0, 0x1F370, 0, 
	0x1F371, 0, 0x1F372, 0, 0x1F373, 0, 0x1F374, 0, 0x1F375, 0, 0x2615, 0, 0x1F376, 0, 0x1F377, 0, 0x1F378, 0,
	0x1F379, 0, 0x1F37A, 0, 0x1F37B, 0, 0x1F37C, 0
};

static unsigned long CelebrationEmoji[] = {
	0x1F380, 0, 0x1F381, 0, 0x1F382, 0, 0x1F383, 0, 0x1F384, 0, 0x1F38B, 0, 0x1F38D, 0, 0x1F391, 0, 0x1F386, 0, 
	0x1F387, 0, 0x1F389, 0, 0x1F38A, 0, 0x1F388, 0, 0x1F4AB, 0, 0x2728, 0, 0x1F4A5, 0, 0x1F393, 0, 0x1F451, 0,
	0x1F38E, 0, 0x1F38F, 0, 0x1F390, 0, 0x1F38C, 0, 0x1F3EE, 0, 0x1F48D, 0, 0x2764, 0, 0x1F494, 0, 0x1F48C, 0,
	0x1F495, 0, 0x1F49E, 0, 0x1F493, 0, 0x1F497, 0, 0x1F496, 0, 0x1F498, 0, 0x1F49D, 0, 0x1F49F, 0, 0x1F49C, 0,
	0x1F49B, 0, 0x1F49A, 0, 0x1F499, 0
};

static unsigned long ActivityEmoji[] = {
	0x1F3C3, 0, 0x1F6B6, 0, 0x1F483, 0, 0x1F6A3, 0, 0x1F3CA, 0, 0x1F3C4, 0, 0x1F6C0, 0, 0x1F3C2, 0, 0x1F3BF, 0, 
	0x26C4, 0, 0x1F6B4, 0, 0x1F6B5, 0, 0x1F3C7, 0, 0x26FA, 0, 0x1F3A3, 0, 0x26BD, 0, 0x1F3C0, 0, 0x1F3C8, 0,
	0x26BE, 0, 0x1F3BE, 0, 0x1F3C9, 0, 0x26F3, 0, 0x1F3C6, 0, 0x1F3BD, 0, 0x1F3C1, 0, 0x1F3B9, 0, 0x1F3B8, 0,
	0x1F3BB, 0, 0x1F3B7, 0, 0x1F3BA, 0, 0x1F3B5, 0, 0x1F3B6, 0, 0x1F3BC, 0, 0x1F3A7, 0, 0x1F3A4, 0, 0x1F3AD, 0,
	0x1F3AB, 0, 0x1F3A9, 0, 0x1F3AA, 0, 0x1F3AC, 0, 0x1F3A8, 0, 0x1F3AF, 0, 0x1F3B1, 0, 0x1F3B3, 0, 0x1F3B0, 0,
	0x1F3B2, 0, 0x1F3AE, 0, 0x1F3B4, 0, 0x1F0CF, 0, 0x1F004, 0, 0x1F3A0, 0, 0x1F3A1, 0, 0x1F3A2, 0
};

static unsigned long TravelAndPlacesEmoji[] = {
	0x1F683, 0, 0x1F69E, 0, 0x1F682, 0, 0x1F68B, 0, 0x1F69D, 0, 0x1F684, 0, 0x1F685, 0, 0x1F686, 0, 0x1F687, 0,
	0x1F688, 0, 0x1F689, 0, 0x1F68A, 0, 0x1F68C, 0, 0x1F68D, 0, 0x1F68E, 0,	0x1F690, 0, 0x1F691, 0, 0x1F692, 0,
	0x1F693, 0, 0x1F694, 0, 0x1F6A8, 0, 0x1F695, 0, 0x1F696, 0, 0x1F697, 0,	0x1F698, 0, 0x1F699, 0, 0x1F69A, 0,
	0x1F69B, 0, 0x1F69C, 0, 0x1F6B2, 0, 0x1F68F, 0, 0x26FD, 0, 0x1F6A7, 0,	0x1F6A6, 0, 0x1F6A5, 0, 0x1F680, 0,
	0x1F681, 0, 0x2708, 0, 0x1F4BA, 0, 0x2693, 0, 0x1F6A2, 0, 0x1F6A4, 0, 0x26F5, 0, 0x1F6A1, 0, 0x1F6A0, 0,
	0x1F69F, 0, 0x1F6C2, 0, 0x1F6C3, 0, 0x1F6C4, 0, 0x1F6C5, 0, 0x1F4B4, 0,	0x1F4B6, 0, 0x1F4B7, 0, 0x1F4B5, 0,
	0x1F5FD, 0, 0x1F5FF, 0, 0x1F301, 0, 0x1F5FC, 0, 0x26F2, 0, 0x1F3F0, 0, 0x1F3EF, 0, 0x1F307, 0, 0x1F306, 0,
	0x1F303, 0, 0x1F309, 0, 0x1F3E0, 0, 0x1F3E1, 0, 0x1F3E2, 0, 0x1F3EC, 0,	0x1F3ED, 0, 0x1F3E3, 0, 0x1F3E4, 0,
	0x1F3E5, 0, 0x1F3E6, 0, 0x1F3E8, 0, 0x1F3E9, 0, 0x1F492, 0, 0x26EA, 0, 0x1F3EA, 0, 0x1F3EB, 0, 0x1F1E6,
	0x1F1FA, 0x1F1E6, 0x1F1F9, 0x1F1E7, 0x1F1EA, 0x1F1E7, 0x1F1F7, 0x1F1E8,	0x1F1E6, 0x1F1E8, 0x1F1F1, 0x1F1E8,
	0x1F1F3, 0x1F1E8, 0x1F1F4, 0x1F1E9, 0x1F1F0, 0x1F1EB, 0x1F1EE, 0x1F1EB,	0x1F1F7, 0x1F1E9, 0x1F1EA, 0x1F1ED,
	0x1F1F0, 0x1F1EE, 0x1F1F3, 0x1F1EE, 0x1F1E9, 0x1F1EE, 0x1F1EA, 0x1F1EE,	0x1F1F1, 0x1F1EE, 0x1F1F9, 0x1F1EF,
	0x1F1F5, 0x1F1F0, 0x1F1F7, 0x1F1F2, 0x1F1F4, 0x1F1F2, 0x1F1FE, 0x1F1F2,	0x1F1FD, 0x1F1F3, 0x1F1F1, 0x1F1F3,
	0x1F1FF, 0x1F1F3, 0x1F1F4, 0x1F1F5, 0x1F1ED, 0x1F1F5, 0x1F1F1, 0x1F1F5,	0x1F1F9, 0x1F1F5, 0x1F1F7, 0x1F1F7,
	0x1F1FA, 0x1F1F8, 0x1F1E6, 0x1F1F8, 0x1F1EC, 0x1F1FF, 0x1F1E6, 0x1F1EA,	0x1F1F8, 0x1F1F8, 0x1F1EA, 0x1F1E8,
	0x1F1ED, 0x1F1F9, 0x1F1F7, 0x1F1EC, 0x1F1E7, 0x1F1FA, 0x1F1F8, 0x1F1E6,	0x1F1EA, 0x1F1FB, 0x1F1F3
};

static unsigned long ObjectsAndSymbolsEmoji[] = {
	0x231A, 0, 0x1F4F1, 0, 0x1F4F2, 0, 0x1F4BB, 0, 0x23F0, 0, 0x23F3, 0, 0x231B, 0, 0x1F4F7, 0,
	0x1F4F9, 0, 0x1F3A5, 0, 0x1F4FA, 0, 0x1F4FB, 0, 0x1F4DF, 0, 0x1F4DE, 0, 0x260E, 0, 0x1F4E0, 0,
	0x1F4BD, 0, 0x1F4BE, 0, 0x1F4BF, 0, 0x1F4C0, 0, 0x1F4FC, 0, 0x1F50B, 0, 0x1F50C, 0, 0x1F4A1, 0,
	0x1F526, 0, 0x1F4E1, 0, 0x1F4B3, 0, 0x1F4B8, 0, 0x1F4B0, 0, 0x1F48E, 0, 0x1F302, 0, 0x1F45D, 0,
	0x1F45B, 0, 0x1F45C, 0, 0x1F4BC, 0, 0x1F392, 0, 0x1F484, 0, 0x1F453, 0, 0x1F452, 0, 0x1F461, 0,
	0x1F460, 0, 0x1F462, 0, 0x1F45E, 0, 0x1F45F, 0, 0x1F459, 0, 0x1F457, 0, 0x1F458, 0, 0x1F45A, 0,
	0x1F455, 0, 0x1F454, 0, 0x1F456, 0, 0x1F6AA, 0, 0x1F6BF, 0, 0x1F6C1, 0, 0x1F6BD, 0, 0x1F488, 0,
	0x1F489, 0, 0x1F48A, 0, 0x1F52C, 0, 0x1F52D, 0, 0x1F52E, 0, 0x1F527, 0, 0x1F52A, 0, 0x1F529, 0,
	0x1F528, 0, 0x1F4A3, 0, 0x1F6AC, 0, 0x1F52B, 0, 0x1F516, 0, 0x1F4F0, 0, 0x1F511, 0, 0x2709, 0,
	0x1F4E9, 0, 0x1F4E8, 0, 0x1F4E7, 0, 0x1F4E5, 0, 0x1F4E4, 0, 0x1F4E6, 0, 0x1F4EF, 0, 0x1F4EE, 0,
	0x1F4EA, 0, 0x1F4EB, 0, 0x1F4EC, 0, 0x1F4ED, 0, 0x1F4C4, 0, 0x1F4C3, 0, 0x1F4D1, 0, 0x1F4C8, 0,
	0x1F4C9, 0, 0x1F4CA, 0, 0x1F4C5, 0, 0x1F4C6, 0, 0x1F505, 0, 0x1F506, 0, 0x1F4DC, 0, 0x1F4CB, 0,
	0x1F4D6, 0, 0x1F4D3, 0, 0x1F4D4, 0, 0x1F4D2, 0, 0x1F4D5, 0, 0x1F4D7, 0, 0x1F4D8, 0, 0x1F4D9, 0,
	0x1F4DA, 0, 0x1F4C7, 0, 0x1F517, 0, 0x1F4CE, 0, 0x1F4CC, 0, 0x2702, 0, 0x1F4D0, 0, 0x1F4CD, 0,
	0x1F4CF, 0, 0x1F6A9, 0, 0x1F4C1, 0, 0x1F4C2, 0, 0x2712, 0, 0x270F, 0, 0x1F4DD, 0, 0x1F50F, 0,
	0x1F510, 0, 0x1F512, 0, 0x1F513, 0, 0x1F4E3, 0, 0x1F4E2, 0, 0x1F508, 0, 0x1F509, 0, 0x1F50A, 0,
	0x1F507, 0, 0x1F4A4, 0, 0x1F514, 0, 0x1F515, 0, 0x1F4AD, 0, 0x1F4AC, 0, 0x1F6B8, 0, 0x1F50D, 0,
	0x1F50E, 0, 0x1F6AB, 0, 0x26D4, 0, 0x1F4DB, 0, 0x1F6B7, 0, 0x1F6AF, 0, 0x1F6B3, 0, 0x1F6B1, 0,
	0x1F4F5, 0, 0x1F51E, 0, 0x1F251, 0, 0x1F250, 0, 0x1F4AE, 0, 0x3299, 0, 0x3297, 0, 0x1F234, 0,
	0x1F235, 0, 0x1F232, 0, 0x1F236, 0, 0x1F21A, 0, 0x1F238, 0, 0x1F23A, 0, 0x1F237, 0, 0x1F239, 0,
	0x1F233, 0, 0x1F202, 0, 0x1F201, 0, 0x1F22F, 0, 0x1F4B9, 0, 0x2747, 0, 0x2733, 0, 0x274E, 0,
	0x2705, 0, 0x2734, 0, 0x1F4F3, 0, 0x1F4F4, 0, 0x1F19A, 0, 0x1F170, 0, 0x1F171, 0, 0x1F18E, 0,
	0x1F191, 0, 0x1F17E, 0, 0x1F198, 0, 0x1F194, 0, 0x1F17F, 0, 0x1F6BE, 0, 0x1F192, 0, 0x1F193, 0,
	0x1F195, 0, 0x1F196, 0, 0x1F197, 0, 0x1F199, 0, 0x1F3E7, 0, 0x2648, 0, 0x2649, 0, 0x264A, 0,
	0x264B, 0, 0x264C, 0, 0x264D, 0, 0x264E, 0, 0x264F, 0, 0x2650, 0, 0x2651, 0, 0x2652, 0,
	0x2653, 0, 0x1F6BB, 0, 0x1F6B9, 0, 0x1F6BA, 0, 0x1F6BC, 0, 0x267F, 0, 0x1F6B0, 0, 0x1F6AD, 0,
	0x1F6AE, 0, 0x25B6, 0, 0x25C0, 0, 0x1F53C, 0, 0x1F53D, 0, 0x23E9, 0, 0x23EA, 0, 0x23EB, 0,
	0x23EC, 0, 0x27A1, 0, 0x2B05, 0, 0x2B06, 0, 0x2B07, 0, 0x2197, 0, 0x2198, 0, 0x2199, 0,
	0x2196, 0, 0x2195, 0, 0x2194, 0, 0x1F504, 0, 0x21AA, 0, 0x21A9, 0, 0x2934, 0, 0x2935, 0,
	0x1F500, 0, 0x1F501, 0, 0x1F502, 0, 0x23, 0x20E3, 0x30, 0x20E3, 0x31, 0x20E3, 0x32, 0x20E3, 0x33, 0x20E3,
	0x34, 0x20E3, 0x35, 0x20E3, 0x36, 0x20E3, 0x37, 0x20E3, 0x38, 0x20E3, 0x39, 0x20E3, 0x1F51F, 0, 0x1F522, 0,
	0x1F524, 0, 0x1F521, 0, 0x1F520, 0, 0x2139, 0, 0x1F4F6, 0, 0x1F3A6, 0, 0x1F523, 0, 0x2795, 0,
	0x2796, 0, 0x3030, 0, 0x2797, 0, 0x2716, 0, 0x2714, 0, 0x1F503, 0, 0x2122, 0, 0xA9, 0,
	0xAE, 0, 0x1F4B1, 0, 0x1F4B2, 0, 0x27B0, 0, 0x27BF, 0, 0x303D, 0, 0x2757, 0, 0x2753, 0,
	0x2755, 0, 0x2754, 0, 0x203C, 0, 0x2049, 0, 0x274C, 0, 0x2B55, 0, 0x1F4AF, 0, 0x1F51A, 0,
	0x1F519, 0, 0x1F51B, 0, 0x1F51D, 0, 0x1F51C, 0, 0x1F300, 0, 0x24C2, 0, 0x26CE, 0, 0x1F52F, 0,
	0x1F530, 0, 0x1F531, 0, 0x26A0, 0, 0x2668, 0, 0x267B, 0, 0x1F4A2, 0, 0x1F4A0, 0, 0x2660, 0,
	0x2663, 0, 0x2665, 0, 0x2666, 0, 0x2611, 0, 0x26AA, 0, 0x26AB, 0, 0x1F518, 0, 0x1F534, 0,
	0x1F535, 0, 0x1F53A, 0, 0x1F53B, 0, 0x1F538, 0, 0x1F539, 0, 0x1F536, 0, 0x1F537, 0, 0x25AA, 0,
	0x25AB, 0, 0x2B1B, 0, 0x2B1C, 0, 0x25FC, 0, 0x25FB, 0, 0x25FE, 0, 0x25FD, 0, 0x1F532, 0,
	0x1F533, 0, 0x1F550, 0, 0x1F551, 0, 0x1F552, 0, 0x1F553, 0, 0x1F554, 0, 0x1F555, 0, 0x1F556, 0,
	0x1F557, 0, 0x1F558, 0, 0x1F559, 0, 0x1F55A, 0, 0x1F55B, 0, 0x1F55C, 0, 0x1F55D, 0, 0x1F55E, 0,
	0x1F55F, 0, 0x1F560, 0, 0x1F561, 0, 0x1F562, 0, 0x1F563, 0, 0x1F564, 0, 0x1F565, 0, 0x1F566, 0,
	0x1F567, 0
};

static unsigned long DiverseEmoji[] = {
	0x1F476, 0, 0x1F466, 0,	0x1F467, 0, 0x1F468, 0, 0x1F469, 0, 0x1F470, 0,	0x1F471, 0, 0x1F472, 0, 0x1F473, 0,
	0x1F474, 0, 0x1F475, 0, 0x1F46E, 0, 0x1F477, 0, 0x1F478, 0, 0x1F482, 0,	0x1F47C, 0, 0x1F385, 0,	0x1F647, 0,
	0x1F481, 0, 0x1F645, 0, 0x1F646, 0, 0x1F64B, 0, 0x1F64E, 0, 0x1F64D, 0, 0x1F486, 0, 0x1F487, 0,	0x1F64C, 0,
	0x1F44F, 0, 0x1F442, 0, 0x1F443, 0, 0x1F485, 0, 0x1F44B, 0, 0x1F44D, 0, 0x1F44E, 0, 0x261D, 0,	0x1F446, 0,
	0x1F447, 0, 0x1F448, 0,	0x1F449, 0, 0x1F44C, 0, 0x270C, 0, 0x1F44A, 0, 0x270A, 0, 0x270B, 0, 0x1F4AA, 0,
	0x1F450, 0, 0x1F64F, 0,	0x1F596, 0,
	0x1F3C3, 0, 0x1F6B6, 0, 0x1F483, 0, 0x1F6A3, 0, 0x1F3CA, 0, 0x1F3C4, 0, 0x1F6C0, 0, 0x1F6B4, 0, 0x1F6B5, 0,
	0x1FC37, 0
};

#define DIVERSE_COUNT 55

static unichar DiverseEmoji2[DIVERSE_COUNT] = {
	0xDC42, 0xDC43, 0xDC46, 0xDC47, 0xDC48, 0xDC49, 0xDC4A, 0xDC4B, 0xDC4C, 0xDC4D, 0xDC4E, 0xDC4F, 0xDC50, 0xDC66, 0xDC67, 0xDC68,
	0xDC69,	0xDC6E, 0xDC70,	0xDC71, 0xDC72, 0xDC73, 0xDC74, 0xDC75, 0xDC76, 0xDC77, 0xDC78, 0xDC7C, 0xDC81, 0xDC82, 0xDC83, 0xDC85,
	0xDC86,	0xDC87, 0xDCAA, 0xDE45,	0xDE46, 0xDE47, 0xDE4B, 0xDE4C, 0xDE4D, 0xDE4E, 0xDE4F, 0xDEA3, 0xDEB4, 0xDEB5, 0xDEB6, 0xDEC0,
	0xDF85,	0xDFC2, 0xDFC3,	0xDFC4, 0xDFC7, 0xDFCA, 0xDD96
};

#define CATEGORIES_COUNT 9
