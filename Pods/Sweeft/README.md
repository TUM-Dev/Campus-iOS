<div style="text-align:center;"><img src="https://raw.githubusercontent.com/mathiasquintero/Sweeft/master/logo.png" height=250></div>


# Sweeft
Swift but a bit Sweeter - More Syntactic Sugar for Swift

This is a collection of extensions and operators that make swift a bit sweeter. I have added these from multiple projects where I've been using these.

*Note:* These operators are supposed to help me in the way I write Swift. Which is a functional style.
So most of these regard possible problems and annoyances with functional programming in Swift.



**Please:** Contribute to make Swift a bit cooler looking... Post your ideas in the issues as enhancements

## Installing Sweeft

<div><img src="http://i.giphy.com/3knKct3fGqxhK.gif" height=250></div>

Sweeft is available both as a Pod in Cocoapods and as a Dependency in the Swift Package Manager. So you can choose how you include Sweeft into your project.

### Cocoapods

Add 'Sweeft' to your Podfile:

```ruby
pod 'Sweeft'
```

### Swift Package Manager

Add 'Sweeft' to your Package.swift:

```Swift
import PackageDescription

let package = Package(
    // ... your project details
    dependencies: [
        // As a required dependency
        .Package(url: "ssh://git@github.com/mathiasquintero/Sweeft.git", majorVersion: 0)
    ]
)
```

## Why use Sweeft?

<div><img src="http://i.giphy.com/l4JyX3V0yydvPHNBe.gif" height=200></div>

I know what you're wondering. Why the hell do I need this? 
Well. Sweeft allows you to make your code so much shorter.

For instance: let's say you have an array with some integers and some nil values.

```Swift
let array: [Int?]? = [1, 2, 3, nil, 5, nil]
```

And now you want to store all of the even numbers in a single array. Easy right:

```Swift
var even = [Int]()
if let array = array {
    for i in array {
        if let i = i, i % 2 == 0 {
            even.append(i)
        }
    }
}
```

Seems a bit too much.
Now those who know swift a bit better will tell me to write something more along the lines of:

```Swift
let even = (array ?? [])
            .flatMap { $0 }
            .filter { $0 & 1 == 0 }
```

But even that seems a bit too long. Here's that same code written using **Sweeft**:

```Swift
let even = !array |> { $0 & 1 == 0 }
```

Now to be clear, the last two solutions are following the same principles.

First we get rid of all the nil values from the array and cast it as a [Int] using the prefix '!'.
Then we just call filter. But since our fingers are too lazy we spelled it '|>' ;)

<div><img src="http://i.giphy.com/1VrOcCmld1a92.gif" height=150></div>

### Still not convinced?

Ok. Another example:

Say you're really curious and want to know all the numbers from 0 to 1000 that are both palindromes and primes. Exciting! I know.

Well easy:

```Swift
let palindromePrimes = (0...1000) |> { $0.isPalindrome } |> { $0.isPrime }
```

First we filter out the non-palindromes.
And then we filter out the non-primes.

### Wow! You're a hard sell.

<div><img src="http://i.giphy.com/Fjr6v88OPk7U4.gif" height=250></div>

Ok. If you still are not sure if you should use Sweeft, see this example.

Say you're looping over an array:

```Swift
for item in array {
    // Do Stuff
}
```

And all of the sudden you notice that you're going to need the index of the item as well.
So now you have to use a range:

```Swift
for index in 0..<array.count {
    let item = array[index]
    // Do Stuff
}
```

But you still haven't accounted for the fact that this will crash if the array is empty:
So you need:

```Swift
if !array.isEmpty {
    for index in 0..<array.count {
        let item = array[index]
        // Do Stuff
    }
}
```

Ok... That's too much work for a loop. Instead you could just use '.withIndex' property of the array.

```Swift
for (item, index) in array.withIndex {
    // Do Stuff
}
```

Which I know ```array.enumerated()``` already does. But ```array.withIndex``` just sounds so much clearer. ;)

Or even better. With the built in for-each operator:

```Swift
array => { item, index in
    // Do Stuff
}
```

I think we can all agree that's much cleaner looking.

## Usage

### Operators

#### (|) Pipe

Will pipe the left value to the function to the right. Just like in Bash:

```Swift
value | function
```

is the same as:

```Swift
function(value)
```

#### (|) Safely Get Value

If you want to access any value from an Array or a Dictionary:

```Swift
let first = array | 0
let second = array | 1
```

Any it will return nil if there is nothing in that index. So it won't crash ;)

You can also use negative numbers to go the other way around:

```Swift
let last = array | -1
let secondToLast = array | -2
```

Awesome, right?

#### (=>) Map with

This will call map with the function to the right:

```Swift
array => function
```

is the same as:

```Swift
array.map(function)
```

#### (=>) For each

If the closure returns void instead of a value, it will run it as a loop and not map:

```Swift
array => { item in
    // Do Stuff
}
```

#### (==>) FlatMap with

