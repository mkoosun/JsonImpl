# JsonImpl
Convenient and Simple Data Modeling Framework for JSON - Very useful for network protocol，and support inheritance, nesting.

## Installation

> copy `NSObject+JsonImpl.h` and `NSObject+JsonImpl.m` to your projext.

or 

> 
JsonImpl is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JsonImpl"
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Convert json to model

```
@interface Human : NSObject
@property (nonatomic, assign) NSInteger age;
@end

...

NSDictionary *dict = @{@"age":@30};
Human *man = [Human new];
[man parse:dict];

NSString *jsonStr = @"{\n  \"age\" : 30\n}";
Man *man2 = [Man new];
[man2 parse: jsonStr];

```

### Convert model to json

```
Human *man = [Human new];
NSString *str = [man toJsonString];
NSDictionary *dict = [man toJsonDictionary];

```
### Inheritance

```
@interface Man : Human
@property (nonatomic, strong) NSString *job;
@end

```

### Property nesting

```
@interface Man : Human
@property (nonatomic, strong) Human* wife;
@end
```

### Array nesting
```
@interface Man : Human
@property (nonatomic, strong) NSArray* childrens;
@end

@implementation Man

+ (void)initialize
{
    if (self == [Man class]) {
        [self setArrayProperty:@"childrens" withClass:@"Human"];
    }
}
```

### Ignore property

1. if property name is end of '_ignore', the property will be ignored

2. if you `setIgnoreProperty ` in `initialize`, the property will be ignored

3. if the property contain `<Ignore>`, also will be ignored

```
@interface Man : Human
@property (nonatomic, strong) NSString<Ignore>* stringProperty;
@property (nonatomic, strong) NSString* stringProperty_ignore;
@property (nonatomic, assign) NSInteger intProperty;
@end

@implementation Man

+ (void)initialize
{
    if (self == [Man class]) {
        [self setIgnoreProperty:@"intProperty"];
    }
}
```

@end




## Author

wanglin.sun, mkoosun@gmail.com

## License

JsonImpl is available under the MIT license. See the LICENSE file for more info.
