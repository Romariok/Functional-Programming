fib1, fib2 = 1, 1
it = 2
while len(str(fib2))<1000:
   tmp = fib2+fib1
   fib1 = fib2
   fib2 = tmp
   it+=1
print(it)