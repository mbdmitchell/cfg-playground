(;
---------------------------------
|      CFG       |     PATH     |
---------------------------------
        |               |
        |               |
        |               |
        %1             [1]
     if/  \else        / \
      /    \          /   \
    %2     %3      [1,2]  [1,3]
      \    /          \   /
       \  /            \ /
        %4          [1,2/3,4]
        |               |
        |               |

---------------------------------
|           EXAMPLE             |
---------------------------------
// $ node ifelsev2.js test/direction1.txt -> OUTPUT: file w/ [1,2,4]
// $ node ifelsev2.js test/direction0.txt -> OUTPUT: file w/ [1,3,4]

;)

(module 
    (import "env" "log" (func $log (param i32))) 
    (memory $memory 1)
    (export "memory" (memory $memory))

    ;; ------------------------------
    ;; ARRAY IMPLIMENTATION 
    ;; ------------------------------

    ;; create a array
    (func $arr (param $len i32) (result i32)
        (local $offset i32)                             ;; offset
        (local.set $offset (i32.load (i32.const 0)))    ;; load offset from the first i32

        (i32.store (local.get $offset)(local.get $len)) ;; load the length

        (i32.store                                      ;; store offset of available space    
            (i32.const 0)               
            (i32.add 
                (i32.add
                    (local.get $offset)
                    (i32.mul 
                        (local.get $len) 
                        (i32.const 4)
                    )
                )
                (i32.const 4)                            ;; the first i32 is the length
            )
        )
        (local.get $offset)                              ;; (return) the beginning offset of the array.
    )
    ;; return the array length
    (func $len (param $arr i32) (result i32)
        (i32.load (local.get $arr))
    )
    ;; convert an element index to the offset of memory
    (func $offset (param $arr i32) (param $i i32) (result i32)
        (i32.add
            (i32.add (local.get $arr) (i32.const 4))    ;; The first i32 is the array length 
            (i32.mul (i32.const 4) (local.get $i))      ;; one i32 is 4 bytes
        )
    )
    ;; set a value at the index 
    (func $set (param $arr i32) (param $i i32) (param $value i32)
        (i32.store 
            (call $offset (local.get $arr) (local.get $i)) 
            (local.get $value)
        ) 
    )
    ;; get a value at the index 
    (func $get (param $arr i32) (param $i i32) (result i32)
        (i32.load 
            (call $offset (local.get $arr) (local.get $i)) 
        )
    )

    ;; ------------------------------
    ;; CALCULATE OUTPUT PATH 
    ;; ------------------------------

    (func (export "OutputPath")
        (param $node_1_direction i32)
        
        ;; (local $i i32) ;; for `VIEW MEMORY` (cf. line 126)
        
        (local $output_path i32)
        (local $counter i32)

        ;; (local.set $i (i32.const 0)) ;; for `VIEW MEMORY` (cf. line 126)
        
        (local.set $counter (i32.const 0))

        ;; The first i32 records the beginning offset of available space
        ;; so the initial offset should be 4 (bytes)
        (i32.store (i32.const 0) (i32.const 4))     

        (local.set $output_path (call $arr (i32.const 3)))                              ;; create an array with length 3 and assign to $output_path

        ;; node %1 traversed
        (call $set (local.get $output_path) (local.get $counter) (i32.const 1))         ;; output_path[0] == 1
        (local.set $counter (i32.add (local.get $counter)(i32.const 1)))                ;; counter++                                             

        ;; if ($node_1_direction != 0)
        (if (local.get $node_1_direction)
            (then
                ;; node %2 traversed
                (call $set (local.get $output_path) (local.get $counter) (i32.const 2)) ;; output_path[1] == 2
            )
            (else
                ;; node %3 traversed
                (call $set (local.get $output_path) (local.get $counter) (i32.const 3)) ;; output_path[1] == 3
            )
        )
        (local.set $counter (i32.add (local.get $counter)(i32.const 1))) 

        ;; node %4 traversed
        (call $set (local.get $output_path) (local.get $counter) (i32.const 4))         ;; output_path[2] = 4
        

        (;
        ;; `VIEW MEMORY`: take a peek at the memory contents
        
        (loop $loopy_doop                                                               
            (if (i32.lt_u (local.get $i)(i32.const 128))
                (then
                    (call $log (i32.load (local.get $i)))         
                    (local.set $i (i32.add (local.get $i)(i32.const 1)))                    
                    (br $loopy_doop)
                )                            
            ) 
        )
        ;)

    )
)
        
