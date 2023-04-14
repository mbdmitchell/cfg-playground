(module 
    (import "env" "log" (func $log (param i32))) 
    (memory $memory 1)
    (export "memory" (memory $memory))

    (func (export "View")
        
        (local $i i32)
        (local.set $i (i32.const 0))
        
        ;; `VIEW MEMORY`: take a peek at the memory contents
        
        (loop $loopy_doop                                                               
            (if (i32.lt_u (local.get $i)(i32.const 32)) ;; 0 is starting mem address
                (then
                    (call $log (i32.load (local.get $i)))         
                    (local.set $i (i32.add (local.get $i)(i32.const 1)))                    
                    (br $loopy_doop)
                )                            
            ) 
        )
    )
)
   
