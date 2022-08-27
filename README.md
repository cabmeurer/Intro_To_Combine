# Intro_To_Combine
Tutorial to introduce the basics of Combine by refactoring completion handlers/call backs. 

## Introduction

We will be refactoring a very simple app that uses completion handlers to handle asynchronous processes to use Combine instead.
Our goal is to use the Combine framework, to handle the flow of data/processes throughout the application.
Start by cloning the starter project. 


## What is Combine?

Combine is a framework introduced by Apple in 2019 (iOS 13) as a reactive binding tool to create a publisher/subscriber model for handling asynchronous event processes through an application.
The idea of streaming data through events instead of callbacks has been around for a while using the Rx libraries. Combine has often been referred to as a native version of RxSwift.

## Pros and Cons

Pros: Syntactically simple, we will be able to refactor nested callbacks and completions leading to more readable, cleaner asynchronous processes that change on events.
Cons: Can be hard to debug, when you have many pieces of code subscribing/publishing data, it can be difficult to narrow down what the flow of the state machine actually is, and can lead to poor architecture if not implemented correctly.

## Overview of the Starter Project

Simple iOS application that displays a Table View, and presents a detail view when a cell is tapped.
We are using the Model-View-Controller architecture for simplicity
We are using completion handlers to handle asynchronous calls

The app uses the free Pokemon API [https://pokeapi.co] as our data source

We have four Models, the 
* Results which gives us our collection of Pokemon, 
* Pokemon, contains the name and URL for the PokemonDetails.
* PokemonDetails contains Name, ID, and Sprite.
* Sprite contains the URL for the image.
We have two Views, the 
* MainViewController, displaying a list of Pokemon.
* DetailViewController displaying an image, name and the ID. 
We have a Controller that is responsible for providing and controlling our model
* PokemonController manipulates our model to be used for our views, uses NetworkService as the networking layer to fetch our data for the models.

## Refactoring NetworkService

We are going to update our fetch method, to return us a Publisher (AnyPublisher), of the specific object we are wanting to use in our PokemonController.
First remove the completion argument from the method, and add a return of type AnyPublisher<T, NetworkingError>.
The AnyPublisher is a struct from Combine with two generics, associated with an Output, and a Failure. This AnyPublisher type will allow our PokemonController, to subscribe to changes directly and publish them upstream to additional subscribers, e.i our Views.
So when we call fetchData, we are returned an AnyPublisher<T, NetworkingError>, which we will then subscribe to, and publish upstream.
We need to update how we are creating our URLSession a bit, there are a few helpful methods designed to integrate with Combine nicely.
We need to create a new dataTask, specifically a dataTaskPublisher, this allows us to map the data and response from the GET request, already be wrapped in a Publisher
Next we can simply decode our Data, by calling .decode and passing the Type, and instance of the decoder we would like to use.
We can now remove the decode method completely, as we are decoding in our method here to an AnyPublisher

## Handling Custom Errors with AnyPublisher

There are few things to note with the changes we just made:
How we added support for the customer error type: NetworkingError
In the code here, we can see that we actually call .catch when we are decoding the data we get from the publisherData object. But notice we don’t use the error proved in the closure we just pass the description like before. We return Fail with our custom errorDecoding. 
This is because we would like to also return a Networking Error, if there is an invalid URL. If we were to try to use just an Error type, and NetworkingError we will get an error. Why? It is actually really simple, we need to return the same type, so the associated right hand generic for our AnyPublisher needs to having matching types.
What does .eraseToAnyPublisher mean?
This simply wraps the current publisher in a type eraser, so we can expose an instance of our AnyPublisher to the subscriber instead of the actual type.

## Refactoring PokemonController

Next we need to update our controller to subscribe and publish our model data so we can publish it to our views.
First we need to create the publishers that we want our views to subscribe to, create:
@Published var pokemon: [Pokemon] = []
@Published var pokemonDetails: PokemonDetails?
Notice the @Published property wrapper, this allows use to subscribe to changes whenever these are set. 
Next we add a property that will allow us to store and data that is passed upstream:
Private(set) var subscriptions = Set<AnyCancellable>
AnyCancellable is a very important part of the Combine subscription life cycle that allows us to call cancel on any of the subscriptions referenced. However, the most important part is when we set our objects to this, anytime the objects are deallocated, cancel is automatically called.
Next we need to call our networking methods and update our getPokemon() and getDetails() methods to up

## Updating our Views

Now the heavy lifting is done, we just need to update our methods in the views to subscribe for changes from the PokemonController.
For MainViewController, we need to add a cancellable property to retain our subscription, so add private var cancellable: AnyCancellable?, now we just need to update the loadData() method with:
self.cancellable = controller?.$pokemon.sink(receiveValue: { self.pokemon = $0 })
controller?.getPokemon()
Here we are subscribing to the pokemon publisher of the controller, so anytime there are changes to the object, we set the MainViewController’s pokemon Model, then of course reload the view.

## Conclusion

There we go, we have updated our application to use Combine to handle asynchronous logic, where we previously used completion handlers.
This just scratches the surface of what Combine is capable of doing, but was hopefully a nice introduction to the framework.
Just like RxSwift or async/await this is just another tool you can add to your arsenal so you can have more control over the flow of your application.

For more information checkout: Raywenderlich: Getting Started with Combine[https://www.raywenderlich.com/7864801-combine-getting-started]
