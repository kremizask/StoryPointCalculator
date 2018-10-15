# StoryPointCalculator

Demo app created for the needs of the ['Testing the waters of iOS' presentation](https://www.slideshare.net/kremizask/testing-the-waters-of-ios)

StoryPointCalculator uses a fresh, novel and utterly silly way to solve the impossibly hard problem of engineering estimations. 
1. It makes a call to the [random.org API](https://api.random.org/json-rpc/1/) and fetches a truly random number between 0 and 8.
2. It finds the corresponding [Fibonacci](https://en.wikipedia.org/wiki/Fibonacci_number) number.
3. Voila! That's the estimation! Depending on the size of the number it displays a fitting phrase to recite before the product owner.

## Points of interest
1. Project structure: Placing test code next to it's corresponding production file. More about the reasoning [here](https://qualitycoding.org/rearrange-project-test-code/)
2. [Mocking HTTP calls](story_point_calc/RandomNumberFetcher/RandomNumberFetcherTests.swift)
3. [Performance tests](https://github.com/kremizask/StoryPointCalculator/blob/master/story_point_calc/MathCalculator/MathCalculatorTests.swift#L66-L70)
4. Testing asynchronous code 
    - [with expectations](https://github.com/kremizask/StoryPointCalculator/blob/master/story_point_calc/ViewModel/ViewModelTests.swift#L26-L42)
    - [with dispatch queues](https://github.com/kremizask/StoryPointCalculator/blob/master/story_point_calc/ViewModel/ViewModelTests.swift#L179-L215)
    - [by making it synchronous](story_point_calc/RandomNumberFetcher/RandomNumberFetcherTests.swift)
6. Switching your AppDelegate for testing: [here](https://github.com/kremizask/StoryPointCalculator/commit/87b9d65228189c641ffd2a03d78bbcda5bb26467) and [here](https://github.com/kremizask/StoryPointCalculator/commit/e07ac8d6e24223ad69b4e3d3f16b6e6422910bf3). More about the reasoning [here](https://qualitycoding.org/ios-app-delegate-testing/)
7. [Testing @IBOutlets / @IBActions](https://github.com/kremizask/StoryPointCalculator/blob/master/story_point_calc/ViewController/ViewControllerTests.swift#L56)
8. [Extracting custom assertions](https://github.com/kremizask/StoryPointCalculator/blob/master/story_point_calc/ViewModel/ViewModelTests.swift#L130-L153)