The same as above but with flatMap.

#### (==>) Simple Reduce with

If you're doing reduce to the same type as your array has. You can reduce without specifying an initial result. Instead it will take the first item as an initial result:

So if you want to sum all the items in an Array:

```Swift
let sum = array ==> (+)
let mult = array ==> (*)
```

Or you could just use the standard:

```Swift
let sum = array.sum { $0 }
let mult = array.multiply { $0 }
```

#### (==>) Reduce with

You could also use the standard reduce by specifying the initial result

```Swift
let joined = myStrings ==> "" ** { "\($0), \($1)" }
```

or if you feel like it, you can also flip the opperands:

```Swift
let joined = myStrings ==> { "\($0), \($1)" } ** ""
```

or since String conforms to 'Defaultable' and we know the default string is "", we can use the '>' operator to tell reduce to use the default:

```Swift
let joined = myStrings ==> >{ "\($0), \($1)" }
```

#### (|>) Filter with

The same as above but with filter

#### (>>=) Turn into Dictionary

Will turn any Collection into a dictionary by dividing each element into a key and a value:

```Swift
array >>= { item in
    // generate key and value from item

    return (key, item)
}
```

##### With indexes:

When handling an array you can call the above functions with a closure that also accepts the index of the item:

For example:

```Swift
array => { item, index in
    // Map
    return ...
}

array ==> initial ** { result, item, index in
    // Reduce
    return ...
}

array >>= { item, index in
    // Turn into dictionary
    return (..., ...)
}
```

#### ( ** ) Bind with input

If you want some of functions inputs to be already filled you can use \** to bind them to the function.

```Swift
let inc = (+) ** 1

inc(3) // 4
inc(4) // 5
```

You can also go from right to left with <\**

#### (<+>) or (<*>) Parallelize closures.

Say you want to combine to closures into one, that takes both inputs and delivers both outputs.
For example you have a dictionary dict [Int: Int] and you want to increase every key by one and get the square of every value.

Simple:

```Swift
let dict = [ 2 : 4, 3 : 5]
let newDict = dict >>= inc <*> { $0 ** 2 } // [3 : 16, 4 : 25]
```

Or if you want to use binding:

```Swift
let newDict = dict >>= inc <*> ((**) <** 2)  // Now no one can read. Perfect!
```

But what if both functions should take the same input? Then use <+> and both closures will be fed the same input:

```Swift
let dict = [1, 2, 3, 4]
let newDict = dict >>= inc <+> { $0 ** 2 } // [2 : 1, 3 : 4, 4 : 9, 5 : 16] 
```

And now your code will look so awesome:

<div><img src="http://i.giphy.com/uWv3uPfWOz088.gif" height=250></div>

#### ( ** ) Drop input/output from function

Will cast a function to allow any input and drop it.

```Swift
**{
    // Do stuff
}
```

is the same as:

```Swift
{ _,_ in
    // Do stuff
}
```

or as a postfix it will drop the output

```Swift
{
    return something
}**
```

is equivalent to:

```Swift
{
    _ = something
}
```

#### (<-) Assignment of non-nil

Will assign b to a if b is not nil

```Swift
a <- b
```

is equivalent to:

```Swift
a = b ?? a
```

#### (<-) Assign result of map

Will assign the result of a map to an array.

```Swift
array <- handler
```

is equivalent to:

```Swift
array = array.map(handler)
```

If the handler returns an optional, but the array can't handle optionals then it will drop all of the optionals.

#### (<|) Assign result of filter

Will assign the result of a filter to the array

```Swift
array <| handler
```

is the same as:

```Swift
array = array.filter(handler)
```

#### (+) Concatenate Arrays

This way you can concatenate arrays quickly:

```Swift
let concat = firstArray + secondArray
```

Or even do:

```Swift
firstArray += secondArray
```

#### (!) Will remove all the optional values from an array

```Swift
let array = [1, nil, 3]
!array // [1, 3]
```

#### (<=>) Will swap the values of two variables

```Swift
// a = 1 and b = 2
a <=> b // a = 2 and b = 1
```

#### (.?) Will unwrap an optional. Is not it will give the types default value

*Note:* the type has to conform to the *Defaultable* protocol.

```Swift
let i: Int? = nil
let j: Int? = 2

i.? // 0
j.? // 2
```

It even works inside a Collection:

```Swift
let array = [1, 2, nil, 4]
array.? // [1, 2, 0, 4]
```

Not to be confused with the default value of an array:

```Swift
let a: [Int?]? = nil
let b: [Int?]? = [1, 2, nil, 4]

a.? // []
b.? // [1, 2, nil, 4]
(b.?).? // [1, 2, 0, 4]
```

#### (??) Check for nil

Will check if a value is not nil


```Swift
??myVariable
```

is equivalent to:


```Swift
myVariable != nil
```

It can even be given to closures.

This means:

```Swift
??{ (item: String) in
    return item.date("HH:mm, dd:MM:yyyy")
}
```

