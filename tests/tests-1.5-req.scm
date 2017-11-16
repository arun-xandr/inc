(add-tests-with-string-output "fx+"
  [(fx+ 1 2) => 3]
  [(fx+ 1 -2) => -1]
  [(fx+ -1 2) => 1]
  [(fx+ -1 -2) => -3]
  [(fx+ 536870911 -1) => 536870910]
  [(fx+ 536870910 1) => 536870911]
  [(fx+ -536870912 1) => -536870911]
  [(fx+ -536870911 -1) => -536870912]
  [(fx+ 536870911 -536870912) => -1]
  [(fx+ 1 (fx+ 2 3)) => 6]
  [(fx+ 1 (fx+ 2 -3)) => 0]
  [(fx+ 1 (fx+ -2 3)) => 2]
  [(fx+ 1 (fx+ -2 -3)) => -4]
  [(fx+ -1 (fx+ 2 3)) => 4]
  [(fx+ -1 (fx+ 2 -3)) => -2]
  [(fx+ -1 (fx+ -2 3)) => 0]
  [(fx+ -1 (fx+ -2 -3)) => -6]
  [(fx+ (fx+ 1 2) 3) => 6]
  [(fx+ (fx+ 1 2) -3) => 0]
  [(fx+ (fx+ 1 -2) 3) => 2]
  [(fx+ (fx+ 1 -2) -3) => -4]
  [(fx+ (fx+ -1 2) 3) => 4]
  [(fx+ (fx+ -1 2) -3) => -2]
  [(fx+ (fx+ -1 -2) 3) => 0]
  [(fx+ (fx+ -1 -2) -3) => -6]
  [(fx+ (fx+ (fx+ (fx+ (fx+ (fx+ (fx+ (fx+ 1 2) 3) 4) 5) 6) 7) 8) 9) => 45]
  [(fx+ 1 (fx+ 2 (fx+ 3 (fx+ 4 (fx+ 5 (fx+ 6 (fx+ 7 (fx+ 8 9)))))))) => 45]
)

(add-tests-with-string-output "fx-"
  [(fx- 1 2) => -1]
  [(fx- 1 -2) => 3]
  [(fx- -1 2) => -3]
  [(fx- -1 -2) => 1]
  [(fx- 536870910 -1) => 536870911]
  [(fx- 536870911 1) => 536870910]
  [(fx- -536870911 1) => -536870912]
  [(fx- -536870912 -1) => -536870911]
  [(fx- 1 536870911) => -536870910]
  [(fx- -1 536870911) => -536870912]
  [(fx- 1 -536870910) => 536870911]
  [(fx- -1 -536870912) => 536870911]
  [(fx- 536870911 536870911) => 0]
  ;[(fx- 536870911 -536870912) => -1]
  [(fx- -536870911 -536870912) => 1]
  [(fx- 1 (fx- 2 3)) => 2]
  [(fx- 1 (fx- 2 -3)) => -4]
  [(fx- 1 (fx- -2 3)) => 6]
  [(fx- 1 (fx- -2 -3)) => 0]
  [(fx- -1 (fx- 2 3)) => 0]
  [(fx- -1 (fx- 2 -3)) => -6]
  [(fx- -1 (fx- -2 3)) => 4]
  [(fx- -1 (fx- -2 -3)) => -2]
  [(fx- 0 (fx- -2 -3)) => -1]
  [(fx- (fx- 1 2) 3) => -4]
  [(fx- (fx- 1 2) -3) => 2]
  [(fx- (fx- 1 -2) 3) => 0]
  [(fx- (fx- 1 -2) -3) => 6]
  [(fx- (fx- -1 2) 3) => -6]
  [(fx- (fx- -1 2) -3) => 0]
  [(fx- (fx- -1 -2) 3) => -2]
  [(fx- (fx- -1 -2) -3) => 4]
  [(fx- (fx- (fx- (fx- (fx- (fx- (fx- (fx- 1 2) 3) 4) 5) 6) 7) 8) 9) => -43]
  [(fx- 1 (fx- 2 (fx- 3 (fx- 4 (fx- 5 (fx- 6 (fx- 7 (fx- 8 9)))))))) => 5]
)

(add-tests-with-string-output "fx*"
  [(fx* 2 3) => 6]
  [(fx* 2 -3) => -6]
  [(fx* -2 3) => -6]
  [(fx* -2 -3) => 6]
  [(fx* 536870911 1) => 536870911]
  [(fx* 536870911 -1) => -536870911]
  [(fx* -536870912 1) => -536870912]
  [(fx* -536870911 -1) => 536870911]
  [(fx* 2 (fx* 3 4)) => 24]
  [(fx* (fx* 2 3) 4) => 24]
  [(fx* (fx* (fx* (fx* (fx* 2 3) 4) 5) 6) 7) => 5040]
  [(fx* 2 (fx* 3 (fx* 4 (fx* 5 (fx* 6 7))))) => 5040]
)

