const fs = require('fs');

const node_1_direction = parseInt (process.argv[2]); // will replace with direction filename

// Load the module from a binary file
const buffer = fs.readFileSync('ifelsev2.wasm');


(async () => {
    const obj = new WebAssembly.Module(buffer); // WebAssembly.Module(fs.readFileSync('ifelsev2.wasm'));

    // Create an environment object
    const env = {
      log: (i) => console.log(i),
    };

    // Create a memory object with an initial size of 1 page
    const memory = new WebAssembly.Memory({ initial: 1 });

    // Create an instance of the module with the environment and memory objects
    const instance = new WebAssembly.Instance(obj, { env, js: { mem: memory } });
    
    instance.exports.OutputPath(node_1_direction);

    //const memoryView = new Uint8Array(memory.buffer, 0, memory.buffer.byteLength);
    
})();
