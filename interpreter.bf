->->      ~~~ PROGRAM MEMORY BEGIN ~~~
+>        memory pointer

// Read the input until end char "*" or null char "\000" is found
// Each one of the 8 chars that have effects in the code is encoded into a number from 1 to 8
,[
  >++++++[-<------->] +<      char == 42  (end)
  [
    -                           char == 43  (increment)
    [
      -                           char == 44  (read/input)
      [
        -                           char == 45  (decrement)
        [
          -                           char == 46  (print/output)
          [
            --------------              char == 60  (left)
            [
              --                          char == 62  (right)
              [
                >+++[-<------->] +<-        char == 91  (left bracket)
                [
                  --                          char == 93  (right bracket)
                  [
                    [,>-]                       char has no effect
                  ]
                  > [<++++++>->,>>] <         case 93: 6
                ]
                > [<+++++>->,>>] <          case 91: 5
              ]
              > [<++++>->,>>] <           case 62: 4
            ]
            > [<+++>->,>>] <            case 60: 3
          ]
          > [<+++++++>->,>>] <        case 46: 7
        ]
        > [<++>->,>>] <             case 45: 2
      ]
      > [<++++++++>->,>>] <       case 44: 8
    ]
    > [<+>->,>>] <              case 43: 1
  ]
  > [<[-]>->] <<              case 42: end
]
>->->     ~~~ PROGRAM MEMORY END ~~~

          ~~~ PROGRAM EXECUTION BEGIN ~~~
+                     set memory pointer (at position 0)
<<<< +[-<<+]- >>      go to beginning of program

// Read the program until end value (0) is reached
>     read the operation's value
[
  <->->+<       remove pointer; sub 1 from op's value; add else flag
  [-[-[-[-[-[-[
                >>> -[+>>-]+ >,<<< -[+<<-]+ <<                print/output
              ]
              > [ >> -[+>>-]+ >.<<< -[+<<-]+ < ] >+<<       read/input
            ]
            > [
              <         !! Need to implement bracket logic !!
            ] >+<<
          ]
          > [
            <        !! Need to implement bracket logic !!
          ] >+<<
        ]
        > [ >> -[+>>-]+ ->>+<< -[+<<-]+ < ] >+<<      right
      ]
      > [ >> -[+>>-]+ -<<+<< -[+<<-]+ < ] >+<<      left
    ]
    > [ >> -[+>>-]+ >-<<< -[+<<-]+ < ] >+<<       decrement
  ]
  > [ >> -[+>>-]+ >+<<< -[+<<-]+ < ]            increment
  >[-<+>] +>      go to the next instruction
]


+[-<<+]- <<<  crash