(add-tests-with-string-output "fxlogand and fxlogor"
  [(fxlogor 3 16) => 19]
  [(fxlogor 3 5)  => 7]
  [(fxlogor 3 7)  => 7]
  [(fxlognot (fxlogor (fxlognot 7) 1)) => 6]
  [(fxlognot (fxlogor 1 (fxlognot 7))) => 6]
  [(fxlogand 3 7) => 3]
  [(fxlogand 3 5) => 1]
  [(fxlogand 2346 (fxlognot 2346)) => 0]
  [(fxlogand (fxlognot 2346) 2346) => 0]
  [(fxlogand 2376 2376) => 2376]
)

(add-tests-with-string-output "fx="
  [(fx= 12 13) => #f]
  [(fx= 12 12) => #t]
  [(fx= 16 (fx+ 13 3)) => #t]
  [(fx= 16 (fx+ 13 13)) => #f]
  [(fx= (fx+ 13 3) 16) => #t]
  [(fx= (fx+ 13 13) 16) => #f]
)

(add-tests-with-string-output "fx<"
  [(fx< 12 13) => #t]
  [(fx< 12 12) => #f]
  [(fx< 13 12) => #f]
  [(fx< 16 (fx+ 13 1)) => #f]
  [(fx< 16 (fx+ 13 3)) => #f]
  [(fx< 16 (fx+ 13 13)) => #t]
  [(fx< (fx+ 13 1) 16) => #t]
  [(fx< (fx+ 13 3) 16) => #f]
  [(fx< (fx+ 13 13) 16) => #f]
)

(add-tests-with-string-output "fx<="
  [(fx<= 12 13) => #t]
  [(fx<= 12 12) => #t]
  [(fx<= 13 12) => #f]
  [(fx<= 16 (fx+ 13 1)) => #f]
  [(fx<= 16 (fx+ 13 3)) => #t]
  [(fx<= 16 (fx+ 13 13)) => #t]
  [(fx<= (fx+ 13 1) 16) => #t]
  [(fx<= (fx+ 13 3) 16) => #t]
  [(fx<= (fx+ 13 13) 16) => #f]
)

(add-tests-with-string-output "fx>"
  [(fx> 12 13) => #f]
  [(fx> 12 12) => #f]
  [(fx> 13 12) => #t]
  [(fx> 16 (fx+ 13 1)) => #t]
  [(fx> 16 (fx+ 13 3)) => #f]
  [(fx> 16 (fx+ 13 13)) => #f]
  [(fx> (fx+ 13 1) 16) => #f]
  [(fx> (fx+ 13 3) 16) => #f]
  [(fx> (fx+ 13 13) 16) => #t]
)

(add-tests-with-string-output "fx>="
  [(fx>= 12 13) => #f]
  [(fx>= 12 12) => #t]
  [(fx>= 13 12) => #t]
  [(fx>= 16 (fx+ 13 1)) => #t]
  [(fx>= 16 (fx+ 13 3)) => #t]
  [(fx>= 16 (fx+ 13 13)) => #f]
  [(fx>= (fx+ 13 1) 16) => #f]
  [(fx>= (fx+ 13 3) 16) => #t]
  [(fx>= (fx+ 13 13) 16) => #t]
)


(add-tests-with-string-output "if"
  [(if (fx= 12 13) 12 13) => 13]
  [(if (fx= 12 12) 13 14) => 13]
  [(if (fx< 12 13) 12 13) => 12]
  [(if (fx< 12 12) 13 14) => 14]
  [(if (fx< 13 12) 13 14) => 14]
  [(if (fx<= 12 13) 12 13) => 12]
  [(if (fx<= 12 12) 12 13) => 12]
  [(if (fx<= 13 12) 13 14) => 14]
  [(if (fx> 12 13) 12 13) => 13]
  [(if (fx> 12 12) 12 13) => 13]
  [(if (fx> 13 12) 13 14) => 13]
  [(if (fx>= 12 13) 12 13) => 13]
  [(if (fx>= 12 12) 12 13) => 12]
  [(if (fx>= 13 12) 13 14) => 13])

(add-tests-with-string-output "remainder/modulo/quotient"
  [(fxquotient 16 4) => 4]
  [(fxquotient 5 2) => 2]
  [(fxquotient -45 7) => -6]
  [(fxquotient 10 -3) => -3]
  [(fxquotient -17 -9) => 1]

  [(fxremainder 16 4) => 0]
  [(fxremainder 5 2) => 1]
  [(fxremainder -45 7) => -3]
  [(fxremainder 10 -3) => 1]
  [(fxremainder -17 -9) => -8]

  ;  [(fxmodulo 16 4) => "0"]
  ;  [(fxmodulo 5 2) => "1"]
  ;  [(fxmodulo -45 7) => "4"]
  ;  [(fxmodulo 10 -3) => "-2"]
  ;  [(fxmodulo -17 -9) => "-8"]
)