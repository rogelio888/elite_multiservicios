import hashlib
target_hash = 'f132abb8f9cb588e9cc1bbf9dde9affe08910c789705615e3a96c3a5f791d144'
for i in range(1000000):
    code = f'{i:06d}'
    if hashlib.sha256(code.encode()).hexdigest() == target_hash:
        print('FOUND CODE:', code)
        break
