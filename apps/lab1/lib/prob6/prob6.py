
def prob6():
   sum_of_sq = sum(natural_number**2 for natural_number in range(1, 101))
   sq_of_sum = sum(natural_number for natural_number in range(1, 101))**2
   return sq_of_sum - sum_of_sq

print(prob6())