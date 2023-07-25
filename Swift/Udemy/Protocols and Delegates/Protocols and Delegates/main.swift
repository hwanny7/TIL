

protocol AdvancedLifeSupport {
    func performCPR()
}

class EmergencyCallHandler {
    var delegate: AdvancedLifeSupport?
    
    func medicalEmergency() {
        delegate?.performCPR()
    }
    
}

struct Paramedic: AdvancedLifeSupport {
    
    init(handler: EmergencyCallHandler) {
        handler.delegate = self
    }
    
    func performCPR(){
        print("chest compressions")
    }
}

class Doctor: AdvancedLifeSupport {
    init(handler: EmergencyCallHandler) {
        handler.delegate = self
    }
    
    func performCPR() {
        print("chest compressions")
    }
}

class Surgeon: Doctor {
    override func performCPR() {
        super.performCPR()
        print("are you Okay?")
    }
}



let tom = EmergencyCallHandler()
let alice = Paramedic(handler: tom)

tom.medicalEmergency()
