protocol CanFly {
    func fly()
}

extension CanFly {
    func fly() {
        print("I am Flying!")
    }
}

class Bird: CanFly {
    
}

let bird = Bird()
bird.fly()

