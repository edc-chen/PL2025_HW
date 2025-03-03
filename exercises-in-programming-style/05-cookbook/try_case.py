s=['I', 'am', 'a', 'student']
a=s.copy()
b=s.copy()
print(id(s), id(a), id(b))
a.append('!')
print(id(s), id(a), id(b))
print(s, a, b)

