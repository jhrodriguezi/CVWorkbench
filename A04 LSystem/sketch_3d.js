class BaseLSystem {
    constructor(axiom, rules) {
        this.axiom = axiom;
        this.rules = rules;
    }

    generate(iterations) {
        let result = this.axiom;
        for (let i = 0; i < iterations; i++) {
            result = this.iterate(result);
            console.log(result)
        }
        this.axiom = result;
        return result;
    }

    iterate(result) {
        var newResult = "";
        for (let i = 0; i < result.length; i++) {
            let char = result[i];
            if (this.rules[char] !== undefined) {
                newResult += this.rules[char];
            } else {
                newResult += char;
            }
        }
        return newResult
    }
}

class Turtle {
    constructor(len, angle) {
        this.len = len;
        this.angle = angle;
        this.stateStack = [];
    }

    moveForward() {
        push();
        line(0, 0, this.len, 0);
        pop();
        translate(this.len, 0)
    }

    moveForwardNoDraw() {
        translate(this.len, 0, 0);
    }

    turnLeft() {
        rotateZ(-this.angle);
    }

    turnRight() {
        rotateZ(this.angle);
    }

    pitchUp() {
        rotateY(-this.angle);
    }

    pitchDown() {
        rotateY(this.angle);
    }

    rollLeft() {

        rotateX(-this.angle);
    }

    rollRight() {

        rotateX(this.angle);
    }

    turnAround() {
        rotateZ(PI);
    }

    pushState() {
        push();
    }

    popState() {
        pop();
    }

    drawLeaf() {
        push();
        translate(0, -this.len / 2, 0);
        box(10, this.len, 10);
        translate(0, -this.len / 2, 0);
        pop();
        translate(0, -this.len, 0);
    }

    drawPetal() {
        push();
        translate(0, -this.len / 2, 0);
        box(10, this.len, 10);
        translate(0, -this.len / 2, 0);
        pop();
        translate(0, -this.len, 0);
    }
}


class HilbertCurve extends BaseLSystem {
    constructor() {
        super(
            'A',
            {
                'A': 'B-F+CFC+F-D&F^D-F+&&CFC+F+B//',
                'B': 'A&F^CFB^F^D^^-F-D^|F^B|FC^F^A//',
                'C': '|D^|F^B-F+C^F^A&&FA&F^C+F+B^F^D//',
                'D': '|CFB-F+B|FA&F^A&&FB-F+B|FC//',
            }
        )
    }

    render() {
        // Set the initial length and angle
        let len = 50;
        let angle = radians(90);
        const turtle = new Turtle(len, angle);
        // Loop through the symbols in the axiom
        for (let i = 0; i < this.axiom.length; i++) {
            let char = this.axiom[i];
            // Apply the drawing rules
            switch (char) {
                case "F":
                case "G":
                    turtle.moveForward();
                    break;
                case "f":
                    turtle.moveForwardNoDraw();
                    break;
                case "+":
                    turtle.turnLeft();
                    break;
                case "-":
                    turtle.turnRight();
                    break;
                case "&":
                    turtle.pitchDown();
                    break;
                case "^":
                    turtle.pitchUp();
                    break;
                case "\\":
                    turtle.rollLeft();
                    break;
                case "/":
                    turtle.rollRight();
                    break;
                case "|":
                    turtle.turnAround();
                    break;
                case "[":
                    turtle.pushState();
                    break;
                case "]":
                    turtle.popState();
                    break;
                case "L":
                    turtle.drawLeaf();
                    break;
                case "P":
                    turtle.drawPetal();
                    break;
            }
        }
    }
}

class WovenSphere extends BaseLSystem {
    constructor() {
        super(
            'F',
            {
                'F': 'F+F&F',
            }
        )
    }

    render() {
        // Set the initial length and angle
        let len = 50;
        let angle = radians(40);
        const turtle = new Turtle(len, angle);
        // Loop through the symbols in the axiom
        for (let i = 0; i < this.axiom.length; i++) {
            let char = this.axiom[i];
            // Apply the drawing rules
            switch (char) {
                case "F":
                case "G":
                    turtle.moveForward();
                    break;
                case "f":
                    turtle.moveForwardNoDraw();
                    break;
                case "+":
                    turtle.turnLeft();
                    break;
                case "-":
                    turtle.turnRight();
                    break;
                case "&":
                    turtle.pitchDown();
                    break;
                case "^":
                    turtle.pitchUp();
                    break;
                case "\\":
                    turtle.rollLeft();
                    break;
                case "/":
                    turtle.rollRight();
                    break;
                case "|":
                    turtle.turnAround();
                    break;
                case "[":
                    turtle.pushState();
                    break;
                case "]":
                    turtle.popState();
                    break;
                case "L":
                    turtle.drawLeaf();
                    break;
                case "P":
                    turtle.drawPetal();
                    break;
            }
        }
    }
}

class Fern extends BaseLSystem {
    constructor() {
        super(
            'CCCF',
            {
                "F": "[++++++++++++++CA]C^+C[--------------CB]C+CF",
                "A": "[---------CC][+++++++++CC]C&&+A",
                "B": "[---------CC][+++++++++CC]C&&-B",
                "C": "G",
            }
        )
    }

    render() {
        // Set the initial length and angle
        let len = 50;
        let angle = radians(4);
        const turtle = new Turtle(len, angle);
        // Loop through the symbols in the axiom
        for (let i = 0; i < this.axiom.length; i++) {
            let char = this.axiom[i];
            // Apply the drawing rules
            switch (char) {
                case "F":
                case "G":
                    turtle.moveForward();
                    break;
                case "f":
                    turtle.moveForwardNoDraw();
                    break;
                case "+":
                    turtle.turnLeft();
                    break;
                case "-":
                    turtle.turnRight();
                    break;
                case "&":
                    turtle.pitchDown();
                    break;
                case "^":
                    turtle.pitchUp();
                    break;
                case "\\":
                    turtle.rollLeft();
                    break;
                case "/":
                    turtle.rollRight();
                    break;
                case "|":
                    turtle.turnAround();
                    break;
                case "[":
                    turtle.pushState();
                    break;
                case "]":
                    turtle.popState();
                    break;
                case "L":
                    turtle.drawLeaf();
                    break;
                case "P":
                    turtle.drawPetal();
                    break;
            }
        }
    }
}

const hilbertCurve = new HilbertCurve();
const wovenSphere = new WovenSphere();
const fern = new Fern();
var radio;

function setup() {
    createCanvas(800, 520, WEBGL);
    hilbertCurve.generate(3);
    wovenSphere.generate(6);
    fern.generate(12);
    radio = createRadio();
    radio.option('0', ' Hilbert curve   ');
    radio.option('1', ' Woven Sphere   ');
    radio.option('2', ' Fern   ');
    radio.position(40, height + 230);
}

function draw() {
    background(0);
    stroke(255)
    rotateY(frameCount * 0.01);
    drawBasicLSystem()
    orbitControl();
}

function drawBasicLSystem() {
    let val = radio.value();
    switch (val) {
        case '0':
            hilbertCurve.render();
            break;
        case '1':
            wovenSphere.render()
            break;
        case '2':
            fern.render()
            break;
    }
}