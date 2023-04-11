const fs = require('fs');

const node_1_direction = parseInt (process.argv[2]); // will replace with direction filename

// Load the module from a binary file
const buffer = fs.readFileSync('ifelsev2.wasm');


(async () => {
    const obj = new WebAssembly.Module(buffer); 

    // Create an environment object
    const env = {
      log: (i) => console.log(i),
    };

    // Create a memory object with an initial size of 1 page
    const memory = new WebAssembly.Memory({ initial: 1 });

    // Create an instance of the module with the environment and memory objects
    const instance = new WebAssembly.Instance(obj, { env, js: { mem: memory } });

    instance.exports.OutputPath(node_1_direction); // result = mem add 0 content??

    // Get a reference to the memory buffer
    const memoryBuffer = instance.exports.memory.buffer;

    // Create a DataView object to read from the memory buffer
    const dataView = new DataView(memoryBuffer);

    // Read a 32-bit integer from the memory buffer at offset 0
    const value = dataView.getInt32(0, true);

    console.log(`The value in memory is ${value}`);
    
})();

