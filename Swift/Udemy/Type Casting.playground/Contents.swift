import Foundation

class Animal {
    var name: String
    
    init(n: String){
        name = n
    }
}

class Human: Animal {
    func code() {
        print("Typing away...")
    }
}

class Fish: Animal {
    func breatheUnderWater() {
        print("Breathing under water")
    }
}

let angela = Human(n: "Angela Yu")
let jack = Human(n: "Jack Bauer")
let nemo = Fish(n: "Nemo")


let num: NSNumber = 12
let word: NSString = "abc"

let neighbours: [NSObject] = [num, word]

let neighbour1 = neighbours[0]

if neighbour1 is Human {
    print("Human!")
}

for animal in neighbours {
    if animal is Fish {
        let fish = animal as! Fish
        fish.breatheUnderWater()
        let animalFish = fish as Animal
    }
}

if let fish = jack as? Fish {
    fish.breatheUnderWater()
}