Is a closure of type ```(String) -> (Bool)``` Meaning if the date in the string is nil or not.

#### (>>>) Run in Queue

You you want to run a closure in a specific queue:

```Swift
queue >>> {
    // Do Stuff.
}
```

Or if you want to run it after a certain time interval in seconds. For example the following will run the closure after 5 seconds:

```Swift
5.0 >>> {
    // Do Stuff
}
```

And of course you can combine them:

```Swift
(queue, 5.0) >>> {
    // Do Stuff
}

// Or

(5.0, queue) >>> {
    // Do Stuff
}
```

#### (>>>) Chain Closures

If you want to be more modular with your closures you can always chain them toghether and turn them into a bigger closure.

For example: Let's say you have an array of dates. And you want an array of the hours of each.

```Swift
let hours = dates => { $0.string("hh") } >>> Int.init
```

Which is equivalent to saying:

```Swift
let hours = dates.map { date in
    let string = date.string("hh")
    return Int(string)
}
```

The precedence works as follows:

Chaining before mapping. So >>> will be evaluated before =>.

Of course you don't need chaining in the previous example. You could use the pipe and will be even shorter:

```Swift
let hours = dates => { $0.string("hh") | Int.init }
```

But that's the cool thing about Sweeft. It gives you options ;)

### User Defaults

Storing data to UserDefaults can be lead to issues. Mainly because of the fact that UserDefaults uses strings as keys, which make it easy to make mistakes. Furthermore the code to read something from user defaults requires you to cast the value to the type that you want. Which is unnecesarily complicated.

Which is why Sweeft has a Status API. Meaning that anything that has to be stored into UserDefaults has to be it's own Status Struct.

#### Status

For example if you want to store the amount of times in which your app was opened:

We start by creating the keys for your app.

Simply create an enum for them that inherits from StatusKey:

```Swift
enum AppDefaults: String, StatusKey {
    case timesOpened
    /// More Cases here...
}
```

And now we create the Status:

```Swift
struct TimesOpened: Status {
    static let key: AppDefaults = .timesOpened
    static let defaultValue: Int = 0
}
```

To access it you can simply call it from your code:

```Swift
let times = TimesOpened.value
// Do Something with it...
TimesOpened.value = times + 1
```

#### ObjectStatus

Sometimes you may want to store more complex information than just stock types that are usually supported in user defaults.

For that there's the ObjectStatus. First off, your Data has to conform to the protocol 'StatusSerializable'. Meaning it can be serialized and deserialized into a ```[String:Any]```.

For example:

```Swift
extension MyData: StatusSerializable {

    var serialized: [String:Any] {
        return [
            // Store your data
        ]
    }

    init?(from status: [String:Any]) {
        // Read data from the dictionary and set everything up
        // This init is allowed to fail ;)
    }

}
```

And then create your ObjectStatus:

```Swift
struct MyDataStatus: ObjectStatus {
    static let key: AppDefaults = .myDataKey // Create a Key for this too
    static let defaultValue: MyData = MyData() // Hand some default value here
}
```

### REST and HTTP

Sweeft also abstracts away a lot of repetetive work on sending requests to your REST API.

#### API and Endpoints

To access an API you simply have to describe the API by creating a list of endpoints you can access.

```Swift
enum MyEndpoint: String, APIEndpoint {
    case login = "login"
    case user = "user/{id}"
}
```

Then you can create your own API Object:

```Swift
struct MyAPI: API {
    typealias Endpoint = MyEndpoint
    let baseURL = "https://..."
}
```

And do any requests from it, be it Data, JSON or anything that conforms to our DataRepresentable Protocol. Like so:

```Swift
let api = MyAPI()
api.doJSONRequest(with: .get, to: .user, arguments: ["id": 1234])
    .onSuccess { json in
        let name = json["name"].string ?? "No name for the user is available"
        print(name)
    }
    .onError { error in
        print("Some Error Happened :(")
        print(error)
    }

```

The code above does a GET Request to /user/1234 and if the request is successful it will read the name attribute of the JSON Object and print it out.

#### Deserializable Objects

A deserializable object is any object that conforms to the protocol Deserializable and can therefore be instantiated from JSON.
For instance let's say that we get an object representing a user from our API.

```Swift
struct User {
    let name: String
}

extension User: Deserializable {
    
    init?(from: JSON) {
        guard let name = json["name"].string else {
            return nil
        }
        self.init(name: name)
    }
    
}
```

Having done this you can automatically get User's from your api by calling get(:) or getAll(:) respectively.

For example you can now call:

```Swift
let api = MyAPI()
User.get(using: api, at: .user, arguments: ["id": 1234])
    .onSuccess { user in
        print(user.name)
    }
    .onError { error in
        print(error)
    }
```

## Contributing

Please contribute and help me make swift even better with more cool ways to simplify the swift syntax.
Fork and star this repo and #MakeSwiftGreatAgain
