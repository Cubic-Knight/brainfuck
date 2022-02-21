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
  [-[-[-[-[-[-[-
                >>> -[+>>-]+ >,<<< -[+<<-]+ <<               print/output
              ]
              > [ >> -[+>>-]+ >.<<< -[+<<-]+ < ] >+<<       read/input
            ]
            > [                     right bracket
              >> -[+>>-]+        go to mem pointer
              >[                 if cell != 0
                <<< -[+<<-]+ <   go to prog pointer
                ++++++           put the right bracket back
                >[               while bracket_count != 0 (start at 1)
                  <<+<-----      go to prev char; set else flag; test for left bracket
                  [-[
                      [->+<]<    not a bracket: ignore char
                    ]
                    > [>>+<<<] >+<<     right bracket: inc count
                  ]
                  > [>>-<<<] >++++[-<+>]    left bracket: dec count
                  >>[-<<+>>]<<              move count
                ]
                <<->[-]>+       set left bracket flag; reset ghost char; set jump flag
                > [>>]          jump to prog end (0) so the next part does not fail
              ]<<< -[+<<-]+ <   go to prog pointer
            ] >+<<[+>>-<<]      resolve left bracket flag
          ]
          > [                     left bracket
            >> -[+>>-]+        go to mem pointer
            >>>[->+<]<+<       make some room for the future; set else flag
            [>-]               cell != 0: do nothing
            > [                if cell == 0
              <<<< -[+<<-]+    go to prog pointer
              -<+++++<+        remove pointer; put left bracket back; set count to 1
              [                while count != 0
                >>+>-----      go to next char; set else flag; test for left bracket
                [-[
                    [-<+>]>    not a bracket: ignore char
                  ]
                  < [<<->>>] <+>>     right bracket: dec count
                ]
                < [<<+>>>] <++++[->+<]    left bracket: inc count
                <<[->>+<<]>>              move count
              ]
              ->[-]>+          set right bracket flag; reset ghost char; set jump flag
              >> -[+>>-]+      go to mem pointer
              >>->             reset else flag
            ]
            >[-<+>]<<<         clean up space
            <<< -[+<<-]+ <     go to prog pointer
          ] >+<<[+>>+<<]       resolve right bracket flag
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
