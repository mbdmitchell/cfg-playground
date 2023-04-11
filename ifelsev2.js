const fs = require('fs');

function readJsonArrayFromFile(filename) {
    const jsonString = fs.readFileSync(filename, 'utf-8');
    return JSON.parse(jsonString);
  }

const directionArray = readJsonArrayFromFile(process.argv[2]); // will replace with direction filename

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

    instance.exports.OutputPath(directionArray[0]); // result = mem add 0 content??

    // Get a reference to the memory buffer
    const memoryBuffer = instance.exports.memory.buffer;

    // Create a DataView object to read from the memory buffer
    const dataView = new DataView(memoryBuffer);

    // Read a 32-bit integer from the memory buffer at offset 4 (this contains the no. of elements in the array)
    const length = dataView.getInt32(4, true);

    // console.log(`The value in memory is ${value}`);
    const pathTaken = [];

    for (let i = 0; i < length; i++){
        pathTaken.push(dataView.getInt32(8 + 4*i, true)); // see appendix 
    }
    
    fs.writeFileSync('output.txt', JSON.stringify(pathTaken));
    console.log('Saved!');


})();

/*
APPENDIX 

Memory
-----------
20              
50331648
196608
768
3               <-- length
16777216
65536
256
1               <-- output_path[0]
50331648
196608
768
3               <-- output_path[1]
67108864
262144
1024
4               <-- output_path[2]
0
0
0
*/

